# frozen_string_literal: true

require "zip"

module AdhDiary
  module Actions
    module Reports
      class Export < AdhDiary::Action
        include Deps["views.reports.index", "views.reports.pdf", "now"]

        params do
          required(:export).hash do
            required(:ids).array(:string)
          end
        end

        def handle(request, response)
          if request.params.valid?
            response.format = :zip
            response.set_header "Content-Disposition", "attachment; filename=\"export-#{now.call.strftime("%Y-%m-%d-%H-%M")}.zip\""

            zip_file = Zip::OutputStream.write_buffer do |zip|
              request.params[:export][:ids].each do |week|
                zip.put_next_entry("#{week}.pdf")
                zip.print pdf.call(format: :pdf, layout: false, week: week).to_s
              end
            end
            response.body = zip_file.string
          else
            response.flash.now[:alert] = "Please select reports to export"
            response.render(index)
          end
        end
      end
    end
  end
end
