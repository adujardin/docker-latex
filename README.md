<a href="https://fermiumlabs.com/">
    <img src="https://fermiumlabs.com/Assets/img/logos/Horizontal-Main_500px.png" alt="Fermium LABS logo" width="200" align="right" />
</a>

# Latex docker container

[![Docker Pulls](https://img.shields.io/docker/pulls/fermiumlabs/latex-docker.svg?maxAge=2592000)](https://hub.docker.com/r/fermiumlabs/latex-docker/) [![Docker Pulls](https://img.shields.io/docker/automated/fermiumlabs/latex-docker.svg?maxAge=2592000)](https://hub.docker.com/r/fermiumlabs/latex-docker/)  [![Docker Pulls](https://img.shields.io/docker/stars/fermiumlabs/latex-docker.svg?maxAge=2592000)](https://hub.docker.com/r/fermiumlabs/latex-docker/) [![](https://images.microbadger.com/badges/image/fermiumlabs/latex-docker.svg)](https://microbadger.com/images/fermiumlabs/latex-docker "Get your own image badge on microbadger.com")


This container is intended to be used as a base image in CI builds for document authoring systems. The image is **rebuilt every week** automatically with the latest LaTex updates.

## Features

Includes the following packages and utilities:

* [Node.js](https://nodejs.org/it/) (defaults to 6)
  - [Yarn](https://yarnpkg.com/en/)
* TexLive 2017 full automatically installed from the TexLive repository
* Zip, wget and similar unix tools
* Pandoc (defaults to 1.17)
  * [pandoc-fignos](https://github.com/tomduck/pandoc-fignos)
  * [pandoc-eqnos](https://github.com/tomduck/pandoc-eqnos)
  * [pandoc-tablenos](https://github.com/tomduck/pandoc-tablenos)
* R
  - [bookdown](https://bookdown.org/)
  - [rmarkdown](http://rmarkdown.rstudio.com/)
* [Kindlegen](https://www.amazon.com/gp/feature.html?docId=1000765211)
* 
## Usage

Pull image ([from Hub](https://hub.docker.com/r/fermiumlabs/latex-docker/)):

```bash
docker pull fermiumlabs/latex-docker
```

Or build:

```bash
git clone https://github.com/fermiumlabs/latex-docker.git
cd latex-docker
#Beware: building it's a very long process
docker build -t fermiumlabs/latex-docker .
```

Make commands:

```bash
make pull    #pull the docker container from the prebuilt public image
make build   #build the image from this GitHub repository. long process
make shell   #allows you to interact with the container
make run     #run the container and then destroys it
make start   #start the container
make stop    #stop the container
make rm      #remove the container and free disk space
```
## Options

Options can be specified through docker's arguments.

##### Node Version

```bash
docker build . -t fermiumlabs/latex-docker:node-7 --build-arg node_ver=7
```

##### Pandoc Version

```bash
docker build . -t fermiumlabs/latex-docker:pandoc-1.17.2 --build-arg pandoc_ver=1.17.2
```

## Usage in Wercker CI

Simply add as a first line this statement:

```
box: fermiumlabs/latex-docker:latest
```
---

<a href="https://twitter.com/intent/user?screen_name=fermiumlabs">
    <img src="https://img.shields.io/twitter/follow/fermiumlabs.svg?style=social&label=Follow" alt="Follow Fermium LABS on Twitter" align="right" />
</a>
