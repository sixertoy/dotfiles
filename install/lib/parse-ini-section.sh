# shellcheck shell=bash
# Lit une section INI [name] (1 entrée / ligne ; ignore vides et #) dans un tableau nameref

parse_ini_section() {
  local file="$1"
  local section="$2"
  local -n _pkgs="$3"
  local line in_section=0 found=0

  _pkgs=()

  if [[ ! -f "$file" ]]; then
    log_err "Fichier INI introuvable : $file"
    return 1
  fi

  while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line%%#*}"
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"
    [[ -z "$line" ]] && continue

    if [[ "$line" =~ ^\[(.+)\]$ ]]; then
      if [[ "${BASH_REMATCH[1]}" == "$section" ]]; then
        in_section=1
        found=1
      else
        in_section=0
      fi
      continue
    fi

    [[ "$in_section" -eq 1 ]] || continue
    _pkgs+=("$line")
  done < "$file"

  if [[ "$found" -eq 0 ]]; then
    log_err "Section [$section] absente dans $file"
    return 1
  fi
}
