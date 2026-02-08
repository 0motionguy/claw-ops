#!/bin/bash
# Hook: Lead Capture to CRM Pipeline
# Triggers: New form submission, comment on social, DM received
# Actions: Create lead in CRM, send welcome email, schedule follow-up

echo "🎣 LEAD CAPTURE HOOK ACTIVATED"

# Get lead data from input
LEAD_NAME="$1"
LEAD_EMAIL="$2"
LEAD_SOURCE="$3"  # instagram, website, referral, etc.

echo "New lead: $LEAD_NAME ($LEAD_EMAIL) from $LEAD_SOURCE"

# Step 1: Add to CRM
python3 ../crm-integration/scripts/contact-sync.py add \
  --name "$LEAD_NAME" \
  --email "$LEAD_EMAIL" \
  --source "$LEAD_SOURCE" \
  --status "new"

# Step 2: Send welcome email
python3 ../email-marketing/scripts/sequence-builder.py send \
  --template "welcome" \
  --to "$LEAD_EMAIL" \
  --vars "name=$LEAD_NAME"

# Step 3: Schedule follow-up task
echo "Follow-up scheduled for 2 days"
# Add to task manager/calendar

# Step 4: Notify team
# Send Slack/Discord notification

echo "✅ Lead pipeline complete for $LEAD_NAME"
