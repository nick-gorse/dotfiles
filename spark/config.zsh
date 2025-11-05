#!/usr/bin/env zsh
# ===============================================================
# Apache Spark + Java environment configuration (JSON-safe)
# ===============================================================

# --- Java Setup ---
if command -v java >/dev/null 2>&1; then
  case "$(uname)" in
    Darwin)
      # macOS: Prefer explicit Java 17, fallback to latest available
      export JAVA_HOME="$(
        /usr/libexec/java_home -v 17 2>/dev/null || /usr/libexec/java_home 2>/dev/null
      )"
      ;;
    Linux)
      # Linux: infer from javac
      if command -v javac >/dev/null 2>&1; then
        export JAVA_HOME="$(dirname "$(dirname "$(readlink -f "$(command -v javac)")")")"
      fi
      ;;
    FreeBSD)
      # Optional customization placeholder
      ;;
  esac
fi

# --- Spark Setup ---
if command -v pyspark >/dev/null 2>&1 || command -v spark-shell >/dev/null 2>&1; then
  # Detect prefix
  if command -v brew >/dev/null 2>&1; then
    SPARK_PREFIX="$(brew --prefix apache-spark 2>/dev/null)"
  elif [[ -d "/opt/homebrew/opt/apache-spark" ]]; then
    SPARK_PREFIX="/opt/homebrew/opt/apache-spark"
  elif [[ -d "/usr/local/opt/apache-spark" ]]; then
    SPARK_PREFIX="/usr/local/opt/apache-spark"
  else
    SPARK_PREFIX=""
  fi

  # Default to libexec if it exists
  if [[ -n "$SPARK_PREFIX" && -d "$SPARK_PREFIX/libexec" ]]; then
    export SPARK_HOME="$SPARK_PREFIX/libexec"
  elif [[ -z "$SPARK_HOME" && -d "/usr/local/spark" ]]; then
    export SPARK_HOME="/usr/local/spark"
  fi

  # Add bin and sbin to PATH if they exist
  if [[ -n "$SPARK_HOME" ]]; then
    [[ -d "$SPARK_HOME/bin" ]]  && PATH="$SPARK_HOME/bin:$PATH"
    [[ -d "$SPARK_HOME/sbin" ]] && PATH="$SPARK_HOME/sbin:$PATH"
  fi

  export SPARK_VERSION="${SPARK_VERSION:-3.5.6}"
fi

# --- Cleanup ---
unset SPARK_PREFIX

return 0
