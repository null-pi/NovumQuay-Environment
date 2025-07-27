#!/bin/bash
set -Eeuo pipefail

echo "Initializing D-Bus machine-id (idempotent)..."
dbus-uuidgen --ensure >/dev/null 2>&1 || {
  # Fallback path if ensure fails for any reason
  mkdir -p /var/lib/dbus
  dbus-uuidgen > /var/lib/dbus/machine-id
}

# Align with newer D-Bus setups if needed
if [ ! -s /etc/machine-id ] && [ -s /var/lib/dbus/machine-id ]; then
  ln -sf /var/lib/dbus/machine-id /etc/machine-id || true
fi

echo "Preparing TigerVNC config (XDG path)..."
# Use the modern XDG directory and remove legacy to avoid 'Could not migrate' failures
mkdir -p /root/.config/tigervnc
rm -rf /root/.vnc || true

# Write xstartup only if one doesn't exist, so you can override via bind-mounts
if [ ! -f /root/.config/tigervnc/xstartup ]; then
  cat <<'EOF' >/root/.config/tigervnc/xstartup
#!/bin/sh
set -e
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

# Launch Chrome in background if available (non-fatal if missing)
if command -v /usr/bin/google-chrome >/dev/null 2>&1; then
  /usr/bin/google-chrome --no-sandbox --no-first-run --start-maximized \
    >/root/.config/tigervnc/chrome.log 2>&1 &
fi

# Keep the session anchored on the window manager
exec fluxbox
EOF
  chmod 755 /root/.config/tigervnc/xstartup
fi

echo "Bootstrap complete. Handing off to supervisord..."
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
