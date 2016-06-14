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

RUN mkdir -p /opt/{src,bin}
WORKDIR /opt/src

RUN git clone http://vtk.org/VTK.git
WORKDIR /opt/src/VTK
RUN git checkout v6.1.0
RUN sed -i 's/\/\/#define\ GLX_GLXEXT_LEGACY/#define\ GLX_GLXEXT_LEGACY/g' Rendering/OpenGL/vtkXOpenGLRenderWindow.cxx

RUN echo 'deb-src http://http.debian.net/debian jessie main' >> /etc/apt/sources.list
RUN echo 'deb-src http://http.debian.net/debian jessie-updates main' >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get build-dep -y libvtk6-dev
RUN mkdir -p /opt/bin/VTK
WORKDIR /opt/bin/VTK
RUN cmake -G Ninja \
  -DCMAKE_BUILD_TYPE:STRING=Release \
  -DBUILD_TESTING:BOOL=OFF \
  ../../src/VTK
RUN ninja
RUN ninja install  
