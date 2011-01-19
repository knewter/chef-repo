case node.platform
when "redhat", "centos", "fedora", "suse"
  package "libpq-dev"
when "debian", "ubuntu"
  package "libpq-dev"
end
