MotorCarExport::Application.routes.draw do
  root to: 'pages#show', slug: 'home'

  resources :vehicles do
    get '/inventory', on: :collection, to: 'vehicles#inventory', as: 'inventory'
    resources :photos
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

  resources :requests
  resources :users
  resources :user_sessions

  # Create these resources, and add custom restore option
  [:titles, :pages, :warranties, :drivables, :body_types, :disclosures].each do |resource|
    resources resource do
      put '/restore', on: :member, to: :restore, as: 'restore'
    end
  end
  #resources :disclosures do
  #  put '/restore', on: :member, to: :restore, as: 'restore'
  #end
  #resources :pages do
  #  put '/restore', on: :member, to: :restore, as: 'restore'
  #end
  #resources :warranties do
  #  put '/restore', on: :member, to: :restore, as: 'restore'
  #end
	get '/assets/vehicles/ebay-:hash.css', to: redirect('/assets/vehicles/ebay.css')
	get '/favicon.ico', to: redirect('http://motor-car-export.s3.amazonaws.com/favicon.ico')
  get '/login', to: 'user_sessions#new'
  post '/login', to: 'user_sessions#create'
  get '/logout', to: 'user_sessions#destroy'

  # Special Pages
  get '/members', to: 'pages#show', slug: 'members'

  # CMS pages
  # Should be last rule because it's a catch-all
  match '/:slug', to: 'pages#show', as: 'slug'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
