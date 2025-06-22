# frozen_string_literal: true

module AdhDiary
  module Views
    module Entries
      class Show < AdhDiary::View
        include Deps["repos.entry_repo"]

        expose :entry do |id:|
          entry_repo.get(id)
        end

        expose(:form, as: Parts::Forms::Entry) do |values: {}, errors: {}|
          {
            values: {},
            errors: errors
          }
        end
      end
    end
  end
end
