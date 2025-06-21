# frozen_string_literal: true

module AdhDiary
  module Views
    module Entries
      class Index < AdhDiary::View
        include Deps["repos.entry_repo"]

        expose :entries do |user_id:|
          entry_repo.for(user_id)
        end

        expose :selected_id do |selected_id:|
          selected_id.to_i
        end
      end
    end
  end
end
