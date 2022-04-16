# 前置阶段：下载并解压hadoop二进制文件
FROM ubuntu:22.04 AS download

WORKDIR /root

RUN sed -i s/archive.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list && \
    sed -i s/security.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y wget && \
    apt-get clean

RUN wget https://dlcdn.apache.org/hadoop/common/hadoop-3.2.3/hadoop-3.2.3.tar.gz -O hadoop.tar.gz && \
    mkdir hadoop-bin && \
    tar -xzvf hadoop.tar.gz -C hadoop-bin --strip-components 1 && \
    mv hadoop-bin /opt/hadoop && \
    rm hadoop.tar.gz


# 构建hadoop集群节点
FROM ubuntu:22.04

LABEL maintainer="zhaosuizhi (zhaosuizhi@duck.com)"

WORKDIR /root

# apt换源+安装依赖
RUN sed -i s/archive.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list && \
    sed -i s/security.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y \
        openssh-server openjdk-8-jdk && \
    apt-get clean

# 从download阶段复制hadoop
COPY --from=download /opt/hadoop /opt/hadoop

# 设置环境变量
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_HOME=/opt/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

# SSH免密登录
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

# 设置配置文件
COPY config/* /tmp/

RUN mv /tmp/ssh_config ~/.ssh/config && \
    mv /tmp/hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \ 
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/workers $HADOOP_HOME/etc/hadoop/workers && \
    mv /tmp/start-hadoop.sh ~/start-hadoop.sh && \
    mv /tmp/wc-hadoop.sh ~/wc-hadoop.sh

# 设置运行权限
RUN chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh && \
    chmod +x start-hadoop.sh && \
    chmod +x wc-hadoop.sh

# format namenode
RUN $HADOOP_HOME/bin/hdfs namenode -format

# 启动SSH服务后提供命令行交互
CMD [ "sh", "-c", "service ssh start; bash"]
