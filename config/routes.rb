# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # @see AboutController
  root to: 'about#show', defaults: { format: 'json' }

  # @see GraphqlController
  post Constants::GRAPHQL_ENDPOINT, to: 'graphql#execute'

  if Rails.env.development?
    mount GraphiQL::Rails::Engine,
          at: '/graphiql',
          graphql_path: Constants::GRAPHQL_ENDPOINT
  end
end
