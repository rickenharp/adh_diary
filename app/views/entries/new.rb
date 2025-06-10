# frozen_string_literal: true

module AdhDiary
  module Views
    module Entries
      class New < AdhDiary::View
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
