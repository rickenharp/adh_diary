# frozen_string_literal: true

module AdhDiary
  module Views
    module Entries
      class Index < AdhDiary::View
        include Deps["repos.entry_repo"]

        expose :entries do |page: 1|
          entry_repo.all(page: page)
        end

        expose :pager do |page: 1|
          entry_repo.all(page: page).pager
        end
      end
    end
  end
end
