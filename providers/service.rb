require 'chef/mixin/command'
require 'chef/mixin/language'
include Chef::Mixin::Command

action :load do
  execute "#{@god_bin} load #{@config_path}" do
    only_if @god_running
  end
end

def load_current_resource
  @service = Chef::Resource::GodService.new(new_resource.service_name)
  @config_path = "#{node['god']['config_dir']}/conf.d/#{new_resource.service_name}.god"
  @god_bin = "#{node['rvm']['root_path']}/bin/god_god"

  @god_running = false
  begin
    if run_command_with_systems_locale(:command => "#{@god_bin} status") == 0
      @god_running = true
    end
  rescue Chef::Exceptions::Exec
  end
end
