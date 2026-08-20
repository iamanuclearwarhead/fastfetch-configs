#!/usr/bin/env bash
#
#
#   __         _    __     _      _          _         _        _ _         
#  / _|__ _ __| |_ / _|___| |_ __| |_       (_)_ _  __| |_ __ _| | |___ _ _ 
# |  _/ _` (_-<  _|  _/ -_)  _/ _| ' \      | | ' \(_-<  _/ _` | | / -_) '_|
# |_| \__,_/__/\__|_| \___|\__\__|_||_|     |_|_||_/__/\__\__,_|_|_\___|_|  
#                                                                       
# usage
#   ./install.sh                                          interactive picker
#   ./install.sh nordic                                   install a config by name
#   ./install.sh -l                                       list available configs
#   ./install.sh -p nordic                                preview a config without installing
#
# oneliner (no cloning):
#   curl -fsSL https://raw.githubusercontent.com/iamanuclearwarhead/fastfetch-configs/main/install.sh | bash
set -euo pipefail

REPO_URL="https://github.com/iamanuclearwarhead/fastfetch-configs.git"
TARGET_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/fastfetch"

BOLD=$'\033[1m'
BLUE=$'\033[34m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
RED=$'\033[31m'
DIM=$'\033[90m'
RESET=$'\033[0m'

info()  { printf '%s\n' "${BLUE}::${RESET} $*"; }
ok()    { printf '%s\n' "${GREEN}::${RESET} $*"; }
warn()  { printf '%s\n' "${YELLOW}::${RESET} $*"; }
die()   { printf '%s\n' "${RED}error:${RESET} $*" >&2; exit 1; }

usage() {
    sed -n '2,13p' "$0" | sed 's/^# \{0,1\}//'
    exit 0
}

CLEANUP_DIR=""
cleanup() { if [ -n "$CLEANUP_DIR" ]; then rm -rf "$CLEANUP_DIR"; fi; }
trap cleanup EXIT

script_dir=""
if [ -f "${BASH_SOURCE[0]:-}" ]; then
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

if [ -n "$script_dir" ] && [ -f "$script_dir/README.md" ] && ls "$script_dir"/*/config.jsonc >/dev/null 2>&1; then
    REPO_DIR="$script_dir"
else
    command -v git >/dev/null 2>&1 || die "git is required for one-liner installs"
    info "Fetching fastfetch-configs..."
    CLEANUP_DIR="$(mktemp -d)"
    git clone --depth 1 --quiet "$REPO_URL" "$CLEANUP_DIR/repo"
    REPO_DIR="$CLEANUP_DIR/repo"
fi

configs=()
for dir in "$REPO_DIR"/*/; do
    [ -f "$dir/config.jsonc" ] && configs+=("$(basename "$dir")")
done
[ "${#configs[@]}" -gt 0 ] || die "no configs found in $REPO_DIR"

list_configs() {
    printf '%s\n' "${BOLD}Available configs:${RESET}"
    local i=1
    for name in "${configs[@]}"; do
        desc="$(sed -n 's|^\s*// ||p' "$REPO_DIR/$name/config.jsonc" | head -1)"
        printf '  %s%2d%s  %s%-12s%s %s%s%s\n' \
            "$BLUE" "$i" "$RESET" "$BOLD" "$name" "$RESET" "$DIM" "$desc" "$RESET"
        i=$((i + 1))
    done
}

valid_config() {
    local name
    for name in "${configs[@]}"; do
        [ "$name" = "$1" ] && return 0
    done
    return 1
}

preview_config() {
    command -v fastfetch >/dev/null 2>&1 || die "fastfetch is not installed"
    fastfetch --config "$REPO_DIR/$1/config.jsonc"
}

choice=""
case "${1:-}" in
    -h|--help) usage ;;
    -l|--list) list_configs; exit 0 ;;
    -p|--preview)
        [ -n "${2:-}" ] || die "usage: $0 -p <config>"
        valid_config "$2" || die "unknown config: $2 (try -l)"
        preview_config "$2"
        exit 0
        ;;
    "") ;;
    -*) die "unknown option: $1 (try --help)" ;;
    *)
        valid_config "$1" || die "unknown config: $1 (try -l)"
        choice="$1"
        ;;
esac

if [ -z "$choice" ]; then
    [ -t 0 ] || [ -e /dev/tty ] || die "no config given and no terminal to ask on (try: $0 <config>)"
    printf '\n'
    list_configs
    printf '\n'
    while [ -z "$choice" ]; do
        printf '%s' "${BOLD}Pick a config${RESET} ${DIM}(number or name, q to quit)${RESET}: "
        read -r answer < /dev/tty
        case "$answer" in
            q|Q) exit 0 ;;
            ''|*[!0-9]*)
                if valid_config "$answer"; then
                    choice="$answer"
                else
                    warn "unknown config: $answer"
                fi
                ;;
            *)
                if [ "$answer" -ge 1 ] && [ "$answer" -le "${#configs[@]}" ]; then
                    choice="${configs[$((answer - 1))]}"
                else
                    warn "pick a number between 1 and ${#configs[@]}"
                fi
                ;;
        esac
    done
fi

if [ -e "$TARGET_DIR" ] && [ -n "$(ls -A "$TARGET_DIR" 2>/dev/null)" ]; then
    backup="$TARGET_DIR.bak.$(date +%Y%m%d-%H%M%S)"
    mv "$TARGET_DIR" "$backup"
    warn "Existing config backed up to ${BOLD}$backup${RESET}"
fi

mkdir -p "$TARGET_DIR"
cp -r "$REPO_DIR/$choice/." "$TARGET_DIR/"
ok "Installed ${BOLD}$choice${RESET} to ${BOLD}$TARGET_DIR${RESET}"

if command -v fastfetch >/dev/null 2>&1; then
    printf '\n'
    fastfetch
else
    warn "fastfetch doesnt seem to be installed, would you like to install it? [Y/n]"
fi
