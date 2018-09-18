Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :publishers do
        resources :shops, only: [:index]
      end

      resources :shops, only: [] do
        resources :sales, only: [:create]
      end
    end
  end
end
