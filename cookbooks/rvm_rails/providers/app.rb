action :deploy do
  run_context.include_recipe "rvm"
  home_path = ::File.join(new_resource.base_path, new_resource.name)

  # create user and group
  # TODO: need to edit path from within chef env so it can find usermod
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
    ssh_key_path = File.join(home_path, new_resource.name, '.ssh', new_resource.repo_ssh_key)
    cookbook_file ssh_key_path do
      source new_resource.repo_ssh_key
    end
  end
  # setup the web_stack
  rvm_rails_web_stack new_resource.web_stack do
    action :install
  end
  # setup environment attr with proper RAILS_ENV
  # use chef deploy resource with existing git repo
  # bundle install as before_deploy hook
end
