FROM ubuntu:xenial

ARG node_ver=6

MAINTAINER Fermium LABS srl <info@fermiumlabs.com>
ENV HOME /root

ENV DEBIAN_FRONTEND noninteractive

# Install general dependencies
RUN apt-get -qq -y update
RUN apt-get -qq -y install curl wget npm build-essential zip python-pip jq git libfontconfig less libgomp1 libpango-1.0-0 libxt6 libsm6  software-properties-common  apt-transport-https
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN add-apt-repository 'deb [arch=amd64,i386] https://cran.rstudio.com/bin/linux/ubuntu xenial/'
RUN apt-get -qq -y update
# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_$node_ver.x -o nodesource_setup.sh && chmod +x nodesource_setup.sh
RUN ./nodesource_setup.sh
RUN apt-get -qq -y install nodejs
#RUN ln -s --force /usr/bin/nodejs /usr/bin/node

# Install latest TexLive
RUN wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
RUN tar -zxvf install-tl-unx.tar.gz
COPY texlive.profile .
RUN install-*/install-tl --profile=texlive.profile
RUN rm -rf install-tl*

#Export useful paths
ENV PATH /opt/texbin:$PATH
ENV PATH /usr/local/texlive/2017/bin/x86_64-linux:$PATH

# Test Latex
RUN wget ftp://www.ctan.org/tex-archive/macros/latex/base/small2e.tex
RUN latex  small2e.tex
RUN xelatex small2e.tex

# Install Roboto font, ghostscript, pandoc extensions
RUN apt-get -qq -y install  ghostscript fonts-roboto
RUN pip install --upgrade pip
RUN pip install pandoc-fignos pandoc-eqnos pandoc-tablenos

# Log what version of node we're running on
RUN echo "node version $(node -v) running"
RUN echo "npm version $(npm -v) running"

# Download the latest version of pandoc and install it
RUN wget `curl https://api.github.com/repos/jgm/pandoc/releases/latest | jq -r '.assets[] | .browser_download_url | select(endswith("deb"))'` -O pandoc.deb
RUN dpkg -i pandoc.deb && rm pandoc.deb

# Popular documentation generator
RUN apt-get -qq -y install doxygen mkdocs graphviz

# Install R
RUN apt-get -qq -y install r-base

# Clean apt lists
RUN rm -rf /var/lib/apt/lists/*

WORKDIR /data
VOLUME ["/data"]
