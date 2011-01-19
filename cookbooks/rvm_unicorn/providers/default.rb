action :deploy do
  this_resource = new_resource
  rvm_gem "unicorn" do
    ruby this_resource.ruby
  end

  config_dir = File.dirname(new_resource.name)

  directory config_dir do
    recursive true
    action :create
  end

  tvars = new_resource.clone
  this_resource.listen.each do |port, options|
    oarray = Array.new
    options.each do |k, v|
      oarray << ":#{k} => #{v}"
    end
    tvars[:listen][port] = oarray.join(", ")
  end

  template new_resource.name do
    source "unicorn.rb.erb"
    cookbook "rvm_unicorn"
    mode "0644"
    owner this_resource.owner if this_resource.owner
    group this_resource.group if this_resource.group
    mode this_resource.mode   if this_resource.mode
    variables this_resource
    notifies *this_resource.notifies if this_resource.notifies
  end

end
