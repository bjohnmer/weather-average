Rails.application.routes.draw do
  root 'home#welcome'
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :locations, only: [:create, :update, :destroy]
    end
  end
end
