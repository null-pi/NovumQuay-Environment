#!/bin/bash
set -e

echo "Initializing machine ID for D-Bus..."
mkdir -p /var/lib/dbus
dbus-uuidgen > /var/lib/dbus/machine-id

mkdir -p /root/.vnc

cat <<EOF > /root/.vnc/xstartup
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

fluxbox &

# Launch Google Chrome and Fluxbox
/usr/bin/google-chrome --no-sandbox --no-first-run --start-maximized
EOF

chmod 755 /root/.vnc/xstartup

echo "Setup complete. Starting supervisord..."
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf