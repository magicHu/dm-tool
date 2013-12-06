json.array!(@jobs) do |job|
  json.extract! job, :id, :name, :desc, :path, :hbase
  json.url job_url(job, format: :json)
end
