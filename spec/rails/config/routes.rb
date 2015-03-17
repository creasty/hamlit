Rails.application.routes.draw do
  root to: 'application#index'

  resources :users, only: :index do
    collection do
      get :capture
      get :form
    end
  end
end
