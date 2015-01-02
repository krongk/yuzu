RainCms::Application.routes.draw do
  
  resources :districts
  resources :cities
  resources :regions
  resources :notifications
  resources :pictures
  
  resources :products
  resources :jobs
  
  resources :resumes do
    member do
      get 'preview'
    end
  end
  resources :shops do
    member do 
      get 'm'
    end
  end


  resources :comments
  #routes for admin ==============================
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users do 
    resources :jobs
    resources :products
  end

  mount Ckeditor::Engine => '/ckeditor'
  namespace :admin do
    resources :pages
    resources :channels
    resources :keystores
    resources :comments
    resources :forages
    get "home/ckeditor_pictures"
    get "home/help"
    get "templetes/index"
    get "templetes/show"
    get "templetes/new"
    post "templetes/create"
    get "templetes/edit"
    post "templetes/update"
    get "templetes/destroy"
    get "templetes/update_cache"
  end
  #routes for front ==============================
  root :to => "welcome#index"
  get "dashboard/index", as: 'user_root' #to use this as user login root
  get 'dashboard/post', as: ''
  
  #match search/tag special path
  match '/search(/page/:page)', to: "welcome#search", via: :get, as: 'search'
  match '/tag/:tag(/page/:page)', to: "welcome#tag", as: 'tag', via: :get
  #shop
  match '/(cate/:cate_id/)products(/page/:page)', to: "products#index", via: :get, as: 'cate_products'
  match '/(cate/:cate_id/)jobs(/page/:page)', to: "jobs#index", via: :get, as: 'cate_jobs'
  #channel
  match '/channel/:id', to: "channel#index", via: :get, as: 'channel'
  match '/post/:id', to: "channel#show", via: :get, as: 'post'
  
end
