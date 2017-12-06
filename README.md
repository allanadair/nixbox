NixOS boxes for Vagrant
=======================
[NixOS](http://nixos.org) is a linux distribution based on a purely functional
package manager. This project builds a [vagrant](http://vagrantup.com) .box
image.

Building the image
------------------
First install [packer](http://packer.io) and
[virtualbox](https://www.virtualbox.org/)

Then:
```
packer build nixos-17.09-workstation.json
vagrant up
```

License
-------
Copyright 2015 under the MIT
