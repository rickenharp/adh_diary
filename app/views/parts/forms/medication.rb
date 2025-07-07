# auto_register: false

module AdhDiary
  module Views
    module Parts
      module Forms
        class Medication < AdhDiary::Views::Part
          SCOPE_CLASS = Scopes::Shared::Forms::Input

          def name_input(f)
            prepare_scope(f, :name, icon_name: "pills")
              .render("shared/forms/text_field")
          end

          def errors(key)
            value.dig(:errors, key).to_a
          end

          def html_form(url:, action:, http_method: "post")
            render("medications/form", url: url, medication: value[:medication], action: action, http_method: http_method)
          end

          private

          def prepare_scope(f, field_name, **options)
            scope(
              SCOPE_CLASS,
              f: f,
              field_name: field_name,
              errors: errors(field_name),
              **options
            )
          end
        end
      end
    end
  end
end
