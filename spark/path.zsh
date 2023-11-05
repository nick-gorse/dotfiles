

if which java > /dev/null; then export JAVA_HOME=$(/usr/libexec/java_home); fi

# For a ipython notebook and pyspark integration
if which pyspark > /dev/null; then
  export SPARK_VERSION="3.4.1"
  SPARK_HOME="$(brew --cellar apache-spark)/$SPARK_VERSION/libexec"

  if [[ -d $SPARK_HOME ]]; then
    export SPARK_HOME
  fi
  SPARK_BIN="$(brew --cellar apache-spark)/$SPARK_VERSION/bin"
  if [[ -d $SPARK_BIN ]]; then
    export PATH=$SPARK_BIN:$PATH
  fi
  unset SPARK_BIN
  # export PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/build:$PYTHONPATH
  # export PYTHONPATH=$SPARK_HOME/python/lib/py4j-0.10.9.7-src.zip:$PYTHONPATH
fi

# export PYSPARK_PYTHON=/usr/local/bin/python3
# export PYSPARK_DRIVER_PYTHON=jupyter
# export PYSPARK_DRIVER_PYTHON_OPTS=’notebook’