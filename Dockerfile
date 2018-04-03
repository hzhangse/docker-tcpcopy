FROM ubuntu:xenial
MAINTAINER ryan Zhang <rainbow954@163.com>


RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list


RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates curl openssh-server net-tools wget git && rm -rf /var/lib/apt/lists/*

# https://github.com/Yelp/dumb-init
RUN curl -fLsS -o /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.0.2/dumb-init_1.0.2_amd64 && chmod +x /usr/local/bin/dumb-init

ENV MAVEN_VERSION=3.5.2

# Install Maven
RUN wget -q http://www-eu.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    mkdir /opt/maven && \
    tar xzf apache-maven-${MAVEN_VERSION}-bin.tar.gz -C /opt/maven && \
    rm apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    ln -s /opt/maven/apache-maven-${MAVEN_VERSION}/bin/mvn /usr/local/bin/mvn


#Oracle JDK
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee /etc/apt/sources.list.d/webupd8team-java.list && \
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 && \
    apt-get update && \
    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive  apt-get install -y oracle-java8-installer oracle-java8-set-default && \
    update-alternatives --remove java /usr/lib/jvm/java-9-openjdk-amd64/bin/java && \
    rm -rf /var/cache/oracle-jdk8-installer && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

#tcp copy
RUN git clone git://github.com/session-replay-tools/intercept.git /intercept
RUN apt-get  update&& apt-get install -y build-essential  
RUN apt-get install -y libpcap-dev
RUN cd /intercept && ./configure --prefix=/opt/tcpintercept/ && make && make install
RUN git clone git://github.com/session-replay-tools/tcpcopy.git /tcpcopy
RUN cd /tcpcopy && ./configure --prefix=/opt/tcpcopy/ && make && make install

# 添加测试用户admin，密码admin，并且将此用户添加到sudoers里  
RUN groupadd admin && mkdir -p /home/admin
RUN useradd -d /home/admin -g admin admin && chown -R admin:admin /home/admin
  
RUN echo "admin:admin" | chpasswd  
RUN echo "admin   ALL=(ALL)       ALL" >> /etc/sudoers  
RUN apt-get install -y python python-pip

COPY sshd_config /etc/ssh/sshd_config
COPY data-acceptance.jar /data-acceptance.jar


COPY runTestServer.sh /runTestServer.sh
COPY runOnlineServer.sh /runOnlineServer.sh

COPY entrypoint.sh /entrypoint.sh


RUN chmod a+x  /runOnlineServer.sh
RUN chmod a+x /runTestServer.sh
RUN chmod a+x /entrypoint.sh
RUN chmod a+x /data-acceptance.jar
#USER admin
RUN echo "root:root" | chpasswd  

ENTRYPOINT ["/usr/local/bin/dumb-init", "/entrypoint.sh"]



