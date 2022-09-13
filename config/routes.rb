Rails.application.routes.draw do
  root to: "homes#top"
  get 'home/about' =>  'homes#about',as:'about'

  devise_for :users

  resources :books do
   resource :favorites, only: [:create, :destroy]

   resources :book_comments, only: [:create, :destroy]
  end

  resources :users, only:[:show, :edit, :update ,:index] do
     resource :relationships, only: [:create, :destroy]
     get 'relationships/followings' => 'relationships#followings', as: 'followings'
     get 'relationships/followers'  => 'relationships#followers', as: 'followers'
  end

  get 'search' => 'searches#search'

  resources :events

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end