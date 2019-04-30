env = Rails.env.to_sym
conf = Rails.application.credentials.redis[env]

redis = {
  url: "redis://#{conf[:host]}:#{conf[:port]}",
  namespace: conf[:namespace]
}
redis[:password] = conf[:password] if conf[:password]

Sidekiq.configure_server do |config|
  config.redis = redis
end

Sidekiq.configure_client do |config|
  config.redis = redis
end
