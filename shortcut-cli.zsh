#!/bin/bash

# Shortcut API & Token
API_BASE='https://api.app.shortcut.com/api/v3'
TOKEN='55a19524-e937-4ec8-9ad9-dab226c88e17'

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
  local prefix=$([[ $type == "bug" ]] && echo "BF" || echo "FEAT")
  echo "${prefix}/sc-${id}-${name}"
}

# Main branch command
storyb() {
 local id=$1
 [[ -z $id ]] && return 1
 
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
story() {
 if [[ -z $1 ]]; then
   cat << 'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Shortcut CLI Help

  storyb <ID>

  Flujo inteligente:
    1. Busca rama vinculada en Shortcut
    2. Comprueba si existe en local
    3. La crea con formato acordado FEAT/sc-1234-name | BF/sc-1234-name
    4. Checkout automático

  
  story <NAME>

  Buscar por nombre en Shortcut.

  Ejemplos:
    storyb 1234
    story fellow
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
   return 1
 fi
 
 local query=$(printf '%s' "$1" | jq -sRr @uri)
 sc_fetch "search/stories?query=$query" | jq -r '.data[]? | "\(.id) | \(.name)"'
}
