ARG VERSION="26.04"

FROM ubuntu:${VERSION}

ARG UID=1000
ARG GID=1000

ENV DEBIAN_FRONTEND=noninteractive

# Combining the apt-get commands into a single run reduces the size of the resulting image.
# The apt-get installations below are interdependent and need to be done in sequence.
RUN apt-get -y update && \
    apt-get -y install apt-transport-https apt-utils && \
    apt-get -y install libterm-readline-gnu-perl software-properties-common && \
    apt-get -y upgrade && \
    apt-get -y install --no-install-recommends \
        build-essential \
        coreutils \
        locales \
        make \
        sudo \
        util-linux && \
    apt-get clean && rm -rf /var/cache/apt/* /var/lib/apt/lists/*

# Set terminal to UTF-8 by default
RUN locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Set up necessary sudo access
RUN (grep -q "^ubuntu:" /etc/group || grep -q ":${GID}:" /etc/group || groupadd -g ${GID} ubuntu) && \
    (grep -q "^sudo:" /etc/group || groupadd sudo) && \
    (grep -q "^ubuntu:" /etc/passwd || grep -q ":${UID}:" /etc/passwd || useradd -m -g ${GID} -s /bin/bash -u ${UID} ubuntu) && \
    usermod --append --groups sudo ubuntu && \
    echo "ubuntu ALL=(ALL:ALL) NOPASSWD: /home/ubuntu/generate" > /etc/sudoers.d/ubuntu && \
    chmod 0440 /etc/sudoers.d/ubuntu

WORKDIR /home/ubuntu

USER ubuntu

COPY *.c *.sh LICENSE Makefile /home/ubuntu
