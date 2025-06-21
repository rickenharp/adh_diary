# auto_register: false

module AdhDiary
  module Views
    module Parts
      class Entry < AdhDiary::Views::Part
        def css_class
          if context.request.params[:id].to_i == value.id
            "is-selected"
          end
        end
      end
    end
  end
end
