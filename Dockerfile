#base image
FROM openjdk:7-jdk

MAINTAINER Alexey Kuznetsov <kuznetsovalexey34@gmail.com>

#ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
#RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-oracle" >> /etc/environment
#ARG DEBIAN_FRONTEND=noninteractive
#RUN echo "export DEBIAN_FRONTEND=noninteractive" >> /etc/environment
#ENV ANDROID_HOME /opt/android-sdk-linux
#RUN echo "export ANDROID_HOME=/opt/android-sdk-linux" >> /etc/environment
#ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:/opt/gradle/gradle-4.4.1/bin
#RUN echo "export PATH=${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:/opt/gradle/gradle-4.4.1/bin" >> /etc/environment

RUN echo "root:root" | chpasswd

#Install a basic SSH server
RUN apt-get update && apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

#SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

#install ant
RUN apt-get install -y ant

#install vim
RUN apt-get install -y vim

#Cleaning
RUN apt-get clean
RUN apt-get autoclean
RUN apt-get autoremove


#Standard SSH port
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

RUN apt-get install -y junit
RUN apt-get install -y libmail-java
RUN mkdir -p /opt/junit && ln -s /usr/share/java/junit.jar /opt/junit/junit.jar && mkdir -p /opt/javamail && ln -s /usr/share/java/javax.mail.jar /opt/javamail/mail.jar
