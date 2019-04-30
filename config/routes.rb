require 'sidekiq/web'
require 'admin_constraint'

Rails.application.routes.draw do
  # Sidekiq UI
  mount Sidekiq::Web => '/sidekiq', :constraints => AdminConstraint.new

  root to: 'pages#show', slug: 'home'

  resources :vehicles do
    get '/inventory', on: :collection, to: 'vehicles#inventory', as: 'inventory'
    resources :photos do
      delete '/', on: :collection, to: 'photos#destroy_all', as: 'destroy_all'
    end
    resources :features
    get '/:name', on: :member, to: 'vehicles#show', as: 'seo', name: /\d{4}\-[^\.]*/
    patch '/restore', on: :member, to: 'vehicles#restore', as: 'restore'
    resources :purchases, except: [:show, :index]
    resources :inquiries, only: [:new, :create]
  end

  resources :subscribers do
    member do
      get 'set_subscription_plan/:plan', to: 'subscribers#set_subscription_plan', as: 'change_plan'
      get 'subscribe', to: 'subscribers#subscribe', as: 'subscribe'
      get 'cancel', to: 'subscribers#cancel', as: 'cancel'
    end
    collection do
      get :search
    end
  end

  resources :features do
    get '', on: :collection, to: 'features#manage'
    post '/to/:to', on: :member, to: 'features#move'
  end

  resources :requests, :users, :user_sessions

  # Create these resources, and add custom restore option
  [:titles, :pages, :warranties, :drivables, :body_types, :disclosures].each do |resource|
    resources resource do
      patch '/restore', on: :member, action: :restore, as: 'restore'
    end
  end

  # HACKERY!
  get '/cpanel', to: redirect('http://old.motorcarexport.com/cpanel')
  get '/carPictures/*path', to: redirect {|params, request| "http://old.motorcarexport.com/carPictures/#{params[:path]}.jpg" }
  get '/repairables/vehicleList.php', to: redirect('/vehicles/inventory')
  get '/contactUs/:anything', to: redirect('/contact')
  get '/images/vehicle/mainPicFrame.gif', to: redirect('http://old.motorcarexport.com/images/vehicle/mainPicFrame.gif')
  get '/assets/vehicles/ebay-:hash.css', to: redirect('/assets/vehicles/ebay.css')
  get '/favicon.ico', to: redirect('http://motor-car-export.s3.amazonaws.com/favicon.ico')

  # Login Stuff
  get '/login', to: 'user_sessions#new'
  post '/login', to: 'user_sessions#create'
  get '/logout', to: 'user_sessions#destroy'

  # Special Pages
  get '/members', to: 'pages#show', slug: 'members'

  # CMS pages
  # Should be last rule because it's a catch-all
  get '/:slug', to: 'pages#show', as: 'slug'
end
