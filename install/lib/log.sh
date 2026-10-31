# shellcheck shell=bash
# Helpers de log colorés (désactivés si NO_COLOR ou hors TTY)

_df_log_init() {
  DF_BOLD="" DF_DIM="" DF_RESET=""
  DF_RED="" DF_GREEN="" DF_YELLOW="" DF_BLUE="" DF_CYAN=""

  if [[ -n "${NO_COLOR:-}" ]]; then
    return 0
  fi
  if [[ ! -t 1 && ! -t 2 ]]; then
    return 0
  fi
  if ! command -v tput >/dev/null 2>&1; then
    return 0
  fi

  DF_BOLD="$(tput bold 2>/dev/null || true)"
  DF_DIM="$(tput dim 2>/dev/null || true)"
  DF_RESET="$(tput sgr0 2>/dev/null || true)"
  DF_RED="$(tput setaf 1 2>/dev/null || true)"
  DF_GREEN="$(tput setaf 2 2>/dev/null || true)"
  DF_YELLOW="$(tput setaf 3 2>/dev/null || true)"
  DF_BLUE="$(tput setaf 4 2>/dev/null || true)"
  DF_CYAN="$(tput setaf 6 2>/dev/null || true)"
}
_df_log_init

log_title() {
  echo "${DF_BOLD}$*${DF_RESET}"
}

log_step() {
  echo "${DF_BOLD}${DF_BLUE}→${DF_RESET} ${DF_BOLD}$*${DF_RESET}"
}

log_info() {
  echo "${DF_CYAN}→${DF_RESET} $*"
}

log_ok() {
  echo "${DF_GREEN}✓${DF_RESET} $*"
}

log_warn() {
  echo "${DF_YELLOW}!${DF_RESET} $*"
}

log_err() {
  echo "${DF_RED}✗${DF_RESET} $*" >&2
}

log_hint() {
  echo "${DF_DIM}$*${DF_RESET}"
}
