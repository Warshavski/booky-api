# frozen_string_literal: true

module Errors
  # Errors::RequestErrorsSerializer
  #
  class RequestErrorsSerializer
    class << self
      attr_reader :resolvers

      def resolver(status, &block)
        (@resolvers ||= {})[status] = block
      end
    end

    resolver :kaboom do |_, opts|
      message = I18n.t('errors.messages.requests.internal_server_error')

      { code: opts[:status_code], message: message, path: ['server'] }
    end

    resolver :not_found do |error, opts|
      model = error.model.downcase

      model_name  = I18n.t(model, scope: :'activerecord.models')
      message     = I18n.t('errors.messages.resources.not_found', model: model_name, id: error.id)

      { code: opts[:status_code], message: message, path: [model] }
    end

    resolver :timeout do |_, opts|
      message = I18n.t('errors.messages.requests.request_timeout')

      { code: opts[:status_code], message: message, path: ['server'] }
    end

    def initialize(error, type)
      @error = error
      @type = type
    end

    def serialize(status, opts = {})
      status_code = Rack::Utils.status_code(status)
      resolver    = self.class.resolvers[@type]

      error_description =
        resolver.call(@error, opts.merge(status_code: status_code))

      { errors: Array.wrap(error_description) }
    end
  end
end
