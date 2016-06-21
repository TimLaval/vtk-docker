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
RUN apt-get install -y qt5-default
RUN apt-get install -y libqt5x11extras5-dev
RUN apt-get install -y qttools5-dev
RUN apt-get install -y python-pyqt5
RUN apt-get install -y python3-sip-dev
RUN apt-get install -y pyqt5-dev

RUN mkdir -p /opt/{src,bin}
WORKDIR /opt/src

RUN git clone https://gitlab.kitware.com/srikanthnagella/vtk.git
WORKDIR /opt/src/vtk
RUN git checkout master
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
  -DVTK_WRAP_PYTHON:BOOL=ON \
  -DVTK_WRAP_PYTHON_SIP:BOOL=ON \
  -DVTK_Group_Qt:BOOL=ON \
  -DVTK_QT_VERSION:STRING=5 \
  -DSIP_PYQT_DIR=/usr/share/sip/PyQt5/ \
  ../../src/vtk
RUN ninja
