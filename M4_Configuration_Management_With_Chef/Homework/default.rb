docker_service 'default' do
    group 'dockerroot'
    action [:create, :start]
end

docker_image 'vladimirr11/bgapp-web' do
    tag 'latest'
    action :pull
end

docker_image 'vladimirr11/bgapp-db' do
    tag 'latest'
    action :pull
end

docker_network 'bgapp-net' do
    action :create
end

docker_container 'web' do
    repo 'vladimirr11/bgapp-web'
    tag 'latest'
    port '80:80'
    volumes '/home/vagrant/m4_homework/web:/var/www/html'
    network_mode 'bgapp-net'
    action :run
end

docker_container 'db' do
    repo 'vladimirr11/bgapp-db'
    tag 'latest'
    env 'MYSQL_ROOT_PASSWORD=12345'
    network_mode 'bgapp-net'
    action :run
end
