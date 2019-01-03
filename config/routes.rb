Rails.application.routes.draw do
  get 'locations/index'
  get 'locations/show'
  get 'sessions/new'
  root 'sessions#new'
  get 'profile' => 'users#profile', as:'profile'
  post 'login' => 'sessions#login'
  get 'login' => 'sessions#login'
  resources 'users', except: [:create,:destroy]
  
  resources 'sessions'
  get 'auth/:provider/callback', to: 'sessions#auth_login'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'
  
  get 'show_restaurant',to: 'users#show_restaurant'

  post '/users',to: 'sessions#create'
  
  resources 'bookings'
  resources 'orders'
  
  get 'common_search',to: 'users#common_search'
  
  
  post 'new', to: 'bookings#new'

  resources 'reviews',:except => [:index]
  get 'posts/delete'
  get 'signup', to: 'sessions#create', as: 'signup'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  post 'signup', to: 'sessions#create'
  post 'search',to: 'users#search'
  get 'search', to: 'users#search'
  
  
  get 'contact', to: 'users#contact'

  resources 'locations'

  get 'show_all_restaurant', to: 'users#show_all_restaurant'

  delete 'delete_image_attachment', to: 'posts#delete_image_attachment'
 
  get 'show_post', to: 'posts#show'
  get 'show_review', to: 'reviews#show'

  get 'show_booking', to: 'bookings#show'
  resources 'posts'
  
  namespace :admin do
    get 'orders', to: 'posts#orders'
    delete 'delete_image_attachment', to: 'restaurants#delete_image_attachment'
    resources 'locations'
    resources 'restaurants' 
    get 'all_bookings'=> "posts#all_bookings"
    get 'food_show' => "restaurants#food_show"
    get 'new_food' => "restaurants#new_food"
    post 'new_food' => "restaurants#new_food"
    post 'new_food_create' => "restaurants#new_food_create"
    get 'edit_food' => "restaurants#edit_food"
    patch 'edit_food_update' => "restaurants#edit_food_update"
    post 'edit_food_update' => "restaurants#edit_food_update"
    get 'delete_food' => "restaurants#delete_food" 
    delete 'delete_food' => "restaurants#delete_food" 
    
    resources 'tables'
    resources 'posts'
    resources 'post'
    get 'user_details' => 'posts#show_user_details'
    get 'post_details' => 'posts#show_posts'
  end
  
  #get 'welcome' => 'home#login'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
