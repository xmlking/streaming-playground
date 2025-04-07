#!/bin/bash

# Check if a number is provided, default to 5 if not
NUM_SAMPLES=${1:-10}
AGES=(70 60 26 30 9)
PHONES=("909-323-1133" "909-983-5421" "909-223-6785" "909-323-3243" "909-652-0987")

# Generate JSON data
for ((i=1; i<=NUM_SAMPLES; i++)); do
  NAME=SUMO-$(uuidgen)
  AGE=${AGES[$RANDOM % ${#AGES[@]}]}
  PHONE=${PHONES[$RANDOM % ${#PHONES[@]}]}

  JSON_PAYLOAD=$(cat <<EOF
{ "name": "$NAME", "age": "$AGE", "phone": "$PHONE" }
EOF
  )

#  echo "$JSON_PAYLOAD"
  echo "$JSON_PAYLOAD" | rpk topic produce customer-source


  sleep 0.5
done
