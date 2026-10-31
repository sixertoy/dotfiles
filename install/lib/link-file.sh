# shellcheck shell=bash

# Symlink un fichier vers $HOME (backup .bak si conflit)
link_file() {
  local src="$1"
  local dest="$2"
  local dest_dir

  dest_dir="$(dirname "$dest")"
  mkdir -p "$dest_dir"

  if [[ -L "$dest" ]]; then
    local current
    current="$(readlink "$dest")"
    if [[ "$current" == "$src" ]]; then
      return 0
    fi
    rm -f "$dest"
  elif [[ -e "$dest" ]]; then
    mv "$dest" "${dest}.bak"
    log_warn "Backup: $dest → ${dest}.bak"
  fi

  ln -s "$src" "$dest"
  log_ok "Link: $dest → $src"
}
