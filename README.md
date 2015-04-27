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

The environment uses [Docker volumes](https://docs.docker.com/reference/builder/#volume) to map a directory that will be used as the dev user's home directory. It's in this directory where you can store persistent data (Android studio settings, code, etc).


Getting Up and Running
----------------------
1. Download and install [Vagrant](http://www.vagrantup.com).
1. Download and install [Docker](http://www.docker.com).
1. Retrieve the dev-android files.

        git clone https://hasuf@bitbucket.org/trumpa/dev-android.git

1. There are some things you might want to consider before launching Vagrant:
    1. **User and Group ID.** To make things easy on you and allow you to interoperate with files both inside and outside the container, you might want to edit the id's of the user and its group. ie, in the Dockerfile, edit the lines:
         
                RUN groupadd -g 1000 user        
                RUN useradd -g 1000 -u 600  -ms /bin/bash user
        
          so that the id's for the group and user match your own. You can figure your own user and group id by running the following commands in your normal environment:

                $ # determine my user id
                $ id -u
                681
                $ # determine my group id
                $ id -g
                1048
        
        Replace the 1000 and 600 with your own group id and user id, respectively. eg (from the above example):

                RUN groupadd -g 1048 user        
                RUN useradd -g 1048 -u 681  -ms /bin/bash user
        
        Once this is done, anytime you edit files in the container, you'll by default have the same ownership as your normal user outside the container.

      1. **DEVDIR.** Determine where, on your filesystem, you want to designate the dev user's home directory. eg, if you have a path 

    1. Launch Vagrant. Make sure you set up the env variable for DEVDIR, otherwise you'll get an error.

        you can do this:
       
                dsafdsad
            
        Or, you can set up the envri
        
   

Quick User Guide
----------------
When you fire up the Docker environment and after all the software is downloaded, installed, and configured, you're presented with a simple launcher that allows you to either start up Android Studio, launch a terminal window (from within the container's context), or exit the container. 

Exiting will cause the Docker session to end (therefore, it's a good idea to make sure you don't have any processes running like Android Studio where you might lose some data).

Limitations
-----------

References
----------    
 