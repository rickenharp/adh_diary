# frozen_string_literal: true

require "ostruct"

module AdhDiary
  module Views
    module Entries
      class New < AdhDiary::View
        expose :entry do |last_medication: "", last_dose: ""|
          OpenStruct.new(medication: last_medication, dose: last_dose)
        end

        expose(:form, as: Parts::Forms::Entry) do |values: {}, errors: {}|
          {
            values: values,
            errors: errors
          }
        end
      end
    end
  end
end
