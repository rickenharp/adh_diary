# frozen_string_literal: true

module AdhDiary
  module Actions
    module MonthlyReports
      class SinglePdf < AdhDiary::Authenticated
        include Deps["now"]

        def handle(request, response)
          halt 422, "Invalid parameters" unless request.params.valid?
          response.format = :pdf
          response.cache_control :no_store
          response.set_header "Content-Disposition", "inline; filename=\"report-#{now.call.strftime("%F")}.pdf\""
          response.render(view, format: :pdf, layout: false)
        end
      end
    end
  end
end
