FROM debian:sid-20250203

# Set the working directory
WORKDIR /app

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

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
    supervisor \
    tigervnc-standalone-server \
    tigervnc-common \
    fluxbox \
    dbus-x11 \
    xterm \
    novnc \
    websockify

# Add google-chrome repository
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
    
# Download code-server
RUN curl -fOL https://github.com/coder/code-server/releases/download/v4.91.1/code-server_4.91.1_amd64.deb
    
# Install code-server and Google Chrome
RUN apt-get update && \
    apt-get install -y ./code-server_4.91.1_amd64.deb google-chrome-stable
    
# Clean up unnecessary files
RUN rm ./code-server_4.91.1_amd64.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy the supervisor configuration and entrypoint script
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose the necessary ports
EXPOSE 6901 8443

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]