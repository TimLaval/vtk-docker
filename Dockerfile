FROM ubuntu
MAINTAINER Srikanth Nagella <srikanth.nagella@stfc.ac.uk>


# Install dependencies
RUN apt-get update

RUN apt-get install -y build-essential
RUN apt-get install -y cmake cmake-curses-gui
RUN apt-get install -y subversion
RUN apt-get install -y git
RUN apt-get install -y ninja-build
RUN apt-get install -y python-dev
