ARG BASE
FROM ${BASE}

RUN apt-get update && \
    apt-get install -y cmake debhelper autotools-dev libaio-dev wget libreadline-dev \
	automake libtool bison libncurses-dev libz-dev cmake bzr libgcrypt11-dev \
	build-essential flex bison automake autoconf bzr libtool cmake libaio-dev \
	mysql-client libncurses-dev zlib1g-dev libboost-dev libcurl4-openssl-dev

RUN wget -q https://www.percona.com/downloads/Percona-Server-LATEST/Percona-Server-5.7.22-22/source/tarball/percona-server-5.7.22-22.tar.gz && \
    tar xzf percona-server-5.7.22-22.tar.gz && \
    cd percona-server-5.7.22-22 && \
    cmake  -DDOWNLOAD_BOOST=ON -DWITH_BOOST=$HOME/my_boost . && \
    make && \
    make install
