# shellcheck shell=bash
# Merge récursif d'un arbre vers $HOME (dossiers parents réels ; fichiers link ou copy)

_harden_ssh_tree() {
  local dest_root="$1"

  [[ -d "$dest_root" ]] || return 0
  chmod 700 "$dest_root"
  # Fichiers OpenSSH : 600 (config, clés, known_hosts, …)
  find "$dest_root" -type f -exec chmod 600 {} +
  find "$dest_root" -type d -exec chmod 700 {} +
}

_copy_file() {
  local src="$1"
  local dest="$2"
  local dest_dir

  dest_dir="$(dirname "$dest")"
  mkdir -p "$dest_dir"

  if [[ -L "$dest" ]]; then
    rm -f "$dest"
  elif [[ -e "$dest" ]]; then
    if cmp -s "$src" "$dest" 2>/dev/null; then
      return 0
    fi
    mv "$dest" "${dest}.bak"
    log_warn "Backup: $dest → ${dest}.bak"
  fi

  cp -a "$src" "$dest"
  log_ok "Copy: $dest ← $src"
}

# Usage: merge_tree <link|copy> <src_root> <dest_root>
merge_tree() {
  local mode="$1"
  local src_root="$2"
  local dest_root="$3"
  local src rel dest

  [[ -d "$src_root" ]] || return 0
  mkdir -p "$dest_root"

  while IFS= read -r -d '' src; do
    rel="${src#"$src_root"/}"
    dest="$dest_root/$rel"

    if [[ -d "$src" ]]; then
      mkdir -p "$dest"
      continue
    fi

    case "$mode" in
      link) link_file "$src" "$dest" ;;
      copy) _copy_file "$src" "$dest" ;;
      *)
        log_err "merge_tree: mode inconnu '$mode' (link|copy)"
        return 1
        ;;
    esac
  done < <(find "$src_root" \( -type f -o -type l -o -type d \) ! -path "$src_root" -print0 | sort -z)

  if [[ "$mode" == "copy" && "$(basename "$dest_root")" == ".ssh" ]]; then
    _harden_ssh_tree "$dest_root"
  fi
}
