action :deploy do
  home_path = ::File.join(new_resource.base_path, new_resource.name)

  # create user and group
  # FIXME: need to edit path from within chef env so it can find usermod
  user new_resource.name do
    comment "#{new_resource.name} Rails App User"
    home home_path
    shell "/bin/bash"
    supports :manage_home => true
  end

  group "rvm" do
    members new_resource.name
    append true
  end

  # setup repo ssh key
  if new_resource.repo_ssh_key
    key_file_name = ::File.split(new_resource.repo_ssh_key)[-1]
    ssh_dir_path = ::File.join(home_path, '.ssh')
    ssh_key_path = ::File.join(ssh_dir_path, 'id_rsa')
    # create .ssh dir in home dir
    directory ssh_dir_path do
      owner new_resource.user
      group new_resource.user
      mode "0700"  
      not_if %Q{ test -d #{ssh_dir_path} }
    end

    # if the temp and perm keys don't exist we have error
    # FIXME: proper error class
    unless ::File.exists?(ssh_key_path) or ::File.exists?(new_resource.repo_ssh_key)
      raise StandardError.new("Your temp ssh key file is not in place at: #{new_resource.repo_ssh_key}")
    end
    # cp the key file into place
    bash "cp #{new_resource.repo_ssh_key} #{ssh_key_path}" do
      code %Q{ cp #{new_resource.repo_ssh_key} #{ssh_key_path} }
      not_if %Q{ test -f #{ssh_key_path} }
    end
    file ssh_key_path do
      owner new_resource.user
      mode "0600"
    end
    file "#{ssh_dir_path}/config" do
      owner new_resource.user
      content %Q{
          Host github.com
            User git
            IdentityFile #{ssh_key_path} 
      }
    end
    bash "rm #{new_resource.repo_ssh_key}" do
      code %Q{ rm #{new_resource.repo_ssh_key} }
      only_if %Q{ test -f #{new_resource.repo_ssh_key} }
    end
  end

  # setup the web_stack
  rvm_passenger_apache2 "ree@potsdam" do
    action :install
  end

  # setup environment attr with proper RAILS_ENV
  base_env = { 'RAILS_ENV' => new_resource.rails_env }
  base_env.merge!(new_resource.environment)

  # use chef deploy resource with existing git repo
  deploy_path = ::File.join(home_path, "#{new_resource.name}_app")
  directory ::File.join(deploy_path, 'shared') do
    action :create
    recursive true
    owner new_resource.user
    group new_resource.group
  end

  deploy_branch deploy_path do
    repo new_resource.repo
    revision new_resource.revision
    user new_resource.user
    enable_submodules true
    migrate false
    migration_command "rake db:migrate"
    environment base_env
    shallow_clone true
    action :force_deploy
    #restart_command "touch tmp/restart.txt"
    ruby_name = new_resource.ruby
    before_migrate do
      rvm_bundle ::File.join(deploy_path, 'current') do
        ruby ruby_name
        action :install
      end
    end
  end
  directory deploy_path do
    recursive true
    owner new_resource.user
    group new_resource.user   
  end

end
