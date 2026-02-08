---
name: lead-gen-funnel
description: Build complete lead generation funnels with comment-to-DM automation, email sequences, landing pages, and CRM integration. Use when creating marketing funnels, automating lead capture, nurturing prospects, or building appointment booking systems for clients.
---

# Lead Generation Funnel

Build automated lead gen systems that convert strangers into customers.

## The Funnel

### 1. Awareness (Top)
- Social media content
- SEO/blog posts
- Paid ads
- Partnerships

### 2. Interest (Middle)
- Lead magnet (guide, checklist, template)
- Comment CTA ("Comment GUIDE for free download")
- DM automation
- Email capture

### 3. Desire (Bottom)
- Nurture sequence
- Case studies
- Testimonials
- Product demos

### 4. Action (Conversion)
- Appointment booking
- Sales call
- Purchase
- Onboarding

## Components

### Lead Magnet Creation
**Types:**
- PDF guide/checklist
- Video tutorial
- Template/spreadsheet
- Free tool/calculator
- Quiz/assessment

**Topics by Industry:**
- Marketing: "10 Lead Gen Tactics"
- SaaS: "Onboarding Checklist"
- Agency: "Client Acquisition Playbook"
- E-commerce: "Conversion Rate Optimization Guide"

### Comment-to-DM Automation
**Instagram Flow:**
1. Post with CTA: "Comment LEADS for the guide"
2. Auto-detect comment
3. Send DM with link
4. Capture email
5. Add to sequence

**Script:**
```python
# Detect comments
comments = instagram.get_recent_comments(post_id)
for comment in comments:
    if "LEADS" in comment.text.upper():
        send_dm(comment.user_id, guide_link)
```

### Landing Page
**Elements:**
- Headline (problem + solution)
- Subheadline (benefit)
- Lead magnet preview
- Email form
- Trust signals (testimonials, logos)
- CTA button

**Tools:**
- Carrd.co (simple)
- Webflow (advanced)
- WordPress (flexible)
- Custom (OpenClaw + HTML)

### Email Sequence
**Day 0:** Deliver lead magnet
**Day 1:** Welcome + quick win
**Day 3:** Value content
**Day 5:** Case study
**Day 7:** Soft pitch
**Day 10:** Direct offer
**Day 14:** FAQ/objections
**Day 21:** Final call

### Appointment Booking
**Integration:**
- Calendly
- Cal.com
- HubSpot
- Custom booking page

**Qualification:**
- Company size
- Budget range
- Timeline
- Decision maker

## Workflows

### Full Funnel Setup
```
1. Create lead magnet (1 day)
2. Build landing page (1 day)
3. Set up email sequence (2 days)
4. Configure DM automation (1 day)
5. Test end-to-end (1 day)
6. Launch campaign (ongoing)
```

### Daily Operations
```
1. Check new leads (morning)
2. Respond to DMs (throughout day)
3. Monitor email opens/clicks (daily)
4. Follow up hot leads (immediate)
5. Analyze metrics (weekly)
```

## Scripts

- `scripts/funnel-builder.py` - Create complete funnel
- `scripts/comment-monitor.py` - Track Instagram comments
- `scripts/dm-automation.py` - Send DMs automatically
- `scripts/email-sequencer.py` - Manage email flows
- `scripts/lead-scorer.py` - Qualify leads

## Metrics

### Top of Funnel
- Impressions/reach
- Engagement rate
- Comment-to-DM rate
- Landing page conversion

### Middle of Funnel
- Email open rate (target: 40%+)
- Click-through rate (target: 5%+)
- Lead quality score
- Cost per lead

### Bottom of Funnel
- Appointment booking rate
- Show-up rate
- Close rate
- Customer acquisition cost
- Lifetime value

## Resources

- [references/funnel-templates.md](references/funnel-templates.md)
- [references/email-sequences.md](references/email-sequences.md)
- [references/landing-page-examples.md](references/landing-page-examples.md)

## Best Practices

- Always deliver promised value
- Respond to DMs within 1 hour
- Personalize when possible
- Segment by interest/behavior
- A/B test everything
- Track attribution
