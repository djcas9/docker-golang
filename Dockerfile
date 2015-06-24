
FROM debian:wheezy

MAINTAINER Dustin Willis Webber

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update
RUN apt-get install -y sudo locales
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN locale-gen en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

ENV GOLANG_VERSION 1.4.2

ENV HOME /root
ENV UTC true

RUN apt-get upgrade -y
RUN apt-get install -y cmake ruby-dev gcc git rpm mercurial gcc-multilib libc6-i386 ruby-dev build-essential autoconf rpm libsqlite3-dev sqlite3
RUN apt-get install -y git wget curl openssl socat mysql-client python
RUN apt-get install -y zlib1g zlib1g-dev libssl-dev libcurl4-openssl-dev libexpat1-dev gettext

# gcc for cgo
RUN apt-get update && apt-get install -y \
		gcc libc6-dev make \
		--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://golang.org/dl/go$GOLANG_VERSION.src.tar.gz \
		| tar -v -C /usr/local/ -xz

RUN cd /usr/local/go/src && ./make.bash --no-clean 2>&1

ENV PATH /usr/local/go/bin:$PATH

RUN mkdir -p /go/src /go/bin && chmod -R 777 /go
RUN mkdir -p /source && chmod -R 777 /source

ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH /go/bin:$PATH

RUN gem install fpm package_cloud --no-ri --no-rdoc

RUN go get github.com/tools/godep
RUN go get github.com/mitchellh/gox
RUN go get github.com/jteeuwen/go-bindata/...

RUN gox -build-toolchain

# go get with private repos is BLAH!@#
RUN git config --global url.ssh://git@github.com/.insteadOf https://github.com/

WORKDIR /source
