VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.hostname = 'clastic-dev'

  config.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true
  config.vm.network "private_network", ip: "33.33.33.100"

  config.vm.synced_folder ".", "/vagrant", type: "nfs"

  config.vm.provision :shell, :inline => "apt-get update"
  config.vm.provision "shell", inline: "puppet module install nodes-php"

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = 'puppet/modules'
  end

  config.vm.provision "shell", inline: "sudo apt-get clean"
end
