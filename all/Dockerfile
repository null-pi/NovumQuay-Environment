FROM novumquay/environment-browser:latest

# Set the working directory
WORKDIR /app
    
# Download code-server
RUN curl -fOL https://github.com/coder/code-server/releases/download/v4.91.1/code-server_4.91.1_amd64.deb
    
# Install code-server
RUN apt-get update && \
    apt-get install -y ./code-server_4.91.1_amd64.deb
    
# Clean up unnecessary files
RUN rm ./code-server_4.91.1_amd64.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy the supervisor configuration and entrypoint script
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose the necessary ports
EXPOSE 5901 6901 8443

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]