# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Disable automatic box update checking.
  config.vm.box_check_update = false

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = 'ubuntu/xenial64'

  # Forward ports.
  config.vm.network 'forwarded_port', guest: 5432, host: 5432 # Postgres port.

  # Customize the amount of memory on the VM.
  config.vm.provider 'virtualbox' do |vb|
    vb.memory = 1024
  end

  # Install required software.
  config.vm.provision 'shell', path: 'bootstrap.sh', privileged: false,
                               keep_color: true
end
