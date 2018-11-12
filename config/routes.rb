Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'api#show'

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :authors, except: %i[new edit]

      resources :books, except: %i[new edit]

      resources :publishers, except: %i[new edit] do
        resources :shops, only: [:index]
      end

      resources :shops, only: [] do
        resources :sales, only: [:create]
      end
    end
  end
end
