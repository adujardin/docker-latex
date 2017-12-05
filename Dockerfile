FROM ubuntu:xenial

ARG node_ver=6

MAINTAINER Fermium LABS srl <info@fermiumlabs.com>
ENV HOME /root

ENV DEBIAN_FRONTEND noninteractive

# Install general dependencies
RUN apt-get -qq -y update
RUN apt-get -qq -y install curl wget npm build-essential zip python-pip jq git libfontconfig less libgomp1 libpango-1.0-0 libxt6 libsm6

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

#Install R
ENV MRO_VERSION 3.4.2
WORKDIR /home/docker

# Donwload and install MRO & MKL
RUN curl -LO -# https://mran.blob.core.windows.net/install/mro/$MRO_VERSION/microsoft-r-open-$MRO_VERSION.tar.gz \
	&& tar -xzf microsoft-r-open-$MRO_VERSION.tar.gz
WORKDIR /home/docker/microsoft-r-open
RUN  ./install.sh -a -u

# Clean up downloaded files
WORKDIR /home/docker
RUN rm microsoft-r-open-*.tar.gz \
	&& rm -r microsoft-r-open
COPY MKL_EULA.txt MKL_EULA.txt
COPY MRO_EULA.txt MRO_EULA.txt
RUN echo 'cat("\n", readLines("/home/docker/MKL_EULA.txt"), "\n", sep="\n")' >> /usr/lib64/microsoft-r/$MRO_VERSION_MAJOR.$MRO_VERSION_MINOR/lib64/R/etc/Rprofile.site \
	&& echo 'cat("\n", readLines("/home/docker/MRO_EULA.txt"), "\n", sep="\n")' >> /usr/lib64/microsoft-r/$MRO_VERSION_MAJOR.$MRO_VERSION_MINOR/lib64/R/etc/Rprofile.site

# Overwrite default behaviour to never save workspace, see https://mran.revolutionanalytics.com/documents/rro/reproducibility/doc-research/
RUN echo 'utils::assignInNamespace("q", function(save = "no", status = 0, runLast = TRUE) { \
     .Internal(quit(save, status, runLast)) }, "base") \
utils::assignInNamespace("quit", function(save = "no", status = 0, runLast = TRUE) { \
     .Internal(quit(save, status, runLast)) }, "base")' >> /usr/lib64/microsoft-r/$MRO_VERSION_MAJOR.$MRO_VERSION_MINOR/lib64/R/etc/Rprofile.site

# Add demo script
COPY demo.R demo.R

ARG VCS_URL
ARG VCS_REF
ARG BUILD_DATE


# Clean apt lists
RUN rm -rf /var/lib/apt/lists/*

WORKDIR /data
VOLUME ["/data"]
