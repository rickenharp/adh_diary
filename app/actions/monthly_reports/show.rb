# frozen_string_literal: true

module AdhDiary
  module Actions
    module MonthlyReports
      class Show < AdhDiary::Authenticated
        def handle(request, response)
          response.render(view, month: request.params[:month])
        end
      end
    end
  end
end
