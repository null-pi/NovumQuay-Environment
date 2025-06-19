FROM debian:sid-20250203

# Set the working directory
WORKDIR /app

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Run system updates and install necessary packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget curl gnupg ca-certificates software-properties-common \
    docker.io \
    tigervnc-standalone-server \
    tigervnc-common \
    fluxbox \
    dbus-x11 \
    xterm \
    novnc \
    websockify && \
    # Add google-chrome repository
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    # Download code-server
    curl -fOL https://github.com/coder/code-server/releases/download/v4.91.1/code-server_4.91.1_amd64.deb && \
    # Install code-server and Google Chrome
    apt-get update && \
    apt-get install -y ./code-server_4.91.1_amd64.deb google-chrome-stable && \
    # Clean up unnecessary files
    rm ./code-server_4.91.1_amd64.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*