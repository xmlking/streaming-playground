#!/bin/bash

# Check if a number is provided, default to 5 if not
NUM_SAMPLES=${1:-5}
CUSTOMER_IDS=(1 2 3 4 5)
EVENT_TYPES=("Premium" "Gold" "Silver" "Bronze" "Base")

# Generate JSON data
for ((i=1; i<=NUM_SAMPLES; i++)); do
  EVENT_ID=$(uuidgen)
  CUSTOMER_ID=${CUSTOMER_IDS[$RANDOM % ${#CUSTOMER_IDS[@]}]}
  EVENT_TYPE=${EVENT_TYPES[$RANDOM % ${#EVENT_TYPES[@]}]}

  JSON_PAYLOAD=$(cat <<EOF
{ "event_id": "$EVENT_ID", "customer_id": "$CUSTOMER_ID", "event_type": "$EVENT_TYPE" }
EOF
  )

#  echo "$JSON_PAYLOAD"
  echo "$JSON_PAYLOAD" | rpk topic produce events


  sleep 1
done
