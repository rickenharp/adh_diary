# frozen_string_literal: true

module AdhDiary
  module Views
    module Medications
      class Delete < AdhDiary::View
        include Deps["repos.medication_repo"]

        expose :medication do |id:|
          medication_repo.get(id)
        end
      end
    end
  end
end
