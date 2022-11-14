#!/bin/sh
# This will be the run directory
RUN_DIR=`pwd`
# Move up to the parent directory
cd ..
# This will be the base directory
BASE_DIR=`pwd`

# set the java home if neccessary
# JAVA_HOME=

# set java options
JAVA_OPTS="-Dosiris.run.dir=$RUN_DIR -Dosiris.base.dir=$BASE_DIR"

# run java
if [ "x$JAVA_HOME" = "x" ]; then
   JAVA="java"
else
   JAVA="$JAVA_HOME/bin/java"
fi

$JAVA $JAVA_OPTS -classpath lib/*:. com.rameses.server.Shutdown
