action :deploy do
  this_resource = new_resource
  rvm_rails new_resource.name do
    action :deploy
    user this_resource.user if this_resource.user
    group this_resource.group if this_resource.group
    ruby this_resource.ruby if this_resource.ruby
    rails_env this_resource.rails_env if this_resource.rails_env
    repo this_resource.repo if this_resource.repo
    revision this_resource.revision if this_resource.revision
    repo_ssh_key this_resource.repo_ssh_key if this_resource.repo_ssh_key
    base_path this_resource.base_path if this_resource.base_path
    environment this_resource.environment if this_resource.environment
    enable_submodules this_resource.enable_submodules if this_resource.enable_submodules
    migrate this_resource.migrate if this_resource.migrate
    migration_command this_resource.migration_command if this_resource.migration_command
  end
end
