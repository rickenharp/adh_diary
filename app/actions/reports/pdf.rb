# frozen_string_literal: true

module AdhDiary
  module Actions
    module Reports
      class Pdf < AdhDiary::AuthenticatedAction
        params do
          required(:week).filled(:string)
        end
        def handle(request, response)
          halt 422, "Invalid parameters" unless request.params.valid?
          response.format = :pdf
          response.cache_control :no_store
          response.set_header "Content-Disposition", "inline; filename=\"#{request.params[:week]}.pdf\""
          response.render(view, format: :pdf, layout: false, week: request.params[:week])
        end
      end
    end
  end
end
