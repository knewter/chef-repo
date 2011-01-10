actions :deploy

attribute :name,              :kind_of => String, :required => true
attribute :ruby,              :kind_of => String, :required => true
attribute :rails_env,         :kind_of => [ Symbol, String ], :required => true
attribute :repo,              :kind_of => String, :required => true
attribute :revision,          :kind_of => String
attribute :user,              :kind_of => String
attribute :group,             :kind_of => String
attribute :enable_submodules, :kind_of => [ TrueClass, FalseClass ]
attribute :migrate,           :kind_of => [ TrueClass, FalseClass ]
attribute :migration_command, :kind_of => String
attribute :environment,       :kind_of => Hash, :default => { 'RAILS_ENV' => "#{rails_env}" }
attribute :bundle_command,    :kind_of => String, :default => 'bundle install'

