#
# Cookbook Name:: xrono
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
include_recipe "rvm"
include_recipe "mysql"

rvm_rails_nginx_unicorn "examplexrono.com" do
  action :deploy
  user "xrono"
  group "xrono"
  ruby "1.9.2@xrono"
  rails_env :production
  repo "http://github.com/isotope11/xrono.git"
  repo_ssh_key "/tmp/xrono.priv" # used once and deleted
  database_yml "/tmp/xrono.yml"  # used once and deleted
  revision "master"
end
