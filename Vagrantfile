Vagrant.configure("2") do |config|
  config.vm.box = "nixos-18.03-workstation-virtualbox.box"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "~", "/vagrant"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  config.vm.provider "virtualbox" do |vb|
    vb.cpus = "2"
    vb.memory = "8192"
    vb.customize ["modifyvm", :id, "--vram", "128"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.gui = true
    vb.name = "nixos-workstation-18.03"
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
