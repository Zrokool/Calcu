#!/bin/bash

# Create directory for security results
mkdir -p security_results

# Build and run container
echo "Building and running Calcu with Bandit security scan..."
docker-compose up --build

# Check if build failed due to security issues
if [ $? -ne 0 ]; then
  echo "Build failed! Security issues detected."
  echo "Results stored in ./security_results/bandit_results.json"
  exit 1
else
  echo "Build and security scan completed successfully."
  echo "Application started successfully."
fi
