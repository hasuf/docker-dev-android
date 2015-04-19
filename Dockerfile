FROM fedora

# Install the appropriate software
#RUN yum -y update && yum clean all
#RUN yum -y install firefox \
#xorg-x11-twm tigervnc-server \
#xterm xorg-x11-font \
#xulrunner-26.0-2.fc20.x86_64 \
#dejavu-sans-fonts \
#dejavu-serif-fonts \
#xdotool && yum clean all
RUN yum -y install yum-plugin-fastestmirror
RUN yum -y install openssh-server xorg-x11-xauth
#RUN yum -y install firefox tigervnc-server
RUN yum -y install firefox 
#RUN yum -y groupinstall "LXDE Desktop"

# Add the xstartup file into the image and set the default password.
RUN useradd -ms /bin/bash user
#RUN mkdir /home/user/.vnc
#ADD ./xstartup /home/user/.vnc/
ADD ./sshkey_id_rsa /home/user/.ssh/id_rsa
ADD ./sshkey_id_rsa.pub /home/user/.ssh/authorized_keys

ADD ./sshkey_id_rsa /root/.ssh/id_rsa
ADD ./sshkey_id_rsa.pub /root/.ssh/authorized_keys


ADD ./ssh_host_ecdsa_key /etc/ssh/
ADD ./ssh_host_ecdsa_key.pub /etc/ssh/

ADD ./ssh_host_rsa_key /etc/ssh/
ADD ./ssh_host_rsa_key.pub /etc/ssh/

ADD ./ssh_host_ed25519_key /etc/ssh/
ADD ./ssh_host_ed25519_key.pub /etc/ssh/

RUN cat /etc/ssh/sshd_config

#RUN chmod -v +x /home/user/.vnc/xstartup
#RUN echo 123456 | vncpasswd -f > /home/user/.vnc/passwd
#RUN chmod -v 600 /home/user/.vnc/passwd
RUN chown -R user.user /home/user
RUN echo "Port 4444" >> /etc/ssh/sshd_config
RUN echo "X11Forwarding yes" >> /etc/ssh/sshd_config
RUN echo "Ciphers arcfour" >> /etc/ssh/sshd_config
RUN env|grep DISPLAY

#RUN sed -i '/\/etc\/X11\/xinit\/xinitrc-common/a [ -x /usr/bin/firefox ] && /usr/bin/firefox &' /etc/X11/xinit/xinitrc

EXPOSE 4444
#CMD    ["/usr/sbin/sshd", "-D" ]
USER user
ENV HOME /home/user
CMD    ["/usr/bin/firefox"]
