Dockerized Android Development Environment with Vagrant
=======================================================

Introduction
------------

These Docker and Vagrant (and supporting) files allows one to create a fully self-contained Android development environment. All the necessary software is downloaded and configured, making set-up easy.

Within this (Fedora 21) environment, the following features are available:

* Android Studio (1.1.0), with IdeaVIM plugin (hey, we've all got our editing biases!)
* Java downloaded and installed (Currently, Oracle Java 8u45)
* Accelerated Android Emulator (assuming VTX is available)
* Access to connected Android devices through the container
* All the necessary Fedora packages for the above
* All GUIs are run leveraging your local X server (no VNC'ing or ssh'ing to run programs like Android Studio).

The environment uses [Docker volumes](https://docs.docker.com/reference/builder/#volume) to map a directory that will be used as the dev user's home directory. It's in this directory where you can store persistent data (Android studio settings, code, etc).


Getting Up and Running
----------------------
1. Download and install [Vagrant](http://www.vagrantup.com).
1. Download and install [Docker](http://www.docker.com). (Make sure the docker service is running)
1. Retrieve the dev-android files.

        git clone https://hasuf@bitbucket.org/trumpa/dev-android.git

1. There are some things you might want to consider before launching Vagrant:
    1. **User and Group ID.** To make things easy on you and allow you to interoperate with files both inside and outside the container, you might want to edit the id's of the user and its group. ie, in the Dockerfile, edit the lines:
         
                RUN groupadd -g 1000 devuser        
                RUN useradd -g 1000 -u 600  -ms /bin/bash devuser
        
          so that the id's for the group and user match your own. You can determine your own user and group id by running the following commands in your regular environment:

                $ # determine my user id
                $ id -u
                681
                $ # determine my group id
                $ id -g
                1048
        
        Replace the 1000 and 600 with your own group id and user id, respectively. eg (from the above example):

                RUN groupadd -g 1048 devuser        
                RUN useradd -g 1048 -u 681  -ms /bin/bash devuser
        
        Once this is done, anytime you edit files in the container, you'll by default have the same ownership as your normal user outside the container.

      1. **DEVDIR.** Determine where, on your filesystem, you want to designate the dev user's home directory. eg, if you may want to designate `/home/myaccount/work` as your android development path. **NOTE that the path must already exist.**

   1. Launch Vagrant. The Vagrantfile requires setting that the DEVDIR be passed as an environment variable. If DEVDIR is not set, you'll get an error.

       You can do this:
       
                sudo DEVDIR=/home/myaccount/work vagrant up
            
       Or, you can set up the environment variable in your .bashrc file, for instance:
        
                # set up DEVDIR for dev-android setup
                export DEVDIR=/home/myaccount/work
                
       And then your can just run the following:
       
                vagrant up
   

Quick User Guide
----------------
When you fire up the Docker environment, and after all the software is downloaded, installed, and configured (it will take a while to download and configure everything), you're presented with a simple launcher that allows you to either start up Android Studio, launch a terminal window (from within the container's context), or exit the container. 

Exiting will cause the Docker session to end (therefore, it's a good idea to make sure you don't have any processes running like Android Studio where you might lose some data).

Limitations
-----------

References
----------    
 