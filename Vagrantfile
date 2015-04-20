# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_DEFAULT_PROVIDER'] = 'docker'

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|

  # make sure the dev has defined DEVDIR
  if !ENV["DEVDIR"]
    raise(Exception, "undefined DEVDIR environment variable")  
  end



  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"
  config.vm.synced_folder  ENV["DEVDIR"], "/home/user/"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  config.vm.provider "docker" do |d|
    # look for Dockerfile in same dir as Vagrantfile
    d.build_dir = "."
    d.remains_running = true
    # for running X gui's. Must run xhost+ on host
    d.env = {"DISPLAY" => ENV["DISPLAY"]}
    d.volumes = ["/tmp/.X11-unix:/tmp/.X11-unix"]
    # for using kvm emulation
    d.privileged = true
  end

end
