# frozen_string_literal: true

module AdhDiary
  module Actions
    module Boom
      class Index < AdhDiary::Action
        def handle(request, response)
          raise "This was on purpose"
        end
      end
    end
  end
end
