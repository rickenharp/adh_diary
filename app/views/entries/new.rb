# frozen_string_literal: true

require "ostruct"

module AdhDiary
  module Views
    module Entries
      class New < AdhDiary::View
        include Deps["repos.entry_repo"]

        expose :entry do
          OpenStruct.new(
            medication_schedule_id: entry_repo.last_entry&.medication_schedule_id,
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
