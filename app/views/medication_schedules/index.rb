# frozen_string_literal: true

require "ostruct"
module AdhDiary
  module Views
    module MedicationSchedules
      class Index < AdhDiary::View
        expose :medication_schedules do
          [
            OpenStruct.new(
              id: 1,
              medication: OpenStruct.new(name: "Lisdexamfetamin"),
              morning: 30.0,
              noon: 0,
              evening: 0,
              before_bed: 0
            ),
            OpenStruct.new(
              id: 2,
              medication: OpenStruct.new(name: "Lisdexamfetamin"),
              morning: 40.0,
              noon: 0,
              evening: 0,
              before_bed: 0
            )
          ]
        end
      end
    end
  end
end
