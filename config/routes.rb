Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  mount Ckeditor::Engine => '/ckeditor'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # devise_for :users, path: 'user'
  devise_for :users, path: 'user', controllers: {registrations: 'users/registrations'}
  devise_scope :user do
    post '/admin/is_uid_exist', to: 'users/registrations#is_uid_exist'
  end

  get 'update_captcha', to: 'simple_captcha#update_captcha'

  namespace :admin, path: '/admin' do
    root 'home#index'

    get '/profile', to: 'home#profile'
    post '/update_profile', to: 'home#update_profile'

    resources :posts

    resources :replies, only: [:destroy, :index] do
      member do
        post 'hide', to: 'replies#hide'
        post 'restore', to: 'replies#restore'
      end
    end

    resources :messages, only: [:show, :destroy, :index] do
       member do
        post 'mark_as_read', to: 'messages#mark_as_read'
      end
    end

    resources :codes

    resources :categories, except: [:new]
  end

  namespace :frontend, path: '/' do
    root 'home#index'

    get '/about_us', to: 'home#about_us'

    resources :blogs, only: [:show, :index]

    resources :posts, only: [:show] do
      resources :replies, only: [:create]
    end

    scope ':uid' do
      get '/', to: 'users#show'
      get '/profile', to: 'users#profile'

      resources :categories, only: [:show]

      resources :codes, only: [:show, :index]
    end

  end

end
