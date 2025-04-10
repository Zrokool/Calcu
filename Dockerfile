# Base image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Install git and other dependencies
RUN apt-get update && \
    apt-get install -y git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Clone the repository
RUN git clone https://github.com/Zrokool/Calcu.git .

# Install project dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Install bandit for security scanning
RUN pip install --no-cache-dir bandit

# Create script to run bandit and then the application
RUN echo '#!/bin/bash\n\
echo "Running Bandit security scan..."\n\
mkdir -p /app/security_results\n\
bandit -r . -f json -o /app/security_results/bandit_results.json\n\
BANDIT_EXIT=$?\n\
\n\
if [ $BANDIT_EXIT -ne 0 ]; then\n\
  echo "Security issues found! Check /app/security_results/bandit_results.json"\n\
  exit $BANDIT_EXIT\n\
else\n\
  echo "No security issues found."\n\
  python calcu.py\n\
fi' > /app/entrypoint.sh && \
    chmod +x /app/entrypoint.sh

# Volume to persist security scan results
VOLUME /app/security_results

# Set entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]
