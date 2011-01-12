action :install do
#  required_recipes = {
#    "passenger_apache2" => [ "rvm_passenger" ] 
#  }
#  raise StandardError.new("Unknown web_stack #{new_resource.name}") unless required_recipes.key?(new_resource.name)
#
  # create the gemset
  rvm_gemset new_resource.ruby do
    action :create
  end

  #required_recipes[new_resource.name].each do |recipe|
  #  # include the recipes
  #  run_context.include_recipe recipe
  #end
  #case new_resource.name
  #end
  run_context.include_recipe "rvm_passenger"
end
