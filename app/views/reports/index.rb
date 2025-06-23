# frozen_string_literal: true

module AdhDiary
  module Views
    module Reports
      class Index < AdhDiary::View
        include Deps["repos.entry_repo"]

        expose :weeks do
          entry_repo.weeks
        end
      end
    end
  end
end
