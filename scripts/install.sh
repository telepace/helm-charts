#!/bin/bash

# Services to install
services=("analysis" "collection" "web" "feedback-collection-api" "voiceflow")
cd charts

for service in "${services[@]}"; do
  echo "Installing $service..."
  helm install $service ./$service
done