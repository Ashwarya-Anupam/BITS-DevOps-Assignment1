FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Kolkata

RUN apt-get update && apt-get install -y --no-install-recommends sudo curl docker.io openjdk-17-jdk git openssh-server &&  rm -rf /var/lib/apt/lists/* && mkdir /var/run/sshd
RUN useradd -m -s /bin/bash jenkins && \
    echo "jenkins:jenkins" | chpasswd && \
    mkdir -p /home/jenkins/.ssh
COPY id_ed25519.pub /home/jenkins/.ssh/authorized_keys
RUN chown -R jenkins:jenkins /home/jenkins/.ssh && \
    chmod 700 /home/jenkins/.ssh && \
    chmod 600 /home/jenkins/.ssh/authorized_keys

RUN usermod -aG docker jenkins

RUN curl -LO https://golang.org/dl/go1.21.3.linux-amd64.tar.gz && \
    tar -C /usr/local -xvzf go1.21.3.linux-amd64.tar.gz && \
    rm go1.21.3.linux-amd64.tar.gz

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

 