#
# Cookbook Name:: tabrr
# Recipe:: default
#
# Copyright 2011, Bram Swenson
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
include_recipe "rvm"
include_recipe "postgresql::server"
include_recipe "postgresql::development"
package "zip" # johnson dep
rvm_rails_nginx_unicorn "tabrr" do
  action :deploy
  user "tabrr"
  group "tabrr"
  ruby "1.8.7@tabrr"
  rails_env :production
  repo "git@github.com:bramswenson/hiredgun.git"
  repo_ssh_key "/tmp/github.priv" # used once and deleted
  revision "master"
  # any other Chef::Resource::Deploy options
end

