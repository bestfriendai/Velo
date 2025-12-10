//
//  TemplateViewModel.swift
//  Velo
//
//  Created by Ky Vu on 12/10/25.
//

import Foundation
import Combine

/// ViewModel for template gallery and management
@MainActor
class TemplateViewModel: ObservableObject {
    // MARK: - Published Properties

    /// All available templates
    @Published var templates: [Template] = []

    /// Filtered templates for current category
    @Published var filteredTemplates: [Template] = []

    /// Currently selected category
    @Published var selectedCategory: TemplateCategory? = nil

    /// Whether we're loading templates
    @Published var isLoading = false

    /// Error message if loading fails
    @Published var errorMessage: String?

    /// Search query for filtering templates
    @Published var searchQuery = ""

    // MARK: - Private Properties

    private let supabaseService = SupabaseService.shared
    private var cancellables = Set<AnyCancellable>()
    private var currentUserRole: RoleType = .explorer

    // MARK: - Initialization

    init() {
        setupSearchObserver()
        Task {
            await loadUserRole()
            await loadTemplates()
        }
    }

    // MARK: - Setup

    private func setupSearchObserver() {
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] query in
                self?.filterTemplates(query: query)
            }
            .store(in: &cancellables)
    }

    private func loadUserRole() async {
        if let profile = supabaseService.currentUserProfile {
            currentUserRole = profile.roleType
            Logger.info("Loaded user role: \(currentUserRole.rawValue)", category: .app)
        }
    }

    // MARK: - Template Loading

    /// Load templates from database
    func loadTemplates() async {
        isLoading = true
        errorMessage = nil

        Logger.info("Loading templates for role: \(currentUserRole.rawValue)", category: .database)

        do {
            let loadedTemplates = try await supabaseService.fetchTemplates(for: currentUserRole)
            self.templates = loadedTemplates
            filterTemplates(query: searchQuery)

            Logger.info("Loaded \(loadedTemplates.count) templates", category: .database)
        } catch {
            Logger.error("Failed to load templates: \(error.localizedDescription)", category: .database)
            errorMessage = "Failed to load templates: \(error.localizedDescription)"

            // Fallback to sample templates
            self.templates = Template.samples.filter { $0.isAvailableFor(role: currentUserRole) }
            filterTemplates(query: searchQuery)
        }

        isLoading = false
    }

    // MARK: - Filtering

    /// Filter templates by category and search query
    private func filterTemplates(query: String) {
        var filtered = templates

        // Filter by category if selected
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }

        // Filter by search query
        if !query.isEmpty {
            filtered = filtered.filter { template in
                template.name.localizedCaseInsensitiveContains(query) ||
                template.description.localizedCaseInsensitiveContains(query) ||
                template.promptText.localizedCaseInsensitiveContains(query)
            }
        }

        self.filteredTemplates = filtered
    }

    /// Select a category to filter by
    func selectCategory(_ category: TemplateCategory?) {
        selectedCategory = category
        filterTemplates(query: searchQuery)
    }

    // MARK: - Template Actions

    /// Apply a template (returns the prompt text to use)
    func applyTemplate(_ template: Template) async -> String {
        Logger.info("Applying template: \(template.name)", category: .editing)

        // Increment usage count in background
        Task {
            try? await supabaseService.incrementTemplateUsage(templateId: template.id)
        }

        return template.promptText
    }

    /// Get templates grouped by category
    func templatesByCategory() -> [TemplateCategory: [Template]] {
        Dictionary(grouping: templates) { $0.category }
    }

    /// Get popular templates (sorted by usage count)
    func popularTemplates(limit: Int = 5) -> [Template] {
        templates
            .sorted { $0.usageCount > $1.usageCount }
            .prefix(limit)
            .map { $0 }
    }

    /// Get recommended templates for current user role
    func recommendedTemplates() -> [Template] {
        templates.filter { template in
            template.roleTags.contains(currentUserRole) || template.roleTags.isEmpty
        }
    }

    // MARK: - Cleanup

    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
