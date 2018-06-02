FROM ubuntu:xenial

#########################################
ENV HOME /root
WORKDIR /root

ENV DEBIAN_FRONTEND noninteractive

# Install general dependencies
RUN apt-get -qq -y update 
RUN apt-get -qq -y install curl wget make zip jq git libfontconfig locales software-properties-common

# Install Roboto font, ghostscript, pandoc extensions
RUN apt-get -qq -y install  ghostscript

# Install a few beautiful fonts
RUN apt-get -qq -y install fonts-roboto

# Popular documentation generator
RUN apt-get -qq -y install doxygen mkdocs graphviz

# Install latest TexLive
RUN wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
RUN tar -zxvf install-tl-unx.tar.gz
COPY texlive.profile .
RUN install-*/install-tl --profile=texlive.profile
RUN rm -rf install-tl*

#Export useful texlive paths
ENV PATH /opt/texbin:$PATH
ENV PATH /usr/local/texlive/2017/bin/x86_64-linux:$PATH

# Test Latex
RUN wget ftp://www.ctan.org/tex-archive/macros/latex/base/small2e.tex 
RUN latex  small2e.tex
RUN xelatex small2e.tex

RUN  rm -rf /var/lib/apt/lists/*
RUN rm -rf /root/*

WORKDIR /data
VOLUME ["/data"]
