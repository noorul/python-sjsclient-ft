FROM instructure/java:8

ENV SPARK_HOME /usr/share/spark
ENV JAVA_OPTIONS "-Xmx1500m -XX:MaxPermSize=512m -Dakka.test.timefactor=3"

USER root
# install and cache sbt, python

RUN echo 'deb http://dl.bintray.com/sbt/debian /' > /etc/apt/sources.list.d/sbt.list && \
    apt-get -qq update && \
    apt-get install -y --force-yes python3 python3-pip python-pip sbt=0.13.12 && \
    sbt
# running sbt downloads some of its internals, speed up sebsequent sbt runs

RUN pip install --upgrade pip && \
    pip install py4j pyhocon tox && \
    pip3 install --upgrade pip && \
    pip3 install py4j pyhocon tox

RUN mkdir ${SPARK_HOME} && \
    curl -L -o /tmp/spark.tgz http://d3kbcqa49mib13.cloudfront.net/spark-1.6.2-bin-hadoop2.6.tgz && \
    tar xzf /tmp/spark.tgz --strip-components=1 --directory ${SPARK_HOME} && \
    rm /tmp/spark.tgz

RUN git clone https://github.com/spark-jobserver/spark-jobserver /opt/spark-jobserver

WORKDIR /opt/spark-jobserver

RUN sbt job-server-extras/assembly && sbt job-server-tests/package && sbt buildPyExamples

COPY start.sh start.sh
