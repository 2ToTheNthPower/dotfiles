# shellcheck shell=bash
# Proxy configuration and helpers shared by bash and zsh.
#
# Everything proxy-related lives here: set the target below, then toggle it with
# `proxy on`, `proxy off`, or check it with `proxy status`.

# --- configuration ---------------------------------------------------------
# Target proxy for http/https.
PROXY_URL="${PROXY_URL:-http://127.0.0.1:8080}"

# Hosts that should bypass the proxy.
NO_PROXY="${NO_PROXY:-localhost,127.0.0.1,::1}"

# Set to 1 to enable the proxy automatically in every new shell.
PROXY_AUTO_ON="${PROXY_AUTO_ON:-0}"

# --- tooling ---------------------------------------------------------------
proxy() {
  case "$1" in
  on)
    export http_proxy="$PROXY_URL" https_proxy="$PROXY_URL"
    export HTTP_PROXY="$PROXY_URL" HTTPS_PROXY="$PROXY_URL"
    export no_proxy="$NO_PROXY"
    export NO_PROXY="$NO_PROXY"
    echo "proxy on: $PROXY_URL"
    ;;
  off)
    unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY
    unset no_proxy NO_PROXY
    echo "proxy off"
    ;;
  status | "")
    if [ -n "${http_proxy:-}" ]; then
      echo "proxy on: $http_proxy"
    else
      echo "proxy off"
    fi
    ;;
  *)
    echo "usage: proxy on|off|status" >&2
    return 1
    ;;
  esac
}

if [ "$PROXY_AUTO_ON" = 1 ]; then
  proxy on
fi
