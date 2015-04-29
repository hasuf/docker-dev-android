FROM fedora

# Install the appropriate software
RUN yum -y install yum-plugin-fastestmirror ; \
   yum -y install \
   bitstream-vera-sans-fonts \
   bitstream-vera-serif-fonts \
   bitstream-vera-sans-mono-fonts \
   bitstream-vera-fonts-common \
   fontpackages-filesystem \
   fontconfig \
   git \
   libgcc \
   libgcc.i686 \
   libfontenc \
   libstdc++ \
   libstdc++.i686 \
   libXfont \
   libXtst \
   libz.so.1 \
   llvm \
   lyx-fonts \
   man \
   mesa-dri-drivers \
   passwd \
   qemu-kvm \
   sudo \
   unzip \
   tar \
   terminus-fonts \
   usbutils \
   wget \
   xdialog \
   xorg-x11-fonts-misc \
   xorg-x11-font-utils \
   xorg-x11-xauth \
   # install a good terminal 
   terminology \
   && yum clean all

# User setup stuff
# NOTE: Would love to parameterize the user and group ID. But... how?
RUN    \
       # Create user and group for devuser using specific id's
       export GROUPID=1000 ; export USERID=600 \
    && groupadd -g $GROUPID devuser \
    && useradd -g $GROUPID -u $USERID -ms /bin/bash devuser \
    && usermod -a -G video devuser \
       # set up sudo access
    && echo "devuser ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/devuser \
    && chmod 0440 /etc/sudoers.d/devuser \
       # set up vi bindings by default
    &&  echo "set -o vi" >> /etc/bashrc

# get and install jdk... java 8u45
RUN    export JAVA_VERSION=8u45 ; export JAVA_BUILD=b14 \
    && wget --quiet --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/$JAVA_VERSION-$JAVA_BUILD/jdk-$JAVA_VERSION-linux-x64.rpm" -O /tmp/jdk.rpm \
    && yes | rpm -Uvh /tmp/jdk.rpm \
    && rm /tmp/jdk.rpm \
    && alternatives --install /usr/bin/java java /usr/java/latest/jre/bin/java 200000 \ 
    && alternatives --install /usr/bin/javaws javaws /usr/java/latest/jre/bin/javaws 200000 \
    && alternatives --install /usr/bin/javac javac /usr/java/latest/bin/javac 200000 \
    && alternatives --install /usr/bin/jar jar /usr/java/latest/bin/jar 200000 \
    && echo "export JAVA_HOME /usr/java/latest" >> /etc/bashrc

## Android Studio
RUN    cd /tmp \
    && wget --quiet http://dl.google.com/dl/android/studio/ide-zips/1.1.0/android-studio-ide-135.1740770-linux.zip \
    && wget --quiet "https://plugins.jetbrains.com/plugin/download?pr=&updateId=18014" -O ideavim.zip \
    && mkdir -p /usr/local/bin \
    && mkdir -p /usr/local/share \
    && unzip /tmp/android-studio-ide* -d /usr/local/ \
    && rm /tmp/android-studio-ide* \
    && unzip /tmp/ideavim.zip -d /usr/local/android-studio/plugins \
    && rm /tmp/ideavim.zip

COPY init.sh /usr/local/bin/
COPY menu.sh /usr/local/bin/
COPY kvm-mknod.sh /usr/local/bin/
COPY moony-avatar-eyes-small.xpm /usr/local/share/

# set up android studio on /usr/local
RUN chown -R devuser.devuser /usr/local/

# give the name of the terminal program to run
CMD    /usr/bin/bash /usr/local/bin/init.sh terminology
