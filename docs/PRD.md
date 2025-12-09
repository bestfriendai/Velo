# iOS AI Photo Editing App - Idea Validation Report

## Executive Summary

**Overall Rating: 6.5/10** - Moderately Viable with Significant Challenges

Your AI photo editing app concept enters a rapidly growing but highly competitive market. While the timing is favorable given the 441% YoY growth in AI image editing software, success depends heavily on execution, differentiation, and user acquisition in a space dominated by well-funded competitors.

---

## Market Analysis

### Market Size & Growth ✅ STRONG POSITIVE
- **Photo editing app market**: Growing from $303.92M (2024) to projected $402.37M by 2032 (CAGR 3.57%)
- **AI image editor market**: Valued at $88.7B (2025), expected to reach $229.6B by 2035 (CAGR ~10%)
- **AI image editing category**: Fastest-growing software category of 2024 with **441% YoY growth**
- **iOS market**: Strong demand with high iPhone/iPad adoption and seamless ecosystem integration

**Verdict**: The market is expanding rapidly with significant consumer interest in AI-powered photo tools.

### User Adoption & Demand ✅ STRONG POSITIVE
- 20% of Americans use AI tools for image/video generation (2024)
- 40%+ of smartphone users in major markets regularly use AI photo editors
- 51% of photo editing apps include AI features
- Apps with AI features: 7.5 billion downloads in H1 2025 (10% of all downloads, +52% YoY)
- 56% of AI image generation users enjoyed the experience

**Verdict**: Strong and growing user acceptance of AI photo editing technology.

---

## Competitive Landscape

### Major Competitors ⚠️ HIGH COMPETITION

**Remini** (50M+ downloads, 5B+ enhanced images)
- Specialization: Photo enhancement, restoration, unblurring
- Pricing: $6.99-9.99/week, $4.99/month
- Strength: One-tap enhancement simplicity
- Market position: Viral success with old photo restoration

**Picsart** (150M+ monthly active users, 200M+ total users)
- Specialization: Comprehensive creative toolkit
- Features: AI image generation, background removal, filters, collages, stickers
- Pricing: $5-7/month (billed annually)
- Strength: Large creative community, diverse toolset

**PhotoRoom** (Strong e-commerce focus)
- Specialization: Background removal, product photography
- Pricing: ~$9.99/month
- Strength: Batch editing, professional templates for e-commerce

**Also**: Adobe Photoshop (iOS freemium with Firefly AI - launched Feb 2025), Google LLC, Lightricks, VSCO, Fotor, InShot, Polarr

**Verdict**: You're entering a crowded market with established players who have massive user bases, brand recognition, and significant resources.

---

## Your Concept: Strengths & Weaknesses

### Strengths ✅
1. **Specific use cases**: "Open kids' eyes, enhance lighting, change background" - concrete everyday problems
2. **Speed focus**: "Quick editing" addresses key user pain point (complexity/time)
3. **Template/prompt library**: Pre-defined prompts lower learning curve for casual users
4. **Inspiration gallery**: Helps users discover possibilities (reduces decision paralysis)
5. **Nano Banana backend**: Access to state-of-the-art AI model (Gemini 3 Pro Image)

### Weaknesses ⚠️
1. **Differentiation unclear**: Similar features to existing apps (background change, enhancement)
2. **Technology not proprietary**: Competitors can use same or similar AI models
3. **Late entry**: Market already has viral winners (Remini) and category leaders (Picsart)
4. **Cost structure concerns**: Nano Banana pricing ($0.02-0.24/image) may impact margins
5. **No unique IP or defensible moat**: Easy for competitors to replicate

---

## Technical Feasibility

### Nano Banana API Capabilities ✅ EXCELLENT

**Base Model (Gemini 2.5 Flash Image)**
- Targeted transformations with natural language
- Background blurring, stain removal, pose alterations
- Color enhancement (B&W to color)
- Cost: ~$0.02-0.039 per image

**Pro Model (Gemini 3 Pro Image)**
- 1K, 2K, 4K output quality
- Up to 14 reference images (consistency across edits)
- Long structured prompts (64K input, 32K output)
- Advanced text rendering within images
- Cost: $0.12-0.24 per image (4K)

**Third-party providers**: Can reduce costs by 20-50% vs official Google pricing

**Verdict**: Technology is robust and capable of delivering your proposed features. API integration is straightforward.

---

## User Pain Points You Could Address

### Current Market Frustrations
1. **Interface complexity**: Three-tiered navigation, overwhelming toolsets for casual users
2. **Performance issues**: Sluggish on older devices, slow loading
3. **Ads disrupting workflow**: Free apps have intrusive ads during editing
4. **AI over-reliance**: Too much automation, users want control
5. **Limited advanced features**: Casual apps lack depth, pro apps too complex

### How Your Concept Addresses These
- ✅ Pre-defined prompts/templates = simpler than manual editing
- ✅ "Quick" positioning = addresses speed/complexity pain point
- ⚠️ Need strong UX to avoid overwhelming users with choices
- ❌ Doesn't solve device performance issues (cloud-based could help)
- ❌ Monetization challenge: subscription or ads? Both have drawbacks

---

## Monetization Analysis

### Revenue Benchmarks
- **Photo & Video apps**: Highest success rates (27.57% reach $1K revenue in 2 years, 8.75% hit $10K)
- **Consumer app ARPU**: $1-10 typical range
- **Upper quartile apps**: 2.75x more than median after 14 days
- **Competitor pricing**: $4.99-9.99/month subscriptions
- **Hybrid models**: 35% of apps combine subscriptions + consumables
- **Retention warning**: 30% of annual subscriptions canceled in first month

### Cost Structure Concerns
With Nano Banana at $0.02-0.24 per image:
- If user generates 50 images/month: $1-12 in API costs
- Subscription at $6.99/month: Margin = -$5 to $6 (depending on Pro vs Base model usage)
- Need to carefully balance feature access with cost control
- Consider: credit-based model, usage limits, or tiered access

**Verdict**: Monetization is viable but requires careful cost management and user retention strategies.

---

## Critical Success Factors

### What Must Go Right ✅
1. **Exceptional UX**: Must be significantly simpler/faster than competitors
2. **Unique prompt library**: Curated, high-quality templates that solve real problems
3. **Viral feature**: One standout capability (like Remini's photo restoration)
4. **Marketing budget**: Competing with 150M+ user apps requires $ for user acquisition
5. **Cost optimization**: Smart API usage to maintain healthy margins
6. **Fast iteration**: Quick response to user feedback and market trends

### High-Risk Areas ⚠️
1. **User acquisition cost**: Getting noticed in crowded market
2. **Retention**: Keeping users engaged beyond first month (30% churn rate)
3. **Feature parity race**: Competitors can quickly copy successful features
4. **API dependency**: Reliant on Google's Nano Banana pricing/availability
5. **Platform restrictions**: Apple's 30% cut on subscriptions (15% after year 1)

---

## Strategic Recommendations

### Before Building
1. **Identify your ONE killer feature**: What will make users switch from Picsart/Remini?
   - Example: "Best for busy parents - one-tap fixes for kids' photos"
   - Example: "AI that understands context - 'make this photo Instagram-worthy'"

2. **Validate willingness to pay**: Survey target users on pricing expectations

3. **Prototype with no-code tools**: Test core concept before full development
   - Use existing APIs to validate prompt library approach
   - A/B test different UX patterns with small user group

4. **Calculate unit economics**:
   - API costs per user
   - Target conversion rate (free → paid)
   - Required user acquisition cost (CAC) to be profitable
   - Lifetime value (LTV) targets

### If You Proceed
1. **Niche down initially**: "Best photo editor for [specific use case]"
   - Parents/family photos
   - Pet owners
   - Real estate agents
   - Small business owners

2. **Build content moat**: Your prompt/template library should be 10x better than alternatives

3. **Plan for viral growth**:
   - Watermarks (optional removal for paid)
   - Easy sharing with before/after
   - Referral incentives

4. **Hybrid monetization**:
   - Freemium with limited edits/month
   - Credit system for heavy users
   - Subscription for unlimited access
   - One-time purchases for premium templates

5. **Consider Android timing**: iOS-first is smart for higher ARPU, but don't wait too long for Android (larger market share)

---

## Risk Assessment

### HIGH RISK 🔴
- **Market saturation**: Established competitors with massive user bases
- **Lack of differentiation**: Core features similar to existing apps
- **No defensible moat**: Technology easily replicable

### MEDIUM RISK 🟡
- **Cost structure**: API costs could erode margins if not managed
- **User acquisition**: Expensive to get noticed in crowded category
- **Retention**: High first-month churn typical in category

### LOW RISK 🟢
- **Technical feasibility**: API proven and reliable
- **Market timing**: AI photo editing still growing rapidly
- **User demand**: Demonstrated appetite for AI photo tools

---

## Final Verdict: 6.5/10 → REVISED TO 8/10 with Strategic Focus

### Original Rating Rationale
- Entering highly competitive market late
- Unclear differentiation from established players
- No obvious "unfair advantage" or unique IP
- Challenging unit economics with API costs

### Why Rating Increased to 8/10
**You have a SECRET WEAPON**: You're building for your wife—a REAL non-tech-savvy user who struggles with existing apps. This gives you:
1. **Built-in user research**: Daily feedback from target demographic
2. **Authentic pain point understanding**: Not theoretical market research
3. **Immediate validation loop**: Real user testing on demand
4. **Genuine motivation**: Solving real problem, not chasing trends

### Bottom Line
**This is NOW a "greenlight with focus" idea** IF you execute the strategy below.

---

# 🎯 THE KILLER DIFFERENTIATOR

## **"Just Tell It What You Want" - Voice/Text First Photo Editing**

### The Core Insight
Google Photos just launched voice-activated editing in August 2025, but it's ONLY for Pixel devices and buried inside Google Photos. **The market is WIDE OPEN for a standalone app that makes conversational editing the PRIMARY interface.**

### Why This Wins

**1. Eliminates Decision Fatigue** (The #1 pain point)
- Research shows: Adobe Lightroom has 100+ adjustment sliders causing analysis paralysis
- Users spend more time cycling through presets than actually editing
- Cognitive resource depletion during extended editing sessions
- **Your solution**: "Make my kid's eyes open" → Done. Zero decisions needed.

**2. Zero Learning Curve**
- Your wife (and millions like her) don't need to know what tools are called
- They just describe what they want: "Remove the person in the background"
- Natural language = accessible to elderly, non-tech-savvy, busy people

**3. Powered by Nano Banana's Strength**
- Gemini 3 Pro excels at natural language understanding
- Supports long, structured prompts (64K input)
- Can handle complex requests: "Make this look professional for my salon's Instagram"
- You're using the AI for what it's BEST at (language), not just image generation

**4. First-Mover Advantage in Standalone Market**
- Google Photos has it, but only Pixel users + locked in their ecosystem
- Canva has it, but it's buried in a complex design tool
- **No standalone mobile app has made conversational editing the MAIN feature**
- You can own this category: "The app where you just talk to edit"

### The Magic Moment (UX Flow)

```
User opens app → Camera roll appears
Taps photo → Photo fills screen with voice button (HUGE, center bottom)
Taps/holds voice button: "Make my daughter's eyes open and brighten the background"
App shows: "Opening eyes... ✓ Brightening background... ✓"
Result appears with before/after slider
User: "Perfect!" or "Make it less bright"
Done. Exported. 15 seconds total.
```

**No menus. No sliders. No filter carousel. Just conversation.**

### Fallback for Quiet Environments
- Voice OR text input (same AI processing)
- Pre-written common requests as quick-tap buttons:
  - "Fix my eyes (if closed/red)"
  - "Professional lighting"
  - "Clean background"
  - "Make it Instagram-ready"

### Why Competitors Can't Easily Copy

1. **Cultural positioning**: You're "the simple one" - if they add it, they'd have to simplify their ENTIRE app
2. **Voice-first is your brand**: Picsart/Remini are already known as "feature-rich" or "enhancement tools"
3. **Speed to market**: You can launch THIS MONTH with MVP while they're in planning committees
4. **Community moat**: Build template library from REAL user requests (see below)

---

# 🎯 THREE UNDERSERVED NICHES (Ranked by Opportunity)

## **#1 PRIORITY: Busy Local Business Owners (Hair Salons, Boutiques, Cafes)**

### Market Size & Validation
- 86% say high-quality photos attract customers willing to pay premium prices
- 9 out of 10 salon professionals say social media influences client choices
- 98% of real estate agents use licensed images (need editing constantly)
- 85%+ of real estate agents use AI for photo enhancements in 2025

### Pain Points (Validated by Research)
- **Time poverty**: "30 min/day on posts = 15 hours/month away from clients"
- **Low tech confidence**: "Complex UI or unfamiliar design patterns are overwhelming"
- **Need brand consistency**: Same logo placement, same filters, same style
- **Authenticity over perfection**: "Minimal editing preferred - don't let editing become the star"

### Your Solution (Role-Based Onboarding)
During onboarding, user selects: "I'm a hair salon owner"

**Auto-configured features:**
- **Brand kit setup**: Upload logo once → "Add my logo" voice command places it consistently
- **Before/After preset**: Automatically creates split-image template
- **Industry templates**:
  - "Make this salon-ready" (slightly enhanced, natural lighting, logo added)
  - "Remove messy background but keep it real"
  - "Fix overhead lighting" (common salon lighting issue)

**Saved Workflows:**
- "Client before/after" → Automatically creates side-by-side with logo
- "Story post" → Vertical format, subtle filter, brand colors
- "Quick post" → Square format, clean background, professional lighting

### Pricing Sweet Spot
- These users WILL pay ($5-10/month subscription)
- ROI is obvious: Better photos = more bookings
- Time savings = billable hours recovered
- Competition charges $9.99/month (PhotoRoom) for background removal alone

### Viral Growth Mechanism
- Optional watermark: "Edited with [YourApp] - Get it free"
- When clients see salon's great photos → "What do you use?"
- B2B word-of-mouth in local business communities

---

## **#2 NON-TECH-SAVVY EVERYDAY USERS (Your Wife's Demographic)**

### Market Size
- 40%+ of smartphone users in major markets use AI photo editors
- 20% of Americans use AI image tools (2024)
- 56% who tried AI image generation enjoyed it
- Elderly/aging population growing rapidly (design for them = design for everyone)

### Pain Points (Research-Validated)
- **Overwhelmed by choices**: 51% of photo apps have AI features, but too many options
- **Interface complexity**: Three-tiered navigation, overwhelming toolsets
- **Fear of making mistakes**: "Complex tasks feel daunting"
- **Don't know terminology**: What's "saturation"? "Curves"? "HSL"?

### Your Solution (Zero-Learning Interface)
**Onboarding:** "I just want to fix family photos"

**Pre-loaded common requests:**
- "Open my kid's eyes"
- "Fix the lighting"
- "Remove the background mess"
- "Make everyone's face clearer"
- "Change background to [beach/park/studio white]"
- "Fix red eyes"

**UX Principles (Research-Backed):**
1. **Simplicity is key**: Minimize complexity, reduce cognitive overload
2. **One thing at a time**: No multi-tiered menus or hamburger icons
3. **Big, clear buttons**: Main elements big and easy to see
4. **White space**: Uncluttered interface reduces cognitive load
5. **Text labels on everything**: Icons always paired with text ("Share", not just ⬆️)
6. **Chunking**: Break tasks into digestible steps with clear feedback
7. **Build confidence**: Clear feedback ("Opening eyes... ✓") reassures users

### Viral Moment
- Family photos are SHARED constantly
- Optional: "Edited with [App]" on exports
- When Grandma can use it → entire family downloads it

---

## **#3 REAL ESTATE AGENTS & PROPERTY MANAGERS**

### Market Validation (Strong!)
- Listings with high-quality edited images get **118% more online views**
- Properties sell **50% faster** with professional photos
- 85%+ of agents use AI for photo enhancement (2025)
- Drone photography in real estate growing at 18.1% CAGR (2025-2035)
- Agents actively outsource editing because they're too busy

### Pain Points
- **Tight deadlines**: Need same-day listing photos
- **Consistent style**: Every listing should look professional
- **Common fixes needed**:
  - Sky replacement (grey → blue)
  - Lighting correction (dim rooms)
  - Decluttering (remove personal items)
  - Virtual staging interest (but expensive elsewhere)

### Your Solution
**Onboarding:** "I'm a real estate agent"

**Pre-loaded templates:**
- "Real estate ready" (enhance lighting, fix vertical lines, clean)
- "Replace sky with sunset/blue sky"
- "Brighten dark rooms naturally"
- "Remove cars/trash from driveway"
- "Make it look move-in ready"

**Batch mode:**
- Select 20 photos → "Make all real estate ready" → Done
- Massive time saver vs editing one-by-one

**Competitive Advantage:**
- PhotoUp charges per-image editing fees
- Your app: Unlimited edits for $9.99/month
- Voice commands WAY faster than manual editing

### Revenue Potential
- Real estate agents have BUDGETS (not price-sensitive)
- Willing to pay $10-20/month easily
- High LTV (once they use it, they use it for EVERY listing)

---

# 🎨 EXCEPTIONAL UX IDEAS (Research-Backed)

## **1. The "Zero-State" Onboarding Flow**

### Problem Solved
- Paradox of choice: Too many options → analysis paralysis
- Users don't know what they want until they see it

### Your Solution: Role Selection (Not Feature Overload)

**Screen 1:** "Who are you?"
- 📸 Just fixing family photos (Everyday user)
- 💇 Hair/beauty salon owner
- 🏠 Real estate agent
- 🏪 Small business owner
- 👨‍🎨 Content creator / influencer

**Screen 2:** Shows 3-4 example transformations for THEIR role
- "Here's what [people like you] typically do:"
- Swipeable before/after cards
- Each card shows the voice command used
- Builds mental model immediately

**Screen 3:** "Try it now"
- Pre-loaded sample photo relevant to their role
- Voice button pulsing: "Tap and say what you want to change"
- First edit is FREE and instant (hooks them)

### Why This Works
- Eliminates 100+ features down to 3-5 relevant templates
- Shows rather than tells
- Instant gratification (see results in onboarding)
- Research: "Reduce options to avoid choice overload" (Amazon shows 4-7 options max)

---

## **2. Conversational Feedback Loop**

### Problem Solved
- Users don't know how to improve results
- Trial-and-error wastes time

### Your Solution: AI Suggests Refinements

After showing result:
```
User: "Make background beach"
[Shows result]
App suggests verbally/text:
  🗣️ "Want me to make it more realistic?"
  🗣️ "Should I adjust the lighting to match sunset?"
  🗣️ "Want to blur the background slightly?"
```

User just taps suggestion OR speaks refinement.

### Why This Works
- Educates users on what's possible WITHOUT overwhelming upfront
- Contextual learning (only shows relevant next steps)
- Feels like expert helping you, not tool you must master

---

## **3. "Inspiration Gallery" with Searchable Voice Commands**

### Problem Solved
- Users lack creative vision
- Don't know what AI can do
- Need examples to get started

### Your Solution: Community Template Library

**Feed of real user transformations** (anonymized):
- Before/After with the EXACT voice command used
- "Open closed eyes + brighten" → Shows result
- "Professional salon lighting" → Shows result
- "Beach background for family photo" → Shows result

**Search functionality:**
- Voice search: "Show me what people do for kids' photos"
- Returns relevant transformations + voice commands to copy

**One-tap apply:**
- See example you like → "Use this on my photo" → Done

### Why This Works
- Reduces decision fatigue (see what works, copy it)
- Builds community ("300 people used this today")
- Your prompt library becomes your MOAT (competitors have generic filters)
- User-generated content = infinite fresh templates

---

## **4. "Undo Tree" Not "Undo Stack"**

### Problem Solved
- Linear undo = if you go back 5 steps, you lose all progress
- Fear of experimentation

### Your Solution: Branch Timeline

Visual timeline at bottom showing:
```
Original → Eyes fixed → Brightened → Background changed
              ↓
           [Branch: Tried darker version]
```

**Tap any point to jump there** (non-destructive)
**Save multiple versions** without re-editing

### Why This Works
- Removes fear of "ruining it"
- Encourages experimentation
- Pro feature that delights users
- Hard for competitors to copy (requires good UX thinking)

---

## **5. Smart Context Awareness**

### Problem Solved
- Generic AI doesn't understand photo context
- Users have to be too specific

### Your Solution: Pre-Analysis

When photo is loaded, AI silently analyzes:
- Detects: Portrait, landscape, indoor, outdoor, people count, lighting quality
- Surfaces relevant suggestions:

**If detects closed eyes:**
  → Proactively suggests: "I noticed eyes are closed, want me to fix that?"

**If detects poor lighting:**
  → "This looks a bit dark, should I brighten it?"

**If detects busy background:**
  → "Want me to clean up the background?"

**User can accept or ignore** - but it shows intelligence

### Why This Works
- Feels magical (app "gets it")
- Reduces user thinking (they don't have to notice problems)
- Builds trust in AI capability
- Research: "Empathy-driven design builds confidence in non-tech users"

---

## **6. Adaptive Complexity**

### Problem Solved
- Beginners need simplicity
- Power users want control
- Same app, different needs

### Your Solution: Grows With User

**Beginner mode** (Default):
- ONLY voice/text input + one-tap templates
- Zero manual controls visible

**After 5+ edits:**
- App notices: "You're getting good at this! Want quick access to common commands?"
- Unlocks: Favorites bar with their most-used commands

**After 20+ edits:**
- "Ready for advanced mode?"
- Shows: Manual sliders ONLY if requested
- Still voice-first, but sliders available for fine-tuning

### Why This Works
- Progressive disclosure (don't overwhelm day 1)
- Respects user growth
- Prevents power users from leaving
- Research: "Chunking makes complex tasks feel manageable"

---

## **7. Batch Processing with Voice**

### Problem Solved
- Need to edit 20 photos from same event
- Tedious to repeat same edits

### Your Solution: Multi-Select + One Command

```
User selects 15 photos from salon day
Taps voice: "Make all of these salon-ready"
App processes all with same template
Shows grid of results
```

**Refinement option:**
- "Make photo 3, 7, and 12 brighter"
- Smart selection by speaking numbers

### Why This Works
- MASSIVE time save for business users
- Differentiates from one-at-a-time apps
- Justifies subscription cost immediately

---

## **8. "Teach Mode" for Onboarding Help**

### Problem Solved
- First-time users don't know what to ask
- Traditional tutorials are skipped

### Your Solution: In-Context Learning

**On first photo load:**
- Animated hand gesture pointing at voice button
- Shows example bubbles floating up:
  - "Try saying: 'Make it brighter'"
  - "Or: 'Open the eyes'"
  - "Or: 'Change background to beach'"

**Non-intrusive:** Fades after 3 seconds or first tap

**Available anytime:** "?" button → Shows example commands for current photo type

### Why This Works
- Learn by doing (not reading manual)
- Examples are contextual
- Respects user intelligence (hints, not handholding)

---

# 💰 REFINED MONETIZATION STRATEGY

## Hybrid Model (Optimized for Cost + Revenue)

### **Free Tier** (Acquisition)
- 5 edits per month
- Voice/text commands (all features)
- Watermark on exports: "Edited with [App]"
- Access to inspiration gallery

**Purpose:** Get people hooked, viral spread via watermarks

### **Pro Monthly** ($6.99/month)
- Unlimited edits
- No watermarks
- Batch processing (up to 20 photos)
- Brand kit (logo upload, 1 template)
- Priority processing

**Target:** Everyday users, casual business owners

### **Business Tier** ($14.99/month)
- Everything in Pro
- Unlimited batch processing
- Multiple brand kits (5 templates)
- Custom template saving
- Team sharing (2-3 seats)
- Analytics (which edits used most)

**Target:** Hair salons, real estate agents, serious businesses

### **Credit Top-Ups** (Consumable IAP)
- For free users who hit limit mid-month
- $2.99 = 10 extra edits
- Converts ~15% of free users to paying (per research)

## Cost Management

### Use Nano Banana Strategically

**Base model ($0.02/image)** for:
- Simple enhancements (brightness, eyes, basic cleanup)
- Saves 90% vs Pro model

**Pro model ($0.12-0.24/image)** for:
- Background replacements
- Complex transformations
- 4K exports (Business tier only)

**Smart routing:**
- AI determines which model needed based on request
- "Make it brighter" → Base model
- "Change background to beach sunset 4K" → Pro model

### Margin Analysis

**Average user:** 30 edits/month
- 70% simple (Base): 21 × $0.02 = $0.42
- 30% complex (Pro): 9 × $0.12 = $1.08
- **Total cost:** $1.50/user

**Revenue:** $6.99/month
**Gross margin:** $5.49 (78% margin)

**Business tier user:** 100 edits/month
- Cost: ~$5-7
- Revenue: $14.99
- **Margin:** $8-10 (60-67%)

**Healthy economics even with heavy usage.**

---

# 🚀 GO-TO-MARKET STRATEGY

## Phase 1: Wife + Friends (Week 1-2)
- Your wife uses it daily
- Invite her 10 friends (varied demographics)
- Obsessively watch what they struggle with
- Iterate UX based on real confusion points

## Phase 2: Soft Launch (Month 1)
- TestFlight with 100 users
- Target: Local business Facebook groups
  - "Free photo editing app for salon owners - beta testers wanted"
- Collect voice command data (what people actually ask for)

## Phase 3: Template Library Seeding (Month 2)
- Use beta user requests to build top 50 templates
- Create inspiration gallery
- Ensure each niche (salon, real estate, family) has 15+ examples

## Phase 4: Public Launch (Month 3)
- Launch with STRONG positioning: "The photo editor where you just talk"
- Press angle: "Anti-complexity app for people overwhelmed by Photoshop"
- Target tech blogs: "Google Photos has voice editing for Pixel—this app brings it to everyone"

## Phase 5: Niche Communities (Month 3-6)
- Partner with salon/beauty influencers
- Real estate agent Facebook groups
- Parenting subreddits/forums
- Senior-friendly tech communities

---

# 🎯 SUCCESS METRICS

## Leading Indicators (First 90 Days)
- **Activation rate:** % who complete first edit in session 1 (Target: >60%)
- **"Aha moment" speed:** Time to first successful edit (Target: <60 seconds)
- **Repeat usage:** % who edit 2+ photos in first week (Target: >40%)
- **Voice adoption:** % using voice vs text (Target: >30% voice)

## Lagging Indicators (6-12 Months)
- **Conversion:** Free → Paid (Target: 10-15%)
- **Retention:** Month 2 retention (Target: >40%)
- **LTV:** Lifetime value (Target: $50+ for Pro, $150+ for Business)
- **Viral coefficient:** Watermark → Install rate (Track via UTMs)

---

# ⚠️ RISKS & MITIGATION

## Risk 1: Google Expands Voice Editing Beyond Pixel
**Mitigation:**
- You're standalone + faster
- They're bloated ecosystem app
- Your brand = simplicity (their brand = features)

## Risk 2: Voice Commands Misunderstood
**Mitigation:**
- Show interpreted request before processing: "I'll open the eyes and brighten. Sound good?"
- Easy redo with refinement
- Fall back to text input always available

## Risk 3: API Costs Spike
**Mitigation:**
- Cap free tier at 5 edits (most won't hit it)
- Business tier profitable even at 100 edits
- Can negotiate volume pricing with Nano Banana providers

## Risk 4: Not Enough Viral Growth
**Mitigation:**
- Mandatory watermark on free tier
- Referral program: "Give 5 free edits, get 5 free edits"
- Business tier users are walking billboards (their clients ask)

---

---

# 📋 FINAL RECOMMENDATION

## Rating: **8/10** - Strong Green Light with Clear Strategy

### Your Unfair Advantages
1. **Real user validation**: Your wife = living beta tester
2. **Killer differentiator**: Voice/text-first conversational editing (market gap)
3. **Growing market**: 441% YoY growth, 40%+ user adoption
4. **Healthy economics**: 60-78% gross margins even with heavy API usage
5. **Multiple monetization paths**: B2C (everyday users) + B2B (businesses)

### What Makes This Work
**You're not building "another photo editor"** - you're building:
- **The anti-complexity app** for people overwhelmed by Picsart/Photoshop
- **The voice-first editor** that Google Photos only has for Pixel users
- **The role-based solution** that understands salon owners ≠ parents ≠ real estate agents

### Critical Success Factors (Must Execute)
1. ✅ **Voice/text interface MUST be flawless** - this is your entire brand
2. ✅ **Onboarding MUST segment users by role** - generic = death
3. ✅ **First edit MUST happen in <60 seconds** - hook them immediately
4. ✅ **Template library MUST be superior** - this is your moat
5. ✅ **Your wife MUST love using it daily** - if she doesn't, no one will

### Next Steps (In Order)
1. **Validate with your wife** (Week 1-2): Build paper prototypes, test voice commands she'd actually say
2. **Build MVP** (Month 1): Core voice editing + 3 role-based onboardings
3. **TestFlight beta** (Month 2): 50-100 real users from target niches
4. **Iterate ruthlessly** (Month 2-3): Fix what confuses people
5. **Public launch** (Month 3-4): With strong positioning: "Just tell it what you want"

### Red Flags to Watch For
- ❌ If voice recognition accuracy < 90% → Fix before launch
- ❌ If wife still opens other apps → You haven't solved the problem
- ❌ If beta users ask "how do I..." → UX isn't simple enough
- ❌ If conversion rate < 5% after Month 1 → Pricing/value prop issue

### The Bottom Line
This idea went from **6.5/10 (proceed with caution)** to **8/10 (strong green light)** because:
- You found a CLEAR differentiator (voice-first conversational editing)
- You identified REAL niches with VALIDATED pain points
- You have a REAL user (your wife) to validate with daily
- The economics work (78% margins if executed well)

**Build this. But ONLY if you commit to the voice-first positioning.** That's your entire competitive advantage. Remove it, and you're just another photo editor.

---

## Sources

**Market Analysis:**
- [Photo Editing App Market Size & Trends](https://www.verifiedmarketresearch.com/product/photo-editing-app-market/)
- [2025 iPhone Editing Trends](https://www.accio.com/business/iphone-editing-trend)
- [Photo Editing Software Market Growth](https://www.expertmarketresearch.com/reports/photo-editing-software-market)
- [50 AI Image Statistics for 2025](https://www.photoroom.com/blog/ai-image-statistics)
- [State of AI Apps Report 2025](https://sensortower.com/blog/state-of-ai-apps-report-2025)

**Technology & Voice Editing:**
- [Nano Banana Pro API Capabilities](https://kie.ai/nano-banana)
- [Gemini 2.5 Flash Image Introduction](https://developers.googleblog.com/en/introducing-gemini-2-5-flash-image/)
- [Nano Banana Pro API Pricing Guide](https://www.cursor-ide.com/blog/nano-banana-pro-api-pricing-free)
- [Google Photos Voice Editing Launch](https://petapixel.com/2025/08/20/you-can-now-edit-images-in-google-photos-using-only-your-voice/)
- [Voice-Command Photo Editing on Android](https://www.technology.org/2025/09/24/google-photos-now-has-voice-guided-ai-photo-editing-on-android/)

**Competitors:**
- [Picsart vs Remini Comparison 2025](https://www.fahimai.com/picsart-vs-remini)
- [Remini vs Picsart Features](https://openart.ai/blog/post/remini-vs-picsart)
- [PhotoRoom vs Picsart](https://photoroomaiapks.org/photoroom-vs-picsart/)
- [Best AI Photo Editors 2025](https://www.perfectcorp.com/consumer/blog/online-photo-editing/10-best-ai-photo-editor-apps)

**User Research & UX:**
- [Photo Editing UX Case Study](https://uxdesign.cc/enhancing-polarrs-photo-editing-experience-for-novice-photographers-a-ux-case-study-643b386d57f8)
- [Photo Editing Apps UX Design](https://www.superside.com/blog/ux-design-series-photo-editing-apps)
- [UX for Elderly Users](https://cadabra.studio/blog/ux-for-elderly/)
- [Building UI/UX for Non-Tech-Savvy Users](https://lightweightsolutions.co/building-ui-ux-for-non-tech-savvy-users-designing-for-digital-literacy/)
- [Paradox of Choice in Photo Editing](https://fstoppers.com/post-production/paradox-choice-photo-editing-why-unlimited-options-create-worse-results-704022)
- [Decision Fatigue in UX Design](https://www.nngroup.com/articles/simplicity-vs-choice/)

**Niche Markets:**
- [Salon Social Media Ideas 2025](https://zolmi.com/salon-social-media/ideas)
- [Real Estate Photo Editing Trends 2025](https://beatcolor.com/blog/photo-video-editting/2025_real_estate_photo_editing_trends_whats_new-in-property-marketing/)
- [Real Estate Photography Statistics](https://www.photoup.net/learn/key-real-estate-photography-statistics)
- [AI Photo Editors for Small Businesses](https://www.photoroom.com/blog/ai-photo-editors-small-businesses)
- [Time-Saving Social Media Tools](https://adventureweddingacademy.com/social-media-management-tools-for-photographers/)

**Monetization:**
- [State of Subscription Apps 2025](https://www.revenuecat.com/blog/company/the-state-of-subscription-apps-2025-launch/)
- [App Monetization Strategies 2025](https://agamitechnologies.com/blog/mobile-app-monetization-strategies-2025)
- [Remini AI App Statistics](https://www.expertappdevs.com/blog/remini-ai-app-statistics)
- [Lensa AI Revenue Statistics](https://www.businessofapps.com/data/lensa-ai-statistics/)

---
---

# 🎯 VELO - PRODUCT REQUIREMENTS DOCUMENT (PRD)

**Last Updated:** December 9, 2025
**Version:** 1.0
**Status:** Phase 1 - MVP Specification

---

## 1. EXECUTIVE SUMMARY

### Product Vision
Velo is a voice/text-first AI photo editing app that eliminates decision fatigue for non-tech-savvy users. Instead of navigating complex menus and sliders, users simply tell the app what they want: "Open my kid's eyes and brighten the background" → Done.

### Problem Statement
- 51% of photo editing apps overwhelm users with features
- Average user spends more time browsing presets than actually editing
- Complex terminology (HSL, curves, saturation) alienates casual users
- Existing apps designed for professionals, not everyday users

### Solution
Voice-first conversational editing powered by Nano Banana (Gemini 3 Pro Image API) with role-based personalization that understands the difference between a parent fixing family photos vs a salon owner creating Instagram content.

### Success Criteria
- **Activation:** >60% of users complete first edit in session 1
- **Speed:** First edit happens in <60 seconds
- **Retention:** >40% return to edit 2+ photos in first week
- **Voice Adoption:** >30% of users try voice input
- **Conversion:** 10-15% free → paid within 90 days

---

## 2. TARGET USERS & PERSONAS

### Primary Personas (MVP)

#### Persona 1: "Busy Parent Sarah"
- **Demographics:** 32-45, parent of 2-3 kids, iPhone user
- **Pain Points:**
  - Kids blink/make faces in photos
  - No time to learn complex apps
  - Just wants "good enough" photos for sharing
- **Use Cases:** Fix closed eyes, remove background clutter, brighten group photos
- **Technical Skill:** Low (uses 3-5 apps total)
- **Willingness to Pay:** $5-7/month if saves time

#### Persona 2: "Salon Owner Maria"
- **Demographics:** 28-40, owns small beauty business, heavy Instagram user
- **Pain Points:**
  - Needs consistent branding across posts
  - Spends 30+ min/day editing client photos
  - Salon lighting is terrible (overhead fluorescent)
- **Use Cases:** Before/after client transformations, logo placement, lighting fixes
- **Technical Skill:** Medium (comfortable with social media, but not Photoshop)
- **Willingness to Pay:** $10-15/month (ROI obvious: time = money)

#### Persona 3: "Real Estate Agent Tom"
- **Demographics:** 35-55, tech-comfortable but time-poor, manages 5-10 listings
- **Pain Points:**
  - Tight deadlines (listing photos needed same-day)
  - Needs consistent professional look
  - Common fixes: dark rooms, grey skies, clutter
- **Use Cases:** Batch edit 20 property photos, sky replacement, lighting correction
- **Technical Skill:** Medium-High (uses multiple business tools)
- **Willingness to Pay:** $15-20/month (high LTV customer)

### Secondary Personas (Phase 2)
- Content creators / influencers
- Pet owners (niche: pet photography)
- Event photographers (small business)

---

## 3. CORE FEATURES & REQUIREMENTS

### 3.1 Voice/Text Editing (CRITICAL - The Differentiator)

**User Story:** As a user, I want to describe what I want changed in natural language so I don't need to learn complex tools.

**Requirements:**
- **Voice Input:**
  - Tap-and-hold microphone button (large, center-bottom of screen)
  - Uses Apple Speech Framework (SFSpeechRecognizer)
  - Real-time transcription display while speaking
  - Supports English (US) at MVP, Spanish/Chinese in Phase 2
  - Accuracy target: >90% transcription accuracy in quiet environments

- **Text Input:**
  - Always available as fallback (text field below voice button)
  - Same processing pipeline as voice
  - Autocomplete with common commands (learned from usage)

- **Natural Language Processing:**
  - User says: "Open my daughter's eyes and make the background brighter"
  - App interprets: 2 edits → ["fix closed eyes", "brighten background"]
  - Shows confirmation: "I'll fix the eyes and brighten the background. Sound good?"
  - User confirms → Sends to Nano Banana API via backend

- **Command Examples (MVP Must-Support):**
  - "Make it brighter / darker"
  - "Fix closed eyes / red eyes"
  - "Remove background / Change background to [beach/white/blur]"
  - "Make it look professional / Instagram-ready"
  - "Add my logo" (Business users with brand kit)
  - "Enhance lighting / Fix overhead lighting"
  - "Remove [object] from photo"

**Acceptance Criteria:**
- ✅ User can speak OR type command
- ✅ App displays interpreted command for confirmation
- ✅ Processing shows progress ("Fixing eyes... ✓")
- ✅ Result appears in <5 seconds (simple edits) or <15 seconds (complex)
- ✅ User can refine: "Make it less bright" → Adjusts previous edit

**Technical Implementation:**
- iOS: SFSpeechRecognizer for voice → text
- Backend: Supabase Edge Function parses text → constructs Nano Banana prompt
- AI Model Selection: Simple edits use Base model ($0.02), complex use Pro ($0.12)

---

### 3.2 Role-Based Onboarding (CRITICAL)

**User Story:** As a first-time user, I want the app to understand my specific needs so I only see relevant features.

**Requirements:**

**Screen 1: Role Selection**
- Full-screen gradient background (brand colors)
- Large heading: "Who are you?"
- 4-5 role cards with icons + descriptions:
  1. 📸 **Everyday User** - "Fix family photos quickly"
  2. 💇 **Salon/Beauty Owner** - "Professional client photos"
  3. 🏠 **Real Estate Pro** - "Fast property photo editing"
  4. 🏪 **Small Business** - "Social media content creation"
  5. 👨‍🎨 **Just Exploring** - "I want to see what's possible"

**Screen 2: Role-Specific Examples**
- Shows 3 before/after examples for selected role
- Swipeable carousel
- Each card displays:
  - Before/after photo (with slider)
  - Voice command used (e.g., "Make this salon-ready")
  - Result achieved
- Button: "Try it yourself"

**Screen 3: First Edit Tutorial**
- Pre-loaded sample photo (relevant to role)
- Large pulsing voice button
- Overlay text: "Try saying: 'Make it brighter'"
- User speaks → App processes → Shows result
- Success confetti animation
- Button: "Start editing my photos"

**Post-Onboarding:**
- User role stored in local UserDefaults + synced to Supabase user profile
- Templates filtered by role (Salon owner sees "Salon-ready", not "Real estate ready")
- Quick-tap suggestions personalized (Parents see "Fix eyes", Agents see "Brighten room")

**Acceptance Criteria:**
- ✅ User selects role in <10 seconds
- ✅ Sees 3 relevant examples in <5 seconds
- ✅ Completes first practice edit successfully
- ✅ Can skip/change role later in Settings

---

### 3.3 Photo Selection & Management

**User Story:** As a user, I want to quickly pick a photo and start editing immediately.

**Requirements:**

**Photo Import:**
- Opens directly to iOS PhotosPicker (PHPickerViewController)
- Allows single or multi-select (up to 20 for batch, Pro/Business only)
- Displays thumbnails in grid (3 columns)
- Shows photo metadata: date taken, size

**Photo Storage:**
- **Original photos:** Stored ONLY on device (never uploaded)
- **Edited photos:**
  - Saved to iOS Photos library (user permission required)
  - Optionally synced to Supabase Storage (if user creates account)
  - Watermarked if free tier

**Edit History:**
- Local: CoreData stores edit sessions with pointers to Photos library IDs
- Cloud (if signed in): Supabase `edits` table stores edit metadata
- Each edit session includes:
  - Original photo reference
  - Commands used (array of text strings)
  - Timestamp
  - AI model used (Base vs Pro)
  - Result image URL (if synced to cloud)

**Acceptance Criteria:**
- ✅ Photo picker opens in <1 second
- ✅ Selecting photo transitions to editor in <2 seconds
- ✅ Edited photos save to library with one tap
- ✅ User can view edit history (list of past edits)

---

### 3.4 Templates Library

**User Story:** As a user who doesn't know what to ask for, I want pre-made templates so I can see what's possible.

**Requirements:**

**Template Structure:**
- Each template contains:
  - Name (e.g., "Salon Before/After")
  - Description ("Creates side-by-side with your logo")
  - Preview thumbnail
  - Nano Banana prompt (hidden from user)
  - Role tags (which personas see this)
  - Usage count (for popularity sorting)

**Template Categories (MVP):**
1. **Quick Fixes**
   - "Fix Closed Eyes"
   - "Remove Red Eyes"
   - "Brighten Photo"
   - "Professional Lighting"

2. **Backgrounds**
   - "Beach Sunset"
   - "Studio White"
   - "Blur Background"
   - "Remove Background"

3. **Business (Role-Gated)**
   - "Salon Before/After" (Salon owners only)
   - "Real Estate Ready" (Agents only)
   - "Add My Logo" (Business tier only)

4. **Seasonal (Future)**
   - "Holiday Card"
   - "Summer Vibes"

**UI Implementation:**
- Horizontal scrollable rows, grouped by category
- Tap template → Photo picker → Apply to selected photo
- Star icon to favorite templates (appears at top)
- Search bar with voice search: "Show me templates for kids' photos"

**Backend:**
- Supabase `templates` table:
  - Columns: id, name, description, prompt_text, role_tags, preview_url, usage_count
  - Row Level Security: Public read access
  - Admin panel (future) for adding templates without app update

**Acceptance Criteria:**
- ✅ User sees 15+ templates on first load
- ✅ Templates load in <2 seconds
- ✅ Tapping template → selecting photo → result in <20 seconds
- ✅ Templates filtered by user's role (Salon owner sees salon templates)

---

### 3.5 Editing Interface

**User Story:** As a user editing a photo, I want a clean interface focused on voice input.

**Requirements:**

**Screen Layout:**
```
┌─────────────────────────────┐
│  [←] [Share] [History] [⚙️]  │  ← Top bar (translucent)
│                             │
│                             │
│       [PHOTO PREVIEW]       │  ← Main photo (full screen)
│       (Pinch to zoom)       │
│                             │
│                             │
├─────────────────────────────┤
│ "Make it brighter"          │  ← Last command (faded)
├─────────────────────────────┤
│  [🎤 Tap to speak]          │  ← Voice button (LARGE)
│  Or type your command...    │  ← Text input field
└─────────────────────────────┘
```

**Interaction Flow:**
1. Photo displays full-screen with zoom/pan enabled
2. User taps voice button → Records → Transcribes in real-time
3. On release: Shows confirmation modal: "I'll [action]. Sound good?"
4. User taps "Yes" → Shows progress ("Brightening... 40%")
5. Result fades in with before/after slider enabled
6. User drags slider to compare
7. Options: "Undo" / "Refine" / "Done"

**Progress Indicators:**
- Text: "Fixing closed eyes... ✓"
- Progress bar (0-100%)
- Animated icon (sparkles around edited area)

**Undo Tree (Phase 2):**
- Visual timeline at bottom showing edit history
- Tap any step to jump back (non-destructive)
- Branch visualization if user tries multiple variations

**Acceptance Criteria:**
- ✅ Photo displays immediately on selection
- ✅ Voice button is obvious (>=80pt height)
- ✅ Command confirmation prevents accidental edits
- ✅ Progress updates every 2 seconds
- ✅ Before/after slider is smooth (60fps)

---

### 3.6 Authentication & Accounts

**User Story:** As a user, I want to start editing immediately without creating an account, but have the option to sync later.

**Requirements:**

**Anonymous Authentication (Default):**
- App auto-creates anonymous Supabase account on first launch
- UUID stored in iOS Keychain
- User can edit 5 photos/month (free tier limit)
- No email/password required
- Edit history stored locally only

**Account Upgrade Flow:**
- Triggered when:
  1. User hits 5 edit limit → "Want unlimited edits?"
  2. User taps "Sync My Edits" in Settings
  3. User attempts to purchase subscription

- **Upgrade Options:**
  1. **Sign in with Apple** (Primary, required by Apple)
     - One-tap authentication
     - Email shared or hidden (user choice)
     - Supabase Auth converts anonymous → full account

  2. **Email/Password** (Secondary)
     - Simple form: Email + Password + Confirm
     - Email verification required

**Account Benefits:**
- Edit history synced across devices
- Access to brand kits (upload logo)
- Subscription management
- Cloud storage for edited images (optional)

**Backend Implementation:**
- Supabase Auth handles anonymous → authenticated conversion
- User table schema:
  ```sql
  users (
    id uuid primary key,
    created_at timestamp,
    email text,
    role_type text, -- 'parent', 'salon', 'realtor', 'business'
    subscription_tier text, -- 'free', 'pro', 'business'
    edits_this_month int,
    brand_kit_id uuid references brand_kits(id)
  )
  ```

**Acceptance Criteria:**
- ✅ User can edit photos without account creation
- ✅ Anonymous → Sign in with Apple in <5 taps
- ✅ Account upgrade preserves edit history
- ✅ 5 edit limit enforced for anonymous users (resets monthly)

---

### 3.7 Subscriptions & Monetization

**User Story:** As a user who loves the app, I want to unlock unlimited edits and remove watermarks.

**Requirements:**

**Free Tier:**
- 5 edits per month (resets on calendar month)
- All voice/text editing features
- All templates accessible
- Watermark on exported photos: "Edited with Velo - Get it free"
- Cannot upload brand kit

**Pro Tier - $6.99/month:**
- **Unlimited edits**
- No watermarks
- Batch processing (up to 20 photos)
- 1 brand kit (upload logo)
- Priority processing (Pro model access)
- Edit history sync

**Business Tier - $14.99/month:**
- Everything in Pro
- **Unlimited batch processing**
- 5 brand kits (multiple businesses/clients)
- Custom template saving
- Team sharing (2-3 seats)
- Usage analytics dashboard (Phase 2)

**Credit Top-Ups (Consumable IAP):**
- $2.99 = 10 extra edits (for free users mid-month)
- $4.99 = 25 edits
- Credits never expire

**Implementation:**

**StoreKit 2:**
- Auto-renewable subscriptions (1 month, 12 months)
- Consumables for credit packs
- Transaction verification via RevenueCat webhook

**RevenueCat Integration:**
- Manages subscription state across iOS/Android (future)
- Provides paywalls (customizable UI)
- Handles receipt validation
- Webhooks to Supabase for user entitlement updates

**Paywall Triggers:**
- 5th edit attempt → "You've used all your free edits this month"
- Batch selection (>1 photo) → "Batch editing is Pro only"
- Brand kit upload → "Upload your logo with Pro"
- Template save → "Save custom templates with Business"

**Acceptance Criteria:**
- ✅ Free tier limit enforced (5 edits/month)
- ✅ Subscription purchase completes in <30 seconds
- ✅ Pro features unlock immediately after purchase
- ✅ Watermark removed on all future edits (not retroactive)
- ✅ Subscription status synced across devices

---

### 3.8 Backend & AI Processing

**User Story:** As the system, I need to securely process user commands and generate edited images.

**Requirements:**

**Architecture:**
```
iOS App (SwiftUI)
    ↓
Supabase Edge Function (Deno/TypeScript)
    ↓
Nano Banana API (Gemini 3 Pro Image)
    ↓
Return edited image URL
    ↓
iOS downloads & displays result
```

**Supabase Edge Function: `process-edit`**

**Input (POST request):**
```json
{
  "user_id": "uuid",
  "command_text": "open the eyes and brighten background",
  "image_base64": "data:image/jpeg;base64,...",
  "user_tier": "free" | "pro" | "business"
}
```

**Processing Steps:**
1. Verify user authentication (JWT token)
2. Check edit quota (if free tier, count edits this month)
3. Parse command_text → Determine Nano Banana prompt
4. Select AI model:
   - Simple ("brighter", "fix eyes") → Base model ($0.02)
   - Complex ("change background", "4K") → Pro model ($0.12)
5. Call Nano Banana API with constructed prompt
6. Receive edited image
7. Upload to Supabase Storage (if user has account)
8. Add watermark if free tier
9. Log edit to `edits` table
10. Return response

**Output (JSON response):**
```json
{
  "success": true,
  "edited_image_url": "https://cdn.supabase.co/...",
  "edits_remaining": 3,
  "model_used": "base",
  "processing_time_ms": 4200
}
```

**Error Handling:**
- Quota exceeded → 402 Payment Required
- Invalid command → 400 Bad Request with suggestion
- Nano Banana timeout → Retry once, then 504 Gateway Timeout
- Image too large (>10MB) → 413 Payload Too Large

**Database Schema:**

**`edits` table:**
```sql
create table edits (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users(id),
  created_at timestamp default now(),
  command_text text not null,
  original_image_url text, -- Only if synced
  edited_image_url text,
  model_used text, -- 'base' or 'pro'
  processing_time_ms int,
  cost_usd decimal(10,4) -- For analytics
);
```

**`templates` table:**
```sql
create table templates (
  id uuid primary key default uuid_generate_v4(),
  name text not null,
  description text,
  prompt_text text not null,
  role_tags text[], -- ['parent', 'salon', 'realtor']
  preview_url text,
  usage_count int default 0,
  is_active boolean default true
);
```

**`brand_kits` table:**
```sql
create table brand_kits (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users(id),
  name text not null, -- "Hair Salon Logo"
  logo_url text not null,
  created_at timestamp default now()
);
```

**Acceptance Criteria:**
- ✅ Edge Function processes simple edits in <5 seconds
- ✅ Complex edits complete in <15 seconds
- ✅ Quota enforcement accurate (no double-counting)
- ✅ Watermarks applied correctly on free tier
- ✅ Costs tracked per edit for analytics

---

### 3.9 Push Notifications (Phase 1 MVP)

**User Story:** As a user waiting for my edit to process, I want a notification when it's ready.

**Requirements:**

**Use Cases:**
- Edit processing complete: "Your photo is ready!"
- Subscription expiring: "Your Pro plan renews in 3 days"
- Monthly edit reset: "You have 5 new free edits this month!"

**Implementation:**
- Apple Push Notification Service (APNs)
- Supabase Edge Function triggers push via APNs HTTP/2 API
- User grants permission on first app open (after onboarding)

**Notification Types:**
1. **Edit Complete** (High priority, sound + banner)
   - Title: "Edit Complete"
   - Body: "Your brightened photo is ready!"
   - Deep link: Opens to edit result screen

2. **Subscription Alert** (Normal priority)
   - Title: "Renewal Reminder"
   - Body: "Your Pro plan renews in 3 days ($6.99)"

3. **Monthly Reset** (Normal priority)
   - Title: "New Month, New Edits"
   - Body: "You have 5 free edits available!"

**Acceptance Criteria:**
- ✅ User receives notification when edit completes (if backgrounded)
- ✅ Tapping notification opens to result screen
- ✅ User can disable notifications in Settings

---

## 4. NON-FUNCTIONAL REQUIREMENTS

### 4.1 Performance
- **Cold start:** App opens in <2 seconds
- **Photo loading:** Displays selected photo in <1 second
- **Edit processing:**
  - Simple (Base model): <5 seconds
  - Complex (Pro model): <15 seconds
- **Template loading:** <2 seconds
- **Smooth animations:** 60fps on iPhone 12 and newer

### 4.2 Scalability
- **Concurrent users:** Support 10,000 daily active users at MVP
- **Supabase free tier limits:**
  - Database: 500MB (sufficient for 50k users @ 10KB/user)
  - Storage: 1GB (stores only metadata, not images at MVP)
  - Edge Functions: 2M invocations/month (sustainable at 100 edits/user/month)
- **Cost projections:**
  - Free tier user: $0.10/month (2 API calls @ $0.02 each)
  - Pro user: $2/month (30 edits, mixed models)
  - Break-even: 2-3 pro subscribers cover 10 free users

### 4.3 Security
- **API Keys:** Stored in Supabase Edge Functions (never client-side)
- **Authentication:** Supabase JWT tokens with row-level security
- **Image privacy:** Original photos NEVER leave device without explicit user consent
- **HTTPS:** All API calls encrypted via TLS 1.3
- **App Transport Security:** iOS enforces HTTPS-only
- **Data retention:** Anonymous user data deleted after 90 days of inactivity

### 4.4 Accessibility
- **VoiceOver support:** All buttons labeled, photos described
- **Dynamic Type:** Text scales with iOS system settings
- **Color contrast:** WCAG AA compliance (4.5:1 minimum)
- **Reduced motion:** Respects iOS accessibility setting
- **Haptic feedback:** Confirms voice recording start/stop

### 4.5 Localization (Phase 2)
- **MVP:** English (US) only
- **Phase 2:** Spanish (Mexico), Chinese (Simplified)
- **Voice recognition:** SFSpeechRecognizer supports 50+ languages
- **UI strings:** Localized via NSLocalizedString

---

## 5. USER FLOWS

### 5.1 First-Time User Flow

```
1. App opens → Shows onboarding
2. User selects role ("Everyday User")
3. Sees 3 example before/afters for family photos
4. Taps "Try it yourself"
5. Practice photo appears with voice button pulsing
6. User says "Make it brighter"
7. App processes (3 seconds)
8. Result appears with confetti animation
9. "Start editing your photos" button
10. Transitions to photo picker
11. User selects family photo
12. Editing interface appears
13. User says "Fix the eyes and brighten it"
14. App processes (5 seconds)
15. Shows before/after slider
16. User drags slider, satisfied
17. Taps "Save"
18. Photo saved to library (no watermark on first edit)
19. Prompt: "Want to edit another?" → Returns to picker

Total time to first edit: ~60 seconds ✅
```

### 5.2 Returning User Flow (Free Tier)

```
1. App opens → Directly to photo picker (skips onboarding)
2. User selects photo
3. Says "Change background to beach"
4. App processes (7 seconds, Pro model)
5. Shows result
6. User refines: "Make the beach more realistic"
7. App reprocesses (6 seconds)
8. Satisfied → Saves
9. Sees watermark on export
10. Returns to picker automatically

Total time: ~30 seconds from open to save
Edits used this month: 3/5 (shows in top-right corner)
```

### 5.3 Subscription Purchase Flow

```
1. User on 6th photo → Taps "Edit"
2. Paywall modal appears:
   "You've used all 5 free edits this month"
   [See your options]
3. Taps "See options"
4. RevenueCat paywall shows:
   - Pro Monthly: $6.99/mo
   - Pro Annual: $59.99/yr (save 29%)
   - 10 More Edits: $2.99 (one-time)
5. User selects "Pro Monthly"
6. Apple Pay sheet appears
7. Face ID confirms
8. Purchase completes (~5 seconds)
9. Paywall dismisses
10. Green banner: "Welcome to Pro! Unlimited edits unlocked"
11. User returns to editing interface
12. No more edit limit shown in top-right
13. Completes edit, saves with NO watermark

Total time from limit hit to unlimited: ~30 seconds
```

### 5.4 Salon Owner Flow (Business Tier)

```
1. Selects role: "Salon/Beauty Owner" during onboarding
2. Sees salon-specific templates:
   - "Before/After Side-by-Side"
   - "Add My Logo"
   - "Fix Overhead Lighting"
3. Taps "Settings" → "Brand Kit" → Uploads salon logo
4. Returns to editing
5. Takes 3 client photos with iPhone
6. Multi-selects all 3 in picker
7. Says "Make all of these salon-ready"
8. Batch processing starts (3 photos × 5 seconds = 15 seconds)
9. Shows grid of results
10. Taps photo 2: "Add my logo"
11. Logo appears in bottom-right corner
12. Adjusts position with drag
13. "Save All" → Exports all 3 to Photos
14. Shares to Instagram directly from Photos app

Total time for 3 client posts: ~3 minutes (vs 15 minutes manually)
```

---

## 6. TECHNICAL ARCHITECTURE

### 6.1 iOS App Architecture (MVVM)

```
Velo/
├── Models/
│   ├── User.swift
│   ├── EditSession.swift
│   ├── Template.swift
│   └── BrandKit.swift
│
├── Views/
│   ├── Onboarding/
│   │   ├── RoleSelectionView.swift
│   │   ├── ExamplesView.swift
│   │   └── TutorialView.swift
│   ├── Editing/
│   │   ├── PhotoPickerView.swift
│   │   ├── EditingInterfaceView.swift
│   │   └── BeforeAfterSlider.swift
│   ├── Templates/
│   │   └── TemplateGalleryView.swift
│   └── Settings/
│       ├── SettingsView.swift
│       ├── AccountView.swift
│       └── BrandKitView.swift
│
├── ViewModels/
│   ├── OnboardingViewModel.swift
│   ├── EditingViewModel.swift ← Core business logic
│   ├── TemplateViewModel.swift
│   └── AccountViewModel.swift
│
├── Services/
│   ├── VoiceRecognitionService.swift ← SFSpeechRecognizer wrapper
│   ├── SupabaseService.swift ← API client
│   ├── ImageProcessingService.swift ← Compression, watermarking
│   ├── SubscriptionService.swift ← RevenueCat integration
│   └── NotificationService.swift ← APNs registration
│
├── Utilities/
│   ├── Constants.swift ← API endpoints, colors
│   ├── Extensions.swift
│   └── Logger.swift
│
└── Resources/
    ├── Assets.xcassets
    ├── Localizable.strings
    └── Info.plist
```

### 6.2 Supabase Backend Architecture

**Database Tables:**
```sql
-- Users (extends Supabase Auth)
create table public.user_profiles (
  id uuid references auth.users(id) primary key,
  role_type text not null, -- 'parent', 'salon', 'realtor', 'business', 'explorer'
  subscription_tier text default 'free', -- 'free', 'pro', 'business'
  edits_this_month int default 0,
  edits_month_start date default current_date,
  created_at timestamp default now()
);

-- Edit History
create table public.edits (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users(id),
  created_at timestamp default now(),
  command_text text not null,
  edited_image_url text,
  model_used text, -- 'base' or 'pro'
  processing_time_ms int,
  cost_usd decimal(10,4)
);

-- Templates
create table public.templates (
  id uuid primary key default uuid_generate_v4(),
  name text not null,
  description text,
  prompt_text text not null,
  role_tags text[], -- Array: ['parent', 'salon']
  preview_url text,
  usage_count int default 0,
  is_active boolean default true
);

-- Brand Kits
create table public.brand_kits (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users(id),
  name text not null,
  logo_url text not null,
  created_at timestamp default now()
);

-- Row Level Security Policies
alter table user_profiles enable row level security;
create policy "Users can view own profile"
  on user_profiles for select
  using (auth.uid() = id);

alter table edits enable row level security;
create policy "Users can view own edits"
  on edits for select
  using (auth.uid() = user_id);

alter table templates enable row level security;
create policy "Templates are public"
  on templates for select
  using (is_active = true);

alter table brand_kits enable row level security;
create policy "Users can manage own brand kits"
  on brand_kits for all
  using (auth.uid() = user_id);
```

**Edge Functions:**

**`process-edit` (Main editing function):**
```typescript
// supabase/functions/process-edit/index.ts
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from '@supabase/supabase-js'

serve(async (req) => {
  const { user_id, command_text, image_base64, user_tier } = await req.json()

  // 1. Authenticate
  const authHeader = req.headers.get('Authorization')
  if (!authHeader) return new Response('Unauthorized', { status: 401 })

  // 2. Check quota
  const { data: profile } = await supabase
    .from('user_profiles')
    .select('edits_this_month, subscription_tier')
    .eq('id', user_id)
    .single()

  if (profile.subscription_tier === 'free' && profile.edits_this_month >= 5) {
    return new Response(JSON.stringify({ error: 'Quota exceeded' }), { status: 402 })
  }

  // 3. Parse command & select model
  const modelType = selectModel(command_text) // 'base' or 'pro'
  const nanoBananaPrompt = constructPrompt(command_text)

  // 4. Call Nano Banana API
  const nanoBananaResponse = await fetch('https://api.nanobanana.ai/v1/edit', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${Deno.env.get('NANO_BANANA_API_KEY')}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      model: modelType,
      prompt: nanoBananaPrompt,
      image: image_base64,
      quality: user_tier === 'business' ? '4k' : '2k'
    })
  })

  const { edited_image_base64 } = await nanoBananaResponse.json()

  // 5. Apply watermark if free tier
  const finalImage = user_tier === 'free'
    ? await addWatermark(edited_image_base64)
    : edited_image_base64

  // 6. Upload to Supabase Storage (optional)
  const { data: uploadData } = await supabase.storage
    .from('edited-images')
    .upload(`${user_id}/${Date.now()}.jpg`, finalImage)

  // 7. Log edit
  await supabase.from('edits').insert({
    user_id,
    command_text,
    edited_image_url: uploadData.path,
    model_used: modelType,
    processing_time_ms: Date.now() - startTime,
    cost_usd: modelType === 'base' ? 0.02 : 0.12
  })

  // 8. Increment usage count
  await supabase.rpc('increment_edit_count', { user_uuid: user_id })

  return new Response(JSON.stringify({
    success: true,
    edited_image_url: uploadData.publicUrl,
    edits_remaining: 5 - (profile.edits_this_month + 1)
  }), { status: 200 })
})
```

### 6.3 Third-Party Integrations

**RevenueCat Setup:**
```swift
// AppDelegate.swift
import RevenueCat

func application(_ application: UIApplication, didFinishLaunchingWithOptions...) {
    Purchases.logLevel = .debug
    Purchases.configure(withAPIKey: "appl_YOUR_KEY")

    // Sync with Supabase user ID
    Purchases.shared.logIn(currentUserID) { (purchaserInfo, created, error) in
        // Update subscription tier in Supabase
    }
}
```

**Nano Banana Integration:**
```swift
// SupabaseService.swift
func processEdit(command: String, image: UIImage, completion: @escaping (Result<UIImage, Error>) -> Void) {
    guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
    let base64Image = imageData.base64EncodedString()

    let payload: [String: Any] = [
        "user_id": currentUserID,
        "command_text": command,
        "image_base64": base64Image,
        "user_tier": currentUserTier
    ]

    supabase.functions.invoke("process-edit", options: FunctionInvokeOptions(
        body: payload
    )) { (result: Result<FunctionResponse, Error>) in
        switch result {
        case .success(let response):
            // Decode edited image from URL
            if let editedURL = response.data["edited_image_url"] as? String {
                downloadImage(from: editedURL, completion: completion)
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
```

---

## 7. MVP SCOPE & PHASING

### Phase 1: MVP (Weeks 1-4) - "Wife + 10 Friends"

**Goal:** Validate core value proposition with 10 real users.

**Features:**
- ✅ Voice/text editing (10 common commands)
- ✅ Role-based onboarding (3 roles: Parent, Salon, Realtor)
- ✅ 15 curated templates
- ✅ Photo picker & basic editing interface
- ✅ Anonymous authentication (no accounts)
- ✅ Local edit history (CoreData)
- ✅ Free tier only (5 edits/month, watermarked)
- ✅ iOS 16+ support (iPhone only, no iPad)

**NOT Included:**
- ❌ Subscriptions (payment system)
- ❌ Cloud sync
- ❌ Batch processing
- ❌ Brand kits
- ❌ Push notifications
- ❌ Before/after slider (Phase 2)

**Success Metrics:**
- 8 out of 10 testers complete first edit
- Average time to first edit: <90 seconds
- 60%+ say they'd use this over current app
- 40%+ complete 3+ edits in first week

**Delivery:**
- TestFlight build shared with 10 users
- Daily feedback collected via WhatsApp group
- Weekly iteration based on confusion points

---

### Phase 2: Beta Launch (Weeks 5-8) - "100 TestFlight Users"

**Goal:** Validate monetization and retention.

**New Features:**
- ✅ Subscriptions (Pro + Business tiers)
- ✅ Account creation (Sign in with Apple)
- ✅ Cloud sync (edit history + settings)
- ✅ Batch processing (Pro/Business only)
- ✅ Brand kit upload (Business only)
- ✅ Before/after slider
- ✅ Push notifications (edit complete)
- ✅ 30 templates (10 per role)

**Success Metrics:**
- 10-15% free → paid conversion
- 40%+ Month 2 retention
- <5% churn rate
- NPS score >40

**Delivery:**
- Recruit 100 users from local business groups
- Track analytics via Mixpanel
- Run 2-week A/B test on paywall messaging

---

### Phase 3: Public Launch (Weeks 9-12) - "App Store"

**Goal:** Acquire 1,000 users in first month.

**New Features:**
- ✅ App Store listing (screenshots, video, ASO)
- ✅ Referral program ("Give 5 edits, get 5 edits")
- ✅ Onboarding A/B tests (optimize role selection)
- ✅ Customer support (in-app chat via Intercom)
- ✅ Usage analytics dashboard (for Business tier)

**Go-to-Market:**
- PR pitch: "The photo editor where you just talk"
- Product Hunt launch
- Outreach to parenting blogs, salon Instagram influencers
- Facebook ads targeting "photo editing app" interest

**Success Metrics:**
- 1,000 downloads in Month 1
- 100 paying subscribers ($700 MRR)
- 4.5+ star rating on App Store
- <1% crash rate

---

## 8. ANALYTICS & METRICS

### Event Tracking (Mixpanel/Amplitude)

**Critical Events:**
- `app_opened` (with: role_type, subscription_tier, days_since_install)
- `onboarding_started`
- `role_selected` (with: role_type)
- `onboarding_completed`
- `photo_selected`
- `voice_button_tapped`
- `command_spoken` (with: command_text_length, voice_or_text)
- `edit_started` (with: command_category, model_used)
- `edit_completed` (with: processing_time_ms, success)
- `edit_saved`
- `paywall_viewed` (with: trigger_reason)
- `subscription_purchased` (with: tier, annual_or_monthly)
- `subscription_cancelled`
- `template_viewed` (with: template_id, template_name)
- `template_applied`

**User Properties:**
- `role_type` (parent, salon, realtor, business, explorer)
- `subscription_tier` (free, pro, business)
- `total_edits` (lifetime count)
- `total_edits_this_month`
- `first_edit_date`
- `last_edit_date`
- `favorite_commands` (array of top 3 commands used)

**Funnel Analysis:**
1. App Install → Onboarding Started → Role Selected → First Edit → Second Edit
2. Paywall Viewed → Subscription Purchased
3. Template Viewed → Template Applied → Edit Saved

---

## 9. RISKS & MITIGATION

### 9.1 Technical Risks

**Risk:** Voice recognition accuracy <90% in noisy environments
- **Mitigation:** Always show transcription before processing, easy undo, text fallback
- **Monitoring:** Track command_spoken events with success/failure flag

**Risk:** Nano Banana API downtime or rate limits
- **Mitigation:**
  - Implement exponential backoff retry (3 attempts)
  - Cache common template results for offline mode (Phase 2)
  - Monitor API uptime via status page webhook
- **Monitoring:** Alert if API error rate >5% in 5-minute window

**Risk:** Supabase free tier limits exceeded
- **Mitigation:**
  - Monitor usage dashboard daily
  - Set up billing alerts at 80% quota
  - Plan migration to paid tier at 5,000 users
- **Monitoring:** Weekly cost projection based on growth rate

**Risk:** App Store rejection
- **Mitigation:**
  - Follow Human Interface Guidelines strictly
  - Include detailed App Review notes explaining AI usage
  - Prepare demo video showing user consent for photo access
- **Monitoring:** N/A (manual process)

### 9.2 Product Risks

**Risk:** Users don't understand how to use voice input
- **Mitigation:**
  - Onboarding tutorial with practice edit
  - Example commands visible on first screen
  - "Teach Mode" button shows contextual suggestions
- **Monitoring:** Track % of users who complete first edit in <90 seconds

**Risk:** Conversion rate <5% (not sustainable)
- **Mitigation:**
  - A/B test paywall messaging (urgency vs value)
  - Offer annual plan with 2 months free
  - Add "Most Popular" badge to Pro tier
- **Monitoring:** Weekly cohort analysis of install → purchase

**Risk:** High churn rate (>30% Month 1)
- **Mitigation:**
  - Push notification on Day 7: "Try batch editing 5 photos at once"
  - Email drip campaign with template suggestions
  - Survey churned users: "What would bring you back?"
- **Monitoring:** Retention curves by cohort, exit surveys

### 9.3 Market Risks

**Risk:** Google/Apple launches competing feature
- **Mitigation:**
  - You're standalone (not buried in Photos app)
  - Faster iteration than big tech
  - Role-based personalization is your moat
- **Monitoring:** Google Photos + Apple Photos release notes

**Risk:** Not enough viral growth (watermark ineffective)
- **Mitigation:**
  - Referral program with mutual rewards
  - Social sharing prompts: "Share your before/after"
  - Partner with micro-influencers in target niches
- **Monitoring:** Track referral_code parameter in app installs

---

## 10. SUCCESS CRITERIA (90-Day Goals)

### User Acquisition
- **Target:** 1,000 total installs
- **Stretch:** 2,500 installs
- **Measurement:** App Store Connect analytics

### Activation
- **Target:** 60% complete first edit
- **Stretch:** 75% complete first edit
- **Measurement:** Funnel: app_opened → edit_completed

### Engagement
- **Target:** 40% edit 3+ photos in Week 1
- **Stretch:** 55% edit 3+ photos in Week 1
- **Measurement:** Cohort analysis via Mixpanel

### Monetization
- **Target:** 10% conversion (free → paid)
- **Stretch:** 15% conversion
- **Measurement:** Subscription purchase events / total users

### Revenue
- **Target:** $1,000 MRR (143 Pro subscribers OR 67 Business subscribers)
- **Stretch:** $2,500 MRR
- **Measurement:** RevenueCat dashboard

### Retention
- **Target:** 40% Month 2 retention
- **Stretch:** 50% Month 2 retention
- **Measurement:** Users active in Month 2 / Users active in Month 1

### Quality
- **Target:** 4.5+ star App Store rating
- **Stretch:** 4.7+ stars
- **Measurement:** App Store Connect reviews

### Voice Adoption
- **Target:** 30% of users try voice input
- **Stretch:** 50% try voice input
- **Measurement:** voice_button_tapped events

---

## 11. OPEN QUESTIONS & DECISIONS NEEDED

### Design Decisions
1. **Watermark placement:** Bottom-right corner or centered at bottom?
   - **Recommendation:** Bottom-right, semi-transparent (30% opacity)

2. **Onboarding skip option:** Allow users to skip role selection?
   - **Recommendation:** No skip button (forces intentional choice), but add "Just Exploring" option

3. **Before/after slider default state:** Show original or edited first?
   - **Recommendation:** Edited (celebrate the result), user drags left to see original

### Technical Decisions
4. **Image compression:** What quality to upload to backend?
   - **Recommendation:** 80% JPEG quality (balance speed vs fidelity)

5. **Local storage limit:** How many edit histories to cache?
   - **Recommendation:** Last 50 edits (CoreData), auto-prune older

6. **Offline mode:** Allow editing without internet?
   - **Recommendation:** Phase 2 feature (complex caching logic)

### Business Decisions
7. **Annual subscription discount:** Offer 2 months free (17% off) or 3 months free (25% off)?
   - **Recommendation:** 2 months free ($59.99/year vs $83.88), A/B test later

8. **Family sharing:** Allow Family Sharing on Pro tier?
   - **Recommendation:** Yes (Apple requires it for subscriptions anyway)

9. **Refund policy:** Auto-approve refunds <7 days?
   - **Recommendation:** Yes (builds trust, Apple allows it)

---

## 12. APPENDIX

### A. Competitor Feature Matrix

| Feature | Velo (MVP) | Remini | Picsart | PhotoRoom |
|---------|-----------|--------|---------|-----------|
| Voice editing | ✅ PRIMARY | ❌ | ❌ | ❌ |
| AI enhancement | ✅ | ✅ | ✅ | ✅ |
| Background removal | ✅ | ✅ | ✅ | ✅ PRIMARY |
| Batch processing | ✅ (Pro) | ❌ | ✅ | ✅ |
| Templates | ✅ 15 | ~10 | 100+ | 50+ |
| Brand kit | ✅ (Business) | ❌ | ❌ | ✅ |
| Free tier | 5 edits/mo | 3/day | Watermarked | Watermarked |
| Pricing | $6.99/mo | $4.99/mo | $5/mo | $9.99/mo |
| Onboarding | Role-based | Generic | Generic | E-commerce focus |

**Velo's Advantages:**
- Voice-first (unique)
- Role-based personalization
- Faster onboarding (<60 sec to first edit)
- Cleaner UI (less overwhelming)

**Competitor Advantages:**
- More templates (but overwhelming)
- Established user bases
- More advanced manual controls

---

### B. Tech Stack Summary

**iOS (Frontend):**
- SwiftUI (iOS 16+)
- Combine (reactive state management)
- CoreData (local storage)
- SFSpeechRecognizer (voice recognition)
- PhotosUI (photo picker)
- StoreKit 2 (in-app purchases)

**Backend:**
- Supabase (BaaS: PostgreSQL + Auth + Storage + Edge Functions)
- Deno/TypeScript (Edge Functions runtime)
- Nano Banana API (Gemini 3 Pro Image)

**Third-Party Services:**
- RevenueCat (subscription management)
- Mixpanel/Amplitude (analytics)
- Intercom (customer support, Phase 3)
- APNs (push notifications)

**DevOps:**
- GitHub (version control)
- Xcode Cloud (CI/CD, Phase 2)
- TestFlight (beta distribution)
- App Store Connect (production)

---

### C. File Naming Conventions

**SwiftUI Views:**
- Suffix with `View`: `EditingInterfaceView.swift`
- ViewModels: Suffix with `ViewModel`: `EditingViewModel.swift`

**Models:**
- Singular nouns: `User.swift`, `Template.swift`

**Services:**
- Suffix with `Service`: `VoiceRecognitionService.swift`

**Assets:**
- Use kebab-case: `icon-microphone.png`, `template-beach-sunset.jpg`

**Database Tables:**
- Plural snake_case: `user_profiles`, `brand_kits`

**Edge Functions:**
- Kebab-case folders: `supabase/functions/process-edit/index.ts`

---

### D. Git Workflow

**Branch Strategy:**
- `main` - Production (App Store builds)
- `develop` - Integration branch
- `feature/voice-recognition` - Feature branches
- `hotfix/crash-on-save` - Urgent fixes

**Commit Messages:**
- Format: `[TYPE] Short description`
- Types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`
- Examples:
  - `feat: Add voice recognition to editing interface`
  - `fix: Resolve crash when saving edited photo`
  - `refactor: Extract Supabase calls into service layer`

**Pull Request Requirements:**
- Passes all unit tests
- No SwiftLint warnings
- Screenshots for UI changes
- Reviewed by 1+ person (Phase 2)

---

### E. Testing Strategy

**Phase 1 (Manual Testing):**
- 10 testers use TestFlight daily
- Weekly feedback sessions (30 min video calls)
- Bug reports via shared Google Sheet

**Phase 2 (Automated Testing):**
- Unit tests: ViewModels, Services (target: 60% coverage)
- UI tests: Critical flows (onboarding, first edit, subscription purchase)
- CI/CD: Xcode Cloud runs tests on every PR

**Phase 3 (Beta Testing):**
- 100 TestFlight users
- In-app bug reporter (shake to report)
- Crash analytics via Firebase Crashlytics

---

## 13. NEXT STEPS (Immediate Actions)

**Week 1:**
1. ✅ Set up Supabase project (free tier)
2. ✅ Create database schema (run SQL migrations)
3. ✅ Register for Nano Banana API key (test with 10 free credits)
4. ✅ Scaffold iOS project structure (create folders: Models/, Services/, etc.)
5. ✅ Implement VoiceRecognitionService (test with "hello world" transcription)

**Week 2:**
6. Build RoleSelectionView (onboarding Screen 1)
7. Build EditingInterfaceView (photo + voice button)
8. Integrate Supabase Swift client
9. Create first Edge Function: `process-edit` (mock response initially)
10. Test end-to-end: Voice → Backend → Return mock image

**Week 3:**
11. Connect Nano Banana API to Edge Function (real editing)
12. Implement watermarking for free tier
13. Add edit quota enforcement (5 edits/month)
14. Build TemplateGalleryView with 10 hardcoded templates
15. Implement CoreData for local edit history

**Week 4:**
16. Polish UI animations and transitions
17. Add haptic feedback for button taps
18. Implement error handling (quota exceeded, network errors)
19. TestFlight beta build #1
20. Share with wife + 10 friends → Collect feedback

**Decision Points:**
- End of Week 2: Is voice transcription accurate enough? (>85%)
- End of Week 3: Are Nano Banana results good quality? (show to wife)
- End of Week 4: Did 8/10 testers complete first edit? (Go/No-Go for Phase 2)

---

**END OF PRD**

---

This PRD serves as the single source of truth for Velo's MVP development. All implementation decisions should reference this document. Updates to scope, features, or architecture must be reflected here with version increments.
