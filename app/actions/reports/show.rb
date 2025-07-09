# frozen_string_literal: true

module AdhDiary
  module Actions
    module Reports
      class Show < AdhDiary::AuthenticatedAction
        def handle(request, response)
          response.render(view, week: request.params[:week])
        end
      end
    end
  end
end
