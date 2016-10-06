redis_conn = proc {
  Redis.new(:host => ENV['REDIS_LOCAL_HOST'], :port => ENV['REDIS_LOCAL_PORT'], :db => ENV['REDIS_LOCAL_SIDEKIQ_DB'])
}
Sidekiq.configure_client do |config|
  config.redis = ConnectionPool.new(size: 2, &redis_conn)
end
Sidekiq.configure_server do |config|
  config.redis = ConnectionPool.new(size: 8, &redis_conn)
end