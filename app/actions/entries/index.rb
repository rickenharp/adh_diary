# frozen_string_literal: true

module AdhDiary
  module Actions
    module Entries
      class Index < AdhDiary::Authenticated
        def handle(request, response)
          response.render(
            view,
            page: (request.params[:page] || 1).to_i
          )
        end
      end
    end
  end
end
