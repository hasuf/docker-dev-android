FROM fedora

# Install the appropriate software
RUN yum -y install yum-plugin-fastestmirror
RUN yum -y install \
   bitstream-vera-sans-fonts \
   bitstream-vera-serif-fonts \
   bitstream-vera-sans-mono-fonts \
   bitstream-vera-fonts-common \
   coreutils \
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
   wget \
   xdialog \
   xorg-x11-fonts-misc \
   xorg-x11-font-utils \
   xorg-x11-xauth 



RUN yum -y install terminology

# set up root passwd **NOTE** INSECURE!!
RUN echo insecure | passwd --stdin root

# Add a user
RUN env
RUN groupadd -g 1000 user
RUN useradd -g 1000 -u 600  -ms /bin/bash user
RUN usermod -a -G video user

# get jdk
RUN wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u45-b14/jdk-8u45-linux-x64.rpm"
RUN yes | rpm -Uvh jdk-8u45-linux-x64.rpm

## java ##
RUN alternatives --install /usr/bin/java java /usr/java/latest/jre/bin/java 200000
## javaws ##
RUN alternatives --install /usr/bin/javaws javaws /usr/java/latest/jre/bin/javaws 200000
 
## Java Browser (Mozilla) Plugin 64-bit ##
# No Browser installed RUN alternatives --install /usr/lib64/mozilla/plugins/libjavaplugin.so libjavaplugin.so.x86_64 /usr/java/latest/jre/lib/amd64/libnpjp2.so 200000
 
## Install javac only if you installed JDK (Java Development Kit) package ##
RUN alternatives --install /usr/bin/javac javac /usr/java/latest/bin/javac 200000
RUN alternatives --install /usr/bin/jar jar /usr/java/latest/bin/jar 200000


## Android Studio
WORKDIR /tmp/
RUN wget http://dl.google.com/dl/android/studio/ide-zips/1.1.0/android-studio-ide-135.1740770-linux.zip 
RUN wget http://dl.google.com/android/android-sdk_r24.1.2-linux.tgz 

RUN mkdir -p /usr/local/bin
RUN mkdir -p /usr/local/share
ADD init.sh /usr/local/bin/
ADD menu.sh /usr/local/bin/
ADD moony-avatar-eyes-small.xpm /usr/local/share/
ADD kvm-mknod.sh /usr/local/bin/

# set up android studio on /usr/local
WORKDIR /usr/local
RUN unzip /tmp/android-studio-ide*
RUN chown -R user.user /usr/local/

RUN echo "user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/user && \
    chmod 0440 /etc/sudoers.d/user 

WORKDIR /home/user
RUN if [ ! -e android-sdk-linux ]; then tar xvfz /tmp/android-sdk_r24.1.2-linux.tgz; chown -R user.user android-sdk-linux;fi

# switch to user and run program
USER user
ENV HOME /home/user
WORKDIR /home/user
ENV JAVA_HOME /usr/java/latest

# unzip sdk if it don't exist

USER root
CMD    /usr/bin/bash /usr/local/bin/init.sh
