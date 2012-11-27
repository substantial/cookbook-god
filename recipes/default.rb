ruby = node['god']['ruby'] || node['rvm']['default_ruby']
gemset = node['god']['gemset'] || 'god'
ruby_string = "#{ruby}@#{gemset}"
config_path = node['god']['config_path']

rvm_gemset gemset do
  ruby_string ruby
end

rvm_gem "god" do
  ruby_string ruby_string
end

rvm_wrapper "god" do
  ruby_string ruby_string
  binary "god"
end

[config_path, "#{config_path}/conf.d"].each do |directory|
  directory directory do
    recursive true
    owner "root"
    group "root"
    mode 0755
  end
end

template "#{config_path}/conf.god" do
  source "conf.god.erb"
  owner "root"
  group "root"
  mode 0755
  variables(
    :config_paths => "#{config_path}/conf.d/*.god",
  )
end

template "/etc/init.d/god" do
  source "god_init.erb"
  owner "root"
  group "root"
  mode 0755
  variables(
    :god_config_path => "#{config_path}/conf.god",
    :god_path => "#{node['rvm']['root_path']}/bin/god_god"
  )
end

service "god" do
  supports :start => true, :stop => true, :restart => true, :status => true
  action [:enable, :start]
end
