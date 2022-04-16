#!/bin/bash

# put input files to HDFS
hadoop fs -mkdir -p input
hdfs dfs -put input/* input

# run wordcount
hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/sources/hadoop-mapreduce-examples-3.2.3-sources.jar org.apache.hadoop.examples.WordCount input output

# print the output of wordcount
hdfs dfs -get output/part-r-00000 output
mv output/part-r-00000 output/wc-result.txt
echo -e "\nwordcount result output to \"output/wc-result.txt\""
