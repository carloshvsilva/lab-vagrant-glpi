list = {
  "server-glpi" => {:type => "server", :so => "ubuntu/jammy64", :ip => "192.168.100.140", :memory => "1024", :cpu => "2", :script => "scripts/server.sh"},
  "host01" => {:type => "host", :so => "centos/7", :ip => "192.168.100.141", :memory => "512", :cpu => "1", :script => "scripts/client-centos7.sh"},
  "host02" => {:type => "host", :so => "centos/8", :ip => "192.168.100.142", :memory => "512", :cpu => "2", :script => "scripts/client-centos8.sh"},
  "host03" => {:type => "host", :so => "generic/debian9", :ip => "192.168.100.143", :memory => "512", :cpu => "2", :script => "scripts/debian.sh"}
  #"host04" => {:type => "host", :so => "centos/8", :ip => "192.168.100.144", :memory => "512", :cpu => "2", :script => "scripts/client-centos8.sh"},
  #"host05" => {:type => "host", :so => "centos/7", :ip => "192.168.100.145", :memory => "512", :cpu => "1", :script => "scripts/client-centos7.sh"},
  #"host06" => {:type => "host", :so => "centos/7", :ip => "192.168.100.146", :memory => "512", :cpu => "1", :script => "scripts/client-centos7.sh"},
  #"host07" => {:type => "host", :so => "centos/7", :ip => "192.168.100.147", :memory => "512", :cpu => "1", :script => "scripts/client-centos7.sh"},
  #"host08" => {:type => "host", :so => "centos/8", :ip => "192.168.100.148", :memory => "512", :cpu => "2", :script => "scripts/client-centos8.sh"}
}

setInstall = "server"

Vagrant.configure("2") do |config|
  list.each_with_index do |(hostname, info), index|
    if info[:type] == setInstall
      config.vm.define hostname do |machine|
        machine.vm.provider :virtualbox do |vb|
          vb.name = hostname
          vb.customize ["modifyvm", :id, "--memory", info[:memory]]
          vb.customize ["modifyvm", :id, "--cpus", info[:cpu]] 
        end 
        machine.vm.box = info[:so]
        machine.vm.hostname = hostname
        if info[:type] == "server"
          machine.vm.network "forwarded_port", guest: 80, host: 80
        end
        machine.vm.network "public_network", ip: info[:ip]
        machine.vm.provision "shell",
          path: info[:script]
      end
    end
  end
end
