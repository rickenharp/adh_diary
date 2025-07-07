# frozen_string_literal: true

module AdhDiary
  module Views
    module Medications
      class New < AdhDiary::View
        expose(:form, as: Parts::Forms::Medication) do |values: {}, errors: {}|
          {
            values: values,
            errors: errors
          }
        end
      end
    end
  end
end
