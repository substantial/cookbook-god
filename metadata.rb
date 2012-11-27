maintainer       "Substantial"
maintainer_email "allen@substantial.com"
license          "Apache 2.0"
description      "Installs/Configures god"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.2.0"

recipe "god", "Installs god"

%w{fedora centos rhel ubuntu debian scientific}.each do |os|
  supports os
end
