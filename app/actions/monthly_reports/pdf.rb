# frozen_string_literal: true

module AdhDiary
  module Actions
    module MonthlyReports
      class Pdf < AdhDiary::Authenticated
        params do
          required(:month).filled(:string)
        end
        def handle(request, response)
          halt 422, "Invalid parameters" unless request.params.valid?
          response.format = :pdf
          response.cache_control :no_store
          response.set_header "Content-Disposition", "inline; filename=\"#{request.params[:month]}.pdf\""
          response.render(view, format: :pdf, layout: false, month: request.params[:month])
        end
      end
    end
  end
end
