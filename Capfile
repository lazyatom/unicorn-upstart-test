require 'recap/recipes/ruby'

set :application, 'unicorn-upstart-test'
set :repository, 'git://github.com/lazyatom/unicorn-upstart-test'

server '128.83.89.249', :app

# We'll use this custom event to trigger Unicorn reload
set :foreman_restart_event, "#{application}-restart"
# This job will listen for that event, and send SIGHUP the saved unicorn PID
set :foreman_restart_job, "#{foreman_restart_event}.conf"

namespace :foreman do
  namespace :export do
    desc "Create an Upstart job on the server to gracefully reload Unicorn"
    task :restart_job do
      restart_job = <<-EOS
start on #{foreman_restart_event}

script
  kill -HUP `cat #{deploy_to}/tmp/unicorn.pid`
end script
EOS
      put_as_app restart_job, "#{foreman_tmp_location}/#{foreman_restart_job}"
      sudo "cp #{foreman_tmp_location}/#{foreman_restart_job} #{foreman_export_location}"
    end

    # Ensure that the restart job is exported
    after 'foreman:export:if_changed', 'foreman:export:restart_job'
  end

  desc "Restart unicorn"
  task :restart do
    sudo "initctl emit #{foreman_restart_job}"
  end
end
