#!/usr/bin/env zsh

# Cache locations can be customized before sourcing this plugin.
typeset -g ZSH_CACHE_DIR="${ZSH_CACHE_DIR:-${TMPDIR:-/tmp}/zsh-${UID:-user}}"
typeset -g DIRCOLORS_CACHE_FILE="${DIRCOLORS_CACHE_FILE:-${ZSH_CACHE_DIR}/neutral-dircolors.zsh}"

# Standardized $0 handling, following:
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
# This MUST run at the top level of the plugin file. Inside a function `$0`
# and `${(%):-%N}` resolve to the function name, not the script path, which
# breaks directory resolution under antidote/oh-my-zsh (see issue #4).
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"
typeset -g __dircolors_neutral_dir="${0:h}"

__dircolors_neutral_dircolors_command() {
  emulate -L zsh

  if (( $+commands[dircolors] )); then
    print -r -- dircolors
    return 0
  fi

  if (( $+commands[gdircolors] )); then
    print -r -- gdircolors
    return 0
  fi

  print -ru2 -- "dircolors-neutral: dircolors/gdircolors not found; skipping dircolors setup"
  return 1
}

__dircolors_neutral_build_cache() {
  emulate -L zsh

  local plugin_dir dircolors_command file
  plugin_dir="${__dircolors_neutral_dir}"
  dircolors_command="$(__dircolors_neutral_dircolors_command)" || return 1

  mkdir -p "${ZSH_CACHE_DIR}" || {
    print -ru2 -- "dircolors-neutral: cannot create cache directory ${ZSH_CACHE_DIR}"
    return 1
  }

  if ! { for file in "${plugin_dir}/dircolors/"*.dircolors; do cat "$file"; done } | \
    "${dircolors_command}" - > "${DIRCOLORS_CACHE_FILE}"; then
    print -ru2 -- "dircolors-neutral: failed to generate cache file ${DIRCOLORS_CACHE_FILE}"
    return 1
  fi
}

__dircolors_neutral_init() {
  emulate -L zsh

  if (( $+functions[zpm] )); then
    zpm load zpm-zsh/colors
  fi

  local plugin_dir
  plugin_dir="${__dircolors_neutral_dir}"

  local -a inputs
  inputs=( "${plugin_dir}/dircolors/"*.dircolors(N) "${plugin_dir}/dircolors-neutral.plugin.zsh"(N) )

  local f newest=${inputs[1]}
  for f in $inputs; do [[ $f -nt $newest ]] && newest=$f; done

  if [[ ! -e $DIRCOLORS_CACHE_FILE || ( -n $newest && $newest -nt $DIRCOLORS_CACHE_FILE ) ]]; then
    __dircolors_neutral_build_cache || return 0
  fi

  source "${DIRCOLORS_CACHE_FILE}" 2>/dev/null || \
    print -ru2 -- "dircolors-neutral: failed to source ${DIRCOLORS_CACHE_FILE}"
}

__dircolors_neutral_init
