#!/usr/bin/env zsh
# ===============================================================
# zlogin — Post-Startup Finalisation & Summary
# ===============================================================

# --- Ensure environment ---
export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
export outfile="${outfile:-$HOME/zshrc-log.json}"
LOGFILE="$outfile"

if [[ ! `typeset -f call_file1` ]]; then
  source "$HOME/.dotfiles/bin/call_file"
fi

# --- Execute all module .zlogin files dynamically ---
zlogin_files=($DOTFILES/**/*.zlogin)
for file in ${zlogin_files[@]}; do
    call_file "${file}" "zlogin"
done

# --- Post-login environment tweaks ---
export PIP_DISABLE_PIP_VERSION_CHECK=1

# --- Clean duplicate PATH entries ---
typeset -U path
PATH=${(Rj/:/)${(us/:/)PATH}:#* *}
export PATH

# --- Timing summary from JSON log ---
# if [[ -f "$LOGFILE" ]]; then
#   echo
#   echo "⏱ Startup Summary:"
#   if command -v jq >/dev/null 2>&1; then
#     jq -r '. | [.label, .duration_ms, .status, .file] | @tsv' "$LOGFILE" \
#       | column -t -s $'\t'
#   else
#     echo "(Install jq to parse $LOGFILE)"
#   fi
# fi

# # --- Optional compdump refresh ---
# [[ -f "$DOTFILES/zsh/compdump.zlogin" ]] && call_file "$DOTFILES/zsh/compdump.zlogin" "compdump"

# # Run completion diagnostics if failures logged
# if grep -q '"label":"compinit".*"exit_code":[1-9]' "$HOME/zshrc-log.json" 2>/dev/null; then
#   echo "⚠️  Re-running compinit_doctor due to prior failure..."
#   ZSH_COMPLETION_DEBUG=1 source "$DOTFILES/zsh/compinit_doctor.zsh"
# fi
# zprof

