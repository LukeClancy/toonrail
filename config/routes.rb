Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :posts
  root to: "pages#latest"
  resources :chapters, param: "order" do
    resources :pages, param: "order"
  end
  resources :pages
end
