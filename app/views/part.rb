# auto_register: false

module AdhDiary
  module Views
    class Part < Hanami::View::Part
      include Deps["i18n"]
    end
  end
end
