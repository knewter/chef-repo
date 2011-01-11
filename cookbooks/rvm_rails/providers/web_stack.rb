action :install do
  required_recipes = {
    "apache2_passenger" => %w{ apache2 }
  }
  required_recipes[new_resource.name].each do |recipe|
    run_context.include_recipe recipe
  end
  #case new_resource.name
  #  when "apache2_passenger"
  #end
end
