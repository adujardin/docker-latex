FROM ubuntu:xenial

ENV DEBIAN_FRONTEND noninteractive

# Install general dependencies
RUN apt-get -qq -y update 
RUN apt-get -qq -y install curl ghostscript fonts-roboto wget make zip jq git libfontconfig locales software-properties-common

# install latex
RUN apt-get install -qy --no-install-recommends \
	texlive-full

RUN apt-get --purge remove -y .\*-doc$ \
 && apt-get clean -y \
 && rm -rf /var/lib/apt/lists/*

ENV HOME /data
WORKDIR /data
VOLUME ["/data"]
