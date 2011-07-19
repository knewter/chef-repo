# Cookbook Name:: placemeta
# Recipe:: default
#
# Copyright 2011, Josh Adams
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# TODO: bootstrap ruby 1.9.2

include_recipe "passenger_apache2::mod_rails"
include_recipe "imagemagick"

gem_package "bundler"

group "deployer"

user "deployer" do
  comment "Deployer User"
  uid "1000"
  gid "deployer"
  home "/home/deployer"
  shell "/bin/bash"
  supports :manage_home => true
end

directory "/home/deployer/placemeta/shared" do
  owner "deployer"
  group "deployer"
  recursive true
end

deploy_revision "/home/deployer/placemeta" do
  repo "git@github.com:knewter/placemeta"
  revision "master" # or "HEAD" or "TAG_for_1.0" or (subversion) "1234"
  user "deployer"
  create_dirs_before_symlink %w{tmp public config}
  #before_migrate { `cd /home/deployer/placemeta/shared/cached-copy && bundle install --deployment` }
  before_migrate do
    bash "migrate_this" do
      code <<-EOF
cd #{release_path}
bundle install --deployment
EOF
    end
  end
  migrate true
  #migration_command "cd /home/deployer/placemeta/shared/cached-copy && bundle exec rake db:migrate"
  migration_command "bundle exec rake db:migrate"
  environment "RAILS_ENV" => "production"
  #shallow_clone true
  action :deploy # or :rollback
  restart_command "touch tmp/restart.txt"

  #git_ssh_wrapper "wrap-ssh4git.sh"
end

web_app "placemeta" do
  docroot "/home/deployer/placemeta/current/public"
  server_name "www.placemeta.com"
  server_alias "placemeta.com"
  rails_env "production"
end
