module AdhDiary
  module Actions
    module Sessions
      class Destroy < AdhDiary::Action
        def handle(request, response)
          request.env["warden"].logout
          response.redirect_to("/")
        end
      end
    end
  end
end
