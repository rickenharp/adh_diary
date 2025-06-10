# auto_register: false
# frozen_string_literal: true

require "hanami/action"
require "dry/monads"

module AdhDiary
  class Action < Hanami::Action
    # Provide `Success` and `Failure` for pattern matching on operation results
    include Dry::Monads[:result]

    handle_exception ROM::TupleCountMismatchError => :handle_not_found

    private

    def handle_not_found(request, response, exception)
      response.status = 404
      response.format = :html
      response.body = "Not found"
    end
  end
end
