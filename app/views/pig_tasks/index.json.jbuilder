json.array!(@pig_tasks) do |pig_task|
  json.extract! pig_task, :id, :command
  json.url pig_task_url(pig_task, format: :json)
end
