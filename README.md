## Description

Installs [God](https://github.com/mojombo/god) under RVM.

## Requirements

### Cookbooks

* [RVM](https://github.com/fnichol/chef-rvm)

## Usage

To install via chef:

```ruby
include_recipe "god"
```

## Attributes

### config_dir

The path to the god configuration.

The default is `"/etc/god"`

### service_config_dir

The path to the directory where all your service configurations will live.
God will load `*.god` in this directory.

The default is `"/etc/god/conf.d"`

### ruby

The ruby that God should be installed under.

The default is `node['rvm']['default_ruby']`

### gemset

The gemset that God should be installed to.

The default is `"god"`

## Resources and Providers

### god_service

Only has a `load` action that will load the config into a running god process.
This should be used as a notifiy on the `template` or `cookbook_file` that puts the
config for that service in place. For some reason it only appears to work if `:immediately`
is specified.

#### Example

```ruby
god_service "delayed_job"

template "#{node[:god][:service_config_dir]}/delayed_job.god" do
  source "delayed_job_god.erb"
  owner node[:www][:user]
  mode "0600"
  notifies :load, "god_service[delayed_job]", :immediately
end
```
