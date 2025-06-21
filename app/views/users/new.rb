# frozen_string_literal: true

module AdhDiary
  module Views
    module Users
      class New < AdhDiary::View
        expose(:form, as: Parts::Forms::User) do |values: {}, errors: {}|
          {
            values: values,
            errors: errors
          }
        end
      end
    end
  end
end
