# frozen_string_literal: true

module AdhDiary
  module Actions
    module Entries
      class New < AdhDiary::Action
        def handle(request, response)
          response.render view, last_medication: request.session[:last_medication], last_dose: request.session[:last_dose]
        end
      end
    end
  end
end
