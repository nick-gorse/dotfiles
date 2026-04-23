#!/usr/bin/env zsh

__codex_now() { print -r -- "${EPOCHREALTIME:-$(perl -MTime::HiRes=time -e 'printf "%.6f\n", time()')}"; }
__codex_ms(){ awk -v s="$1" -v e="$2" 'BEGIN{printf "%.5f",(e-s)*1000}' ; }
__codex_log(){
  #[[ "$codex_TRACE" = "0" ]] && return 0
  local parent="00-homebrew" phase="$1" start="$2" end="$3" ec="${4:-0}"
  local ms; ms="$(__codex_ms "$start" "$end")"
  local LOGFILE="${outfile:-$HOME/zshrc-log.json}"
  printf '{"kind":"phase","parent":"%s","phase":"%s","start":%.6f,"end":%.6f,"duration_ms":%.5f,"exit_code":%d}\n' \
    "$parent" "$phase" "$start" "$end" "$ms" "$ec" >>"$LOGFILE"
}
__codex_tic(){ _codex_label="$1"; _codex_t0="$(__codex_now)"; }
__codex_toc(){ local ec=${1:-$?}; local _t1="$(__codex_now)"; __codex_log "${_codex_label:-unknown}" "$_codex_t0" "$_t1" "$ec"; unset _codex_label _codex_t0; }

__codex_log(){
  #[[ "$codex_TRACE" = "0" ]] && return 0
  local parent="codex" phase="$1" start="$2" end="$3" ec="${4:-0}"
  local ms; ms="$(__codex_ms "$start" "$end")"
  local LOGFILE="${outfile:-$HOME/zshrc-log.json}"
  printf '{"kind":"phase","parent":"%s","phase":"%s","start":%.6f,"end":%.6f,"duration_ms":%.5f,"exit_code":%d}\n' \
    "$parent" "$phase" "$start" "$end" "$ms" "$ec" >>"$LOGFILE"
}


if (( $+commands[codex] )); then
    __codex_tic "codex completion"
    eval $(codex completion zsh)
    __codex_toc $_
fi