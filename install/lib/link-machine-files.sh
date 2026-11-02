# shellcheck shell=bash
# Symlinks files/common/home + files/<machine>/home

# Copie locale non destructive (secrets injectés ensuite ; ne pas symlinker vers le dépôt)
_copy_home_file_once() {
  local src="$1"
  local dest="$2"
  local target

  if [[ -L "$dest" ]]; then
    target="$(readlink "$dest")"
    rm -f "$dest"
    cp -a "$target" "$dest"
    chmod 600 "$dest"
    log_ok "Materialize: $dest (copie locale)"
    return 0
  fi

  if [[ -e "$dest" ]]; then
    log_info "Conserve: $dest (fichier local)"
    return 0
  fi

  mkdir -p "$(dirname "$dest")"
  cp -a "$src" "$dest"
  chmod 600 "$dest"
  log_ok "Copy: $dest ← $src"
}

# Installe chaque entrée d'un dossier vers $HOME
# (.config / .local = merge symlink ; .ssh = merge copie ;
#  .npmrc = copie locale une fois ; reste = symlink top-level)
_link_dir_contents() {
  local src_dir="$1"
  local name src dest

  [[ -d "$src_dir" ]] || return 0

  # Inclut les fichiers cachés (.*), ignore . et ..
  for src in "$src_dir"/.* "$src_dir"/*; do
    [[ -e "$src" ]] || continue
    name="$(basename "$src")"
    [[ "$name" == "." || "$name" == ".." ]] && continue
    dest="$HOME/$name"

    if [[ -d "$src" ]]; then
      case "$name" in
        .config|.local)
          merge_tree link "$src" "$dest"
          continue
          ;;
        .ssh)
          merge_tree copy "$src" "$dest"
          continue
          ;;
      esac
    fi

    if [[ "$name" == ".npmrc" ]]; then
      _copy_home_file_once "$src" "$dest"
      continue
    fi

    link_file "$src" "$dest"
  done
}

link_machine_files() {
  local machine="${1:-}"
  require_machine "$machine" || return 1

  _link_dir_contents "$DOTFILES_ROOT/files/common/home"
  _link_dir_contents "$DOTFILES_ROOT/files/${machine}/home"
}
