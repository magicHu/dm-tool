# unicorn_rails -c /home/magic/workspace/dm-tool/config/unicorn.rb -E production -D

rails_env = ENV['RAILS_ENV'] || 'production'

worker_processes 2

#project_path = "/home/magic/workspace/dm-tool"
#stderr_path "#{project_path}/log/unicorn.log"
#stdout_path "#{project_path}/log/unicorn.log"

listen 3000

timeout 30
