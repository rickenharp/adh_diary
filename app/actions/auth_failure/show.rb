module AdhDiary
  module Actions
    module AuthFailure
      class Show < AdhDiary::Action
        def handle(request, response)
          response.body = "STRANGER DANGER"
          response.status = 401
        end
      end
    end
  end
end
