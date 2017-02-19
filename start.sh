#!/bin/bash

SJS_JAR_PATH=$(find `pwd` -name spark-job-server.jar)
echo SJS_JAR_PATH=$SJS_JAR_PATH
exec $SPARK_HOME/bin/spark-submit --class spark.jobserver.JobServer ${SJS_JAR_PATH}
