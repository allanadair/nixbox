Vagrant.configure("2") do |config|
  config.vm.box = "nixos-17.09-workstation-virtualbox.box"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  config.vm.network "forwarded_port", guest: 6080, host: 6080
  config.vm.network "forwarded_port", guest: 6443, host: 6443

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "~", "/vagrant"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  config.vm.provider "virtualbox" do |vb|
    vb.cpus = "4"
    vb.memory = "8192"
    vb.customize ["modifyvm", :id, "--vram", "128"]
	vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.gui = true
    vb.name = "workstation"
  end

  config.vm.provision :file do |file|
      file.source = ".emacs.d/init.el"
      file.destination = ".emacs.d/init.el"
  end

  config.vm.provision :file do |file|
      file.source = ".emacs.d/lisp/bind-key.el"
      file.destination = ".emacs.d/lisp/bind-key.el"
  end

  config.vm.provision :file do |file|
      file.source = ".emacs.d/lisp/use-package.el"
      file.destination = ".emacs.d/lisp/use-package.el"
  end
  
end
