# frozen_string_literal: true

require "prawn"
require "prawn/table"

module AdhDiary
  module Views
    module Reports
      class Pdf < AdhDiary::View
        include Deps["repos.weekly_report_repo"]

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

        expose :weekly_report do |week:|
          weekly_report_repo.get(week)
        end
      end
    end
  end
end
