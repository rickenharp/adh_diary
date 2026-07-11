# frozen_string_literal: true

module AdhDiary
  module Actions
    module WeeklyReports
      class Show < AdhDiary::Authenticated
        def handle(request, response)
          response.render(view, week: request.params[:week])
        end
      end
    end
  end
end
