# frozen_string_literal: true

module AdhDiary
  module Views
    module Medications
      class Index < AdhDiary::View
        include Deps["repos.medication_repo"]

        expose :medications do
          medication_repo.all
        end
      end
    end
  end
end
