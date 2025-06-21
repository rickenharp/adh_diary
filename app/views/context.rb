# auto_register: false

module AdhDiary
  module Views
    class Context < Hanami::View::Context
      def warden
        request.env["warden"]
      end
    end
  end
end
