
echo "---- start spark config -----" >> $outfile

if which java > /dev/null; then
  echo "JAVA_HOME is set to ${SPARK_HOME} ;" >> $outfile
  declare -A foo
  case $(uname) in
  Darwin)
      # commands for Mac go here
      export JAVA_HOME=$(/usr/libexec/java_home)
      ;;
  Linux)
      # commands for Linux go here
      export JAVA_HOME=$(dirname $(dirname $(readlink -e /usr/bin/javac)))
      ;;
  FreeBSD)
      # commands for FreeBSD go here
      ;;
  esac
  
fi

# For a ipython notebook and pyspark integration
if which pyspark > /dev/null; then
  export SPARK_VERSION="3.4.1"
  
  SPARK_HOME="$(brew --cellar apache-spark)/$SPARK_VERSION/libexec"

  if [[ -e $SPARK_HOME ]]; then
    echo "SPARK_HOME is set to ${SPARK_HOME}" >> $outfile
    export SPARK_HOME
  fi
  SPARK_BIN="$(brew --cellar apache-spark)/$SPARK_VERSION/bin"
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