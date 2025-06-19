module AdhDiary
  module Views
    module Scopes
      module Shared
        module Forms
          class Input < AdhDiary::Views::Scope
            def field_name
              super.to_s
            end

            def label_text
              return label if respond_to?(:label) && label

              _context.inflector.humanize(field_name)
            end

            def control_field_classes
              classes = %w[control has-icons-left]
              classes << "has-icons-right" if error_field?
              classes.join(" ")
            end

            def placeholder_text
              return placeholder if respond_to?(:placeholder) && placeholder

              _context.inflector.humanize(field_name)
            end

            def input_field_classes
              classes = %w[input]
              classes << "is-danger" if error_field?
              classes.join(" ")
            end

            def text_area_classes
              classes = %w[textarea]
              classes << "is-danger" if error_field?
              classes.join(" ")
            end

            def date_field_classes
              classes = %w[input]
              classes << "is-danger" if error_field?
              classes.join(" ")
            end

            def radio_field_classes
              classes = %w[radio]
              classes << "is-danger" if error_field?
              classes.join(" ")
            end

            def email_field_classes
              classes = %w[email]
              classes << "is-danger" if error_field?
              classes.join(" ")
            end

            def password_field_classes
              classes = %w[password]
              classes << "is-danger" if error_field?
              classes.join(" ")
            end

            def icon_name?
              respond_to?(:icon_name) && icon_name
            end

            def error_field?
              errors.any?
            end
          end
        end
      end
    end
  end
end
