# frozen_string_literal: true

require "ostruct"

module AdhDiary
  module Views
    module Entries
      class New < AdhDiary::View
        include Dry::Monads[:result]
        include Deps["repos.entry_repo", "withings.get_measurements", "logger", "current_account"]

        expose :entry do
          measurements = case get_measurements.call(current_account.obj)
          in Success(measurements)
            measurements
          in Failure(failure)
            logger.info("Got #{failure} while trying access Withings API")
            {weight: 0, blood_pressure: ""}
          end
          OpenStruct.new(
            medication_schedule_id: entry_repo.last_entry&.medication_schedule_id,
            date: Date.today,
            weight: measurements[:weight],
            blood_pressure: measurements[:blood_pressure]
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
