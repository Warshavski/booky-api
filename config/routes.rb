Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'about#show', defaults: { format: 'json' }

  scope :api, defaults: { format: 'json' } do
    scope :v1 do
      devise_for :users,
                 controllers: {
                   registrations: 'api/v1/users/registrations',
                   confirmations: 'api/v1/users/confirmations',
                   unlocks:       'api/v1/users/unlocks'
                 },
                 skip: %i[sessions password]
    end
  end

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
