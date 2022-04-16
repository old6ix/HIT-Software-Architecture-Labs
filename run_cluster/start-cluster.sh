#!/bin/bash

# 默认有2个worker
N=${1:-2}

# 启动master节点
docker rm -f sam-hadoop-master &> /dev/null
echo "start sam-hadoop-master container..."
docker run -itd \
                --net=sam-hadoop \
                -p 50070:50070 \
                -p 8088:8088 \
                --name sam-hadoop-master \
                --hostname sam-hadoop-master \
				-v ${PWD}/input:/root/input \
				-v ${PWD}/output:/root/output \
                zhaosuizhi/sam-hadoop:0.1 &> /dev/null

# 启动worker节点
i=1
while [ $i -le $N ]
do
	docker rm -f sam-hadoop-worker$i &> /dev/null
	echo "start sam-hadoop-worker$i container..."
	docker run -itd \
	                --net=sam-hadoop \
	                --name sam-hadoop-worker$i \
	                --hostname sam-hadoop-worker$i \
	                zhaosuizhi/sam-hadoop:0.1 &> /dev/null
	i=$(( $i + 1 ))
done

# 打开master节点的bash
docker exec -it sam-hadoop-master bash
