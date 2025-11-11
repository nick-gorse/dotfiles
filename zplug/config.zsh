# --- zplug speed-optimised config with per-action tracer ---

# ========= tracer (NDJSON to $outfile) =========
: "${ZP_TRACE:=0}"   # set ZP_TRACE=0 to disable fine-grained phase logs

__zp_now() {
  print -r -- "${EPOCHREALTIME:-$(perl -MTime::HiRes=time -e 'printf \"%.6f\n\", time()')}"
}
__zp_ms() { awk -v s="$1" -v e="$2" 'BEGIN{printf "%.5f",(e-s)*1000}'; }
__zp_log() {
  [[ "$ZP_TRACE" = "0" ]] && return 0
  local parent="zplug" phase="$1" start="$2" end="$3" ec="${4:-0}" ms
  ms="$(__zp_ms "$start" "$end")"
  local LOGFILE="${outfile:-$HOME/zshrc-log.json}"
  printf '{"kind":"phase","parent":"%s","phase":"%s","start":%.6f,"end":%.6f,"duration_ms":%.5f,"exit_code":%d}\n' \
    "$parent" "$phase" "$start" "$end" "$ms" "$ec" >>"$LOGFILE"
}
__zp_tic(){ _zp_label="$1"; _zp_t0="$(__zp_now)"; }
__zp_toc(){ local ec=${1:-$?}; local _t1="$(__zp_now)"; __zp_log "${_zp_label:-unknown}" "$_zp_t0" "$_t1" "$ec"; unset _zp_label _zp_t0; }

# ========= zplug environment =========
export ZPLUG_HOME="$HOME/.zplug"
export ZPLUG_CACHE_DIR="$HOME/.cache/zplug"
mkdir -p -- "$ZPLUG_CACHE_DIR" 2>/dev/null

# Use zplug cache (speeds up load resolution)
export ZPLUG_USE_CACHE=true

# Load from external package list (your existing file)
export ZPLUG_LOADFILE="${DOTFILES}/zplug/packages"

# ========= ensure zplug repo exists =========
if [[ ! -d "$ZPLUG_HOME" ]]; then
  __zp_tic "ensure zplug repo (clone)"
  git clone --depth=1 https://github.com/zplug/zplug "$ZPLUG_HOME" >/dev/null 2>&1
  __zp_toc $?
fi

# ========= init zplug (keep your call_file for top-level timing) =========
# This preserves your existing log entry with label "zplug" from call_file,
# and ALSO logs a phase entry here for finer granularity.
__zp_tic "zplug init (source)"
source "$ZPLUG_HOME/init.zsh" >/dev/null 2>&1
__zp_toc $?

# If 'zplug' command isn’t available after init, bail (don’t spam stdout)
if ! command -v zplug >/dev/null 2>&1; then
  # log a failing phase for visibility
  __zp_tic "zplug command check"
  __zp_toc 127
  return 0
fi

# ========= check plugins =========
__zp_tic "zplug check"
zplug check --verbose >/dev/null 2>&1
zp_need_install=$?
__zp_toc $zp_need_install

# ========= install missing (conditional) =========
if (( zp_need_install != 0 )); then
  __zp_tic "zplug install"
  zplug install >/dev/null 2>&1
  __zp_toc $?
fi

# ========= load plugins =========
__zp_tic "zplug load"
# If a plugin fails to load, zplug returns non-zero; we log the exit code
zplug load >/dev/null 2>&1
__zp_toc $?

# (Optional) You can add more phases here if you later enable 'zplug update',
# byte-compilation, or lazy-loading groups.