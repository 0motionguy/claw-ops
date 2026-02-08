---
name: appointment-booking
description: Automate appointment scheduling, reminders, and calendar management for service businesses. Use when setting up booking systems, managing client appointments, sending reminders, or integrating calendars with CRM and payment systems.
---

# Appointment Booking

Automate scheduling for service businesses.

## Features

### 1. Calendar Integration
- Google Calendar
- Outlook/Office 365
- Apple Calendar
- Custom availability rules

### 2. Booking Page
- Custom branding
- Multiple service types
- Duration options
- Buffer time between meetings
- Timezone detection

### 3. Automated Reminders
- Email reminders (24h, 1h before)
- SMS reminders
- WhatsApp notifications
- Calendar invites

### 4. Client Management
- Pre-appointment questionnaires
- Automatic CRM updates
- Notes/history tracking
- Follow-up scheduling

## Setup

### Option 1: Calendly
```
1. Create Calendly account
2. Set availability rules
3. Customize booking page
4. Connect calendar
5. Configure reminders
```

### Option 2: Custom Solution
```python
# Using Cal.com API or custom
from appointment_booking import BookingSystem

booking = BookingSystem(
    provider="calcom",
    api_key="YOUR_KEY"
)

# Create booking link
link = booking.create_event_type(
    title="Strategy Call",
    duration=30,
    availability=["mon-fri 9-17"]
)
```

## Workflows

### New Lead → Booking
```
1. Lead submits form
2. Auto-qualify (score > 70)
3. Send booking link via email
4. Track booking conversion
5. Send confirmation
6. Add to calendar
```

### Pre-Appointment
```
1. T-24h: Send reminder email
2. T-1h: Send SMS reminder  
3. T-0h: Open meeting notes
4. Post-call: Update CRM
5. T+1h: Send follow-up
```

### Recurring Appointments
```
1. Client books initial session
2. Offer recurring schedule
3. Auto-generate future slots
4. Send monthly reminders
5. Handle rescheduling
```

## Scripts

- `scripts/booking-manager.py` - Manage appointments
- `scripts/reminder-service.py` - Send notifications
- `scripts/calendar-sync.py` - Sync across platforms
- `scripts/availability-checker.py` - Find open slots

## Integrations

### CRM
- HubSpot
- Salesforce
- Pipedrive
- Airtable

### Payment
- Stripe
- PayPal
- Square

### Communication
- SendGrid (email)
- Twilio (SMS)
- WhatsApp Business API

## Best Practices

### Reduce No-Shows
- Multiple reminders (email + SMS)
- Require confirmation
- Send prep materials
- Charge deposits for high-value

### Optimize Schedule
- Use buffer time (15 min)
- Block focus time
- Set booking limits (max 4/day)
- Leave emergency slots

### Client Experience
- Easy rescheduling
- Clear instructions
- Meeting prep
- Post-call follow-up

## Resources

- [references/calendly-setup.md](references/calendly-setup.md)
- [references/reminder-templates.md](references/reminder-templates.md)
- [references/crm-integrations.md](references/crm-integrations.md)

## Pricing Models

**Free Consultation:**
- 15-30 min discovery call
- No charge
- Goal: Qualify + sell

**Strategy Session:**
- 60-90 min paid session
- $200-500
- Goal: Provide value + upsell

**Implementation:**
- Project-based
- $5,000-50,000
- Goal: Execute solution
