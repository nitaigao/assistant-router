require 'mina/git'

set :domain, '192.168.1.104'
set :deploy_to, '/home/pi/house/router'
set :repository, 'https://github.com/nkostelnik/assistant-router.git'
set :node_version, 'node-v0.10.24-linux-arm-armv6j-vfp-hard'
set :shared_paths, ['node_modules', 'log']
set :user, 'pi'

task :environment do
  queue "PATH=$PATH:/home/pi/node/bin"
end

task :system => :environment do
  queue! %[wget https://gist.github.com/raw/3245130/v0.10.24/#{node_version}.tar.gz]
  queue! %[tar zxvf #{node_version}.tar.gz]
  queue! %[rm #{node_version}.tar.gz]
  queue! %[ln -s #{node_version} node]
  queue! %[npm install -g forever]
end

task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/node_modules"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/node_modules"]
end

task :npm => :environment do
  queue "cd #{deploy_to}/current && npm install"
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'npm'

    to :launch do
      # queue "forever stop #{deploy_to}/current/index.js"
      queue "forever start #{deploy_to}/current/index.js"
    end
  end
end
