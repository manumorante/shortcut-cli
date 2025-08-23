#!/bin/bash

# Shortcut API & Token
API_BASE='https://api.app.shortcut.com/api/v3'
TOKEN='<your-Shortcut-token>'

# Shortcut Fetcher
sc_fetch() { curl -s "$API_BASE/$1" -H "Shortcut-Token: $TOKEN" | tr -d '\r'; }

# Git checkout helper
_checkout_branch() {
  local branch=$1
  if ! git checkout "$branch" 2>/dev/null; then
    echo "No existe en origin, creando local..."
    git checkout -b "$branch"
  fi
}

# Find existing branch (Shortcut or local)
_find_existing_branch() {
  local id=$1 story=$2
  local branch from
  
  # Try Shortcut first
  branch=$(jq -r '.branches[0].name // empty' <<< "$story" 2>/dev/null)
  [[ -n $branch ]] && from="Shortcut" && echo "$branch|$from" && return 0
  
  # Try local git
  branch=$(git branch -a 2>/dev/null | grep -E "sc-$id(-|$)" | head -1 | sed 's/^[* ]*//' | sed 's/^remotes\/origin\///')
  [[ -n $branch ]] && from="local" && echo "$branch|$from" && return 0
  
  echo "||" && return 1
}

# Generate new branch name
_generate_branch_name() {
  local id=$1 story=$2
  local name=$(jq -r '.name // empty' <<< "$story" | tr '[:upper:]' '[:lower:]' | tr -cs '[:alnum:]' '-' | sed 's/-$//')
  local type=$(jq -r '.story_type // empty' <<< "$story")
  local prefix=$([[ $type == "bug" ]] && echo "bf" || echo "feat")
  echo "${prefix}/${name}-sc-${id}"
}

# Show help manual
_show_help() {
  cat << 'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Shortcut CLI Help

  story <ID>

  Flujo inteligente:
    1. Busca rama vinculada en Shortcut
    2. Comprueba si existe en local
    3. La crea con formato acordado feat/name-sc-1234 | bf/name-sc-1234
    4. Checkout automático

  
  stories <NAME>

  Buscar por nombre en Shortcut.

  Ejemplos:
    story 1234
    stories fellow
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
}

# Main branch command
story() {
 local id=$1
 [[ -z $id ]] && _show_help && return 1
 
 local story=$(sc_fetch "stories/$id")
 local branch_info=$(_find_existing_branch "$id" "$story")
 
 if [[ $branch_info != "||" ]]; then
   IFS='|' read -r branch from <<< "$branch_info"
   echo "Rama $from → $branch"
   _checkout_branch "$branch"
 else
   local branch=$(_generate_branch_name "$id" "$story")
   echo "No existe → Creando: $branch"
   git checkout -b "$branch"
 fi
}

# Search stories
stories() {
 if [[ -z $1 ]]; then
   _show_help
   return 1
 fi
 
 local query=$(printf '%s' "$1" | jq -sRr @uri)
 sc_fetch "search/stories?query=$query" | jq -r '.data[]? | "\(.id) | \(.name)"'
}
