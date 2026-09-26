# shellcheck shell=bash
# Proxy helpers shared by bash and zsh.
# Set PROXY_URL (and optionally NO_PROXY) in ~/set-proxy.sh to change these.

PROXY_URL="${PROXY_URL:-http://127.0.0.1:8080}"
_NO_PROXY_DEFAULT="localhost,127.0.0.1,::1"

proxy() {
  case "$1" in
  on)
    export http_proxy="$PROXY_URL" https_proxy="$PROXY_URL"
    export HTTP_PROXY="$PROXY_URL" HTTPS_PROXY="$PROXY_URL"
    export no_proxy="${NO_PROXY:-$_NO_PROXY_DEFAULT}"
    export NO_PROXY="$no_proxy"
    echo "proxy on: $PROXY_URL"
    ;;
  off)
    unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY
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
