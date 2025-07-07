# frozen_string_literal: true

module AdhDiary
  module Views
    module Medications
      class Edit < AdhDiary::View
        include Deps["repos.medication_repo"]

        expose :medication do |id:|
          medication_repo.get(id)
        end

        expose(:form, as: Parts::Forms::Medication) do |medication, values: {}, errors: {}|
          {
            medication: medication,
            values: {},
            errors: errors
          }
        end
      end
    end
  end
end
