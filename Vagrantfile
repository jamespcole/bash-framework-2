Vagrant.configure("2") do |config|

	# Specify the base box
    config.vm.box = "boxcutter/ubuntu1604"
    config.vm.synced_folder ".", "/home/vagrant/bf2"

    # VM specific configs
    config.vm.provider "virtualbox" do |v|
    	v.name = "bf2"
    	v.customize ["modifyvm", :id, "--memory", "1024"]
    end

    config.vm.provision "shell", inline: "/home/vagrant/bf2/setup.sh", privileged: false
end
