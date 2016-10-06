Rails.application.routes.draw do

  require 'sidekiq/web'
  require 'sidekiq/api'

  mount Sidekiq::Web => '/sidekiq'

end
