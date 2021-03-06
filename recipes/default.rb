ruby = node['god']['ruby'] || node['rvm']['default_ruby']
gemset = node['god']['gemset'] || 'god'
ruby_string = "#{ruby}@#{gemset}"
config_dir = node['god']['config_dir']
service_config_dir = node['god']['service_config_dir']
god_bin = "#{node['rvm']['root_path']}/bin/run_god"

rvm_gemset gemset do
  ruby_string ruby
end

rvm_gem "god" do
  ruby_string ruby_string
end

# Generates a run_god script that invokes god in the appropriate
# ruby and rubygem, this is part of the rvm cookbook
rvm_wrapper "run" do
  ruby_string ruby_string
  binary "god"
end

[config_dir, service_config_dir].each do |directory|
  directory directory do
    recursive true
    owner "root"
    group "root"
    mode 0755
  end
end

template "#{config_dir}/conf.god" do
  source "conf.god.erb"
  owner "root"
  group "root"
  mode 0755
  variables(
    :config_paths => "#{service_config_dir}/*.god",
  )
end

template "/etc/init.d/god" do
  source "god_init.erb"
  owner "root"
  group "root"
  mode 0755
  variables(
    :god_config_path => "#{config_dir}/conf.god",
    :god_bin => god_bin
  )
end

service "god" do
  supports :start => true, :stop => true, :restart => true, :status => true
  action [:enable, :start]
end

cron "restart god" do
  minute "0"
  hour "1"
  weekday "0"
  command "#{god_bin} quit; sleep 1; killall god; sleep 1; killall -9 god; sleep 1; /etc/init.d/god start"
end
