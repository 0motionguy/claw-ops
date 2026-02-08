#!/bin/bash
# Hook: New Client Onboarding Automation
# Triggers: Contract signed, payment received
# Actions: Create accounts, send welcome pack, schedule kickoff

echo "🎣 CLIENT ONBOARDING HOOK ACTIVATED"

CLIENT_NAME="$1"
CLIENT_EMAIL="$2"
SERVICE_TYPE="$3"  # instagram-automation, lead-gen, etc.

echo "New client: $CLIENT_NAME - $SERVICE_TYPE"

# Step 1: Create project workspace
python3 ../project-manager/scripts/workspace-creator.py \
  --client "$CLIENT_NAME" \
  --service "$SERVICE_TYPE"

# Step 2: Send welcome sequence
python3 ../client-onboarding/scripts/welcome-sequence.py send \
  --client "$CLIENT_NAME" \
  --email "$CLIENT_EMAIL" \
  --service "$SERVICE_TYPE"

# Step 3: Generate intake form
python3 ../client-onboarding/scripts/intake-processor.py create \
  --client "$CLIENT_NAME" \
  --service "$SERVICE_TYPE"

# Step 4: Schedule kickoff call
python3 ../appointment-booking/scripts/booking-manager.py schedule \
  --client "$CLIENT_NAME" \
  --email "$CLIENT_EMAIL" \
  --type "kickoff" \
  --duration "60min"

# Step 5: Set up service-specific automation
case $SERVICE_TYPE in
  instagram-automation)
    python3 ../instagram-automation/scripts/setup-automation.py \
      --client "$CLIENT_NAME"
    ;;
  lead-gen)
    python3 ../lead-gen-funnel/scripts/funnel-builder.py \
      --client "$CLIENT_NAME"
    ;;
esac

# Step 6: Add to CRM as active client
python3 ../crm-integration/scripts/contact-sync.py update \
  --email "$CLIENT_EMAIL" \
  --status "active-client"

echo "✅ Onboarding complete for $CLIENT_NAME"
