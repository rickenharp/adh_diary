# frozen_string_literal: true

module AdhDiary
  module Views
    module Accounts
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
