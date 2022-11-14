#!/bin/sh
# This will be the run directory
RUN_DIR=`pwd`
# Move up to the parent directory
cd ..
# This will the base directory
BASE_DIR=`pwd`

# set the java home if neccessary
# JAVA_HOME=

# set java options
if [ "x$JAVA_MEM" = "x" ]; then
   JAVA_OPTS_MEM="-Xmx4096m"
else
   JAVA_OPTS_MEM="$JAVA_MEM"
fi

JAVA_OPTS="$JAVA_OPTS_MEM -Dosiris.run.dir=$RUN_DIR -Dosiris.base.dir=$BASE_DIR -Duser.language=en"

# run java
if [ "x$JAVA_HOME" = "x" ]; then
   JAVA="java"
else
   JAVA="$JAVA_HOME/bin/java"
fi

echo ""
echo "================================================================="
echo ""
echo " Osiris3 Server (ETRACS)  "
echo ""
echo " JAVA      : $JAVA "
echo " JAVA_HOME : $JAVA_HOME "
echo " JAVA_OPTS : $JAVA_OPTS "
echo ""
echo "================================================================="
echo ""

rm -f bin/.osiris_pid
$JAVA $JAVA_OPTS -cp lib/*:. com.rameses.main.bootloader.MainBootLoader
