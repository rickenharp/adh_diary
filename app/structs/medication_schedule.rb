# frozen_string_literal: true

module AdhDiary
  module Structs
    class MedicationSchedule < AdhDiary::DB::Struct
      def long_name
        "#{medication.name} #{morning.to_i}-#{noon.to_i}-#{evening.to_i}-#{before_bed.to_i}"
      end
    end
  end
end
