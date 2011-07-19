maintainer       "Isotope 11"
maintainer_email "info@isotope11.com"
license          "Apache 2.0"
description      "Installs/Configures a2fansites"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1"

depends "passenger_apache2::mod_rails"
depends "postgresql::server"
depends "postgresql::client"
