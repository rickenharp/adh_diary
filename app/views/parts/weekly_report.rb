# auto_register: false
# frozen_string_literal: true

module AdhDiary
  module Views
    module Parts
      class WeeklyReport < AdhDiary::Views::Part
        def medication
          Array(value.medication).join(", ")
        end
      end
    end
  end
end
