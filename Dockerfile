FROM madskonradsen/centos-supervisor

RUN yum makecache
# Chrome need the fonts and the RPM-stuff is needed to build our RPMs
RUN yum install -y jre wget git bzip2 gnu-free-sans-fonts rpm-build redhat-rpm-config subversion
#RUN yum install -y google-chrome-stable
RUN wget http://dist.control.lth.se/public/CentOS-7/x86_64/google.x86_64/google-chrome-stable-96.0.4664.45-1.x86_64.rpm
RUN yum install -y google-chrome-stable-96.0.4664.45-1.x86_64.rpm
# Default dependencies required by electron
RUN yum install -y clang dbus-devel libudev-devel gtk3-devel libnotify-devel libusbx-devel libgnome-keyring-devel xorg-x11-server-utils libcap-devel cups-devel libXtst-devel alsa-lib-devel libXrandr-devel nss-devel python-dbusmock
# Needed to build electron stuff for windows
RUN yum install -y gcc make wine gcc-c++
# Install nvm to handle different node versions for anywhere and anywhere-desktop
ENV NVM_DIR "$HOME/.nvm"
RUN mkdir ${NVM_DIR}
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.35.3/install.sh | bash
ENV NODE_VERSION v8.17.0
RUN /bin/bash -c "source $NVM_DIR/nvm.sh && nvm install $NODE_VERSION && nvm alias default $NODE_VERSION && nvm use default"
ENV NODE_PATH $NVM_DIR/versions/node/$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/$NODE_VERSION/bin:$PATH
RUN /bin/bash -c "source $NVM_DIR/nvm.sh && nvm install 12.14"
RUN /bin/bash -c "source $NVM_DIR/nvm.sh && nvm install 14.17"
ADD jenkins.sh /jenkins.sh
RUN rm -f /etc/localtime
RUN ln -s /usr/share/zoneinfo/CET /etc/localtime
ENV LANG=en_US.utf8
