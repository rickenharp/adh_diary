# frozen_string_literal: true

module AdhDiary
  module Views
    module Entries
      class Index < AdhDiary::View
        include Deps["repos.entry_repo"]

        expose :entries do
          entry_repo.all
        end
      end
    end
  end
end
