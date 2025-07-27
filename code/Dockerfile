FROM debian:sid-20250203

# Set the working directory
WORKDIR /app

RUN apt-get update && \
    echo "deb http://deb.debian.org/debian/ sid main contrib" > /etc/apt/sources.list && \
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ttf-mscorefonts-installer \
    fonts-liberation \
    fonts-noto-color-emoji \
    fonts-noto-mono \
    fonts-noto \
    fonts-noto-cjk \
    fonts-noto-unhinted

# Run system updates and install necessary packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget curl gnupg ca-certificates software-properties-common \
    supervisor
    
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
EXPOSE 8443

# Set the entrypoint
ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]