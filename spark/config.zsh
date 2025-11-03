
echo "---- start spark config -----" >> $outfile

if which java > /dev/null; then
  declare -A foo
  case $(uname) in
  Darwin)
      # macOS: use explicit Java 17
      export JAVA_HOME=$(/usr/libexec/java_home -v 17)
      ;;
  Linux)
      # Linux: detect javac location
      export JAVA_HOME=$(dirname $(dirname $(readlink -e $(which javac))))
      ;;
  FreeBSD)
      # commands for FreeBSD go here
      ;;
  esac
  echo "JAVA_HOME is set to ${JAVA_HOME} ;" >> $outfile
fi

# For a ipython notebook and pyspark integration
if which pyspark > /dev/null; then
  export SPARK_VERSION="3.5.6"
  
  SPARK_HOME="$( brew --prefix apache-spark )/libexec"

  if [[ -e $SPARK_HOME ]]; then
    echo "SPARK_HOME is set to ${SPARK_HOME}" >> $outfile
    export SPARK_HOME
  fi
  SPARK_SBIN="${SPARK_HOME}/sbin"
  if [[ -e $SPARK_SBIN ]]; then
    echo "SPARK_SBIN is set to ${SPARK_SBIN}" >> $outfile
    export PATH=$SPARK_SBIN:$PATH
  fi
  unset SPARK_SBIN
  SPARK_BIN="${SPARK_HOME}/bin"
  if [[ -e $SPARK_BIN ]]; then
    echo "SPARK_BIN is set to ${SPARK_BIN}" >> $outfile
    export PATH=$SPARK_BIN:$PATH
  fi
  unset SPARK_BIN
  
  
  # export PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/build:$PYTHONPATH
  # export PYTHONPATH=$SPARK_HOME/python/lib/py4j-0.10.9.7-src.zip:$PYTHONPATH
fi

# export PYSPARK_PYTHON=/usr/local/bin/python3
# export PYSPARK_DRIVER_PYTHON=jupyter
# export PYSPARK_DRIVER_PYTHON_OPTS=’notebook’
echo "---- finish spark config -----" >> $outfile