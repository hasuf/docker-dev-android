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
   libXfont \
   libXtst \
   libfontenc \
   lyx-fonts \
   passwd \
   unzip \
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
RUN useradd -ms /bin/bash user

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
ADD http://dl.google.com/dl/android/studio/ide-zips/1.1.0/android-studio-ide-135.1740770-linux.zip /tmp/

ADD menu.sh /home/user/menu.sh
ADD moony-avatar-eyes-small.xpm /home/user/

WORKDIR /usr/local
RUN unzip /tmp/android-studio-ide*

 
# set up ownership
RUN chown -R user.user /usr/local/

# switch to user and run program
USER user
ENV HOME /home/user
WORKDIR /home/user
ENV JAVA_HOME /usr/java/latest

CMD    /usr/bin/bash /home/user/menu.sh
