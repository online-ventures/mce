MotorCarExport::Application.routes.draw do
  ensure_on production: '', staging: 'staging'

  root to: 'pages#show', slug: 'home'

  resources :vehicles do
    get '/inventory', on: :collection, to: 'vehicles#inventory', as: 'inventory'
    resources :photos do
      delete '/', on: :collection, to: 'photos#destroy_all', as: 'destroy_all'
    end
    resources :features
    get '/:name', on: :member, to: 'vehicles#show', as: 'seo', name: /\d{4}\-[^\.]*/
    put '/restore', on: :member, to: 'vehicles#restore', as: 'restore'
  end

  resources :subscribers do
    get '/confirm/:code', on: :member, to: 'subscribers#confirm', as: 'confirm'
    get '/cancel/:code', on: :member, to: 'subscribers#cancel', as: 'cancel'
    get '/tell-us-more', on: :member, to: 'subscribers#add_to', as: 'add_to'
  end

  resources :features do
    get '', on: :collection, to: 'features#manage'
    post '/to/:to', on: :member, to: 'features#move'
  end

  resources :requests, :users, :user_sessions

  # Create these resources, and add custom restore option
  [:titles, :pages, :warranties, :drivables, :body_types, :disclosures].each do |resource|
    resources resource do
      put '/restore', on: :member, to: :restore, as: 'restore'
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
  match '/:slug', to: 'pages#show', as: 'slug'
end
