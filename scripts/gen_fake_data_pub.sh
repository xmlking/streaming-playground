#!/bin/bash

# Check if a number is provided, default to 5 if not
NUM_SAMPLES=${1:-5}
CITIES=("New York" "Los Angeles" "Chicago" "Houston" "Phoenix" "Philadelphia" "San Antonio" "San Diego" "Dallas" "San Jose")

# Generate JSON data
for ((i=1; i<=NUM_SAMPLES; i++)); do
  CITY=${CITIES[$RANDOM % ${#CITIES[@]}]}
  USER_ID=$(uuidgen)

  JSON_PAYLOAD=$(cat <<EOF
{ "event": "search", "properties": { "city": "$CITY" }, "user": { "id": "$USER_ID" } }
EOF
  )

#  echo "$JSON_PAYLOAD"
  echo "$JSON_PAYLOAD" | rpk topic produce input-simple-agg-mem


  sleep 1
done
