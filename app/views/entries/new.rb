# frozen_string_literal: true

require "ostruct"

module AdhDiary
  module Views
    module Entries
      class New < AdhDiary::View
        expose :entry do |last_medication: "", last_dose: ""|
          OpenStruct.new(
            medication_id: last_medication,
            dose: last_dose,
            date: Date.today
          )
        end

        expose(:form, as: Parts::Forms::Entry) do |entry, values: {}, errors: {}|
          {
            entry: entry,
            values: values,
            errors: errors
          }
        end
      end
    end
  end
end
