# auto_register: false

module AdhDiary
  module Views
    class Scope < Hanami::View::Scope
      include Deps["settings"]
    end
  end
end
