# frozen_string_literal: true

require "prawn"
require "prawn/table"

module AdhDiary
  module Views
    module MonthlyReports
      class SinglePdf < AdhDiary::View
        include Deps["repos.report_repo"]

        scope do
          def strengths_list(selected: nil)
            ["Gar nicht", "leicht", "mäßig", "mittel", "stärker", "stark"].map.with_index do |s, i|
              if i == selected
                "<u><b>#{s}</b></u>"
              else
                s
              end
            end.join(" — ")
          end
        end

        expose :reports do
          report_repo.monthly
        end
      end
    end
  end
end
