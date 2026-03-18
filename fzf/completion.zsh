
# Auto-completion
# ---------------
if [[ -d "${FZF_PREFIX}" ]]; then
    call_file "${FZF_PREFIX}/shell/completion.zsh" "fzf-comp"
fi