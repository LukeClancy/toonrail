Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "pages#latest"
  resources :chapters, param: "order" do
    resources :pages, param: "order"
  end
  resources :pages
  resources :comments, only: [:create, :destroy, :show, :edit, :update]
  get "users/:id/comments" => "comments#user_comments_index"
  put "comments/:id/up_vote" => "comments#up_vote"
  put "comments/:id/down_vote" => "comments#down_vote"
  resources :user_images, only: [:create, :destroy, :show]
  post 'csp-violation-report-endpoint', to: "csp#create"
end
