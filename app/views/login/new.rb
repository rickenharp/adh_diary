# frozen_string_literal: true

module AdhDiary
  module Views
    module Login
      class New < AdhDiary::View
        expose(:form, as: Parts::Forms::Account) do |values: {}, errors: {}|
          {
            values: values,
            errors: errors
          }
        end
      end
    end
  end
end
