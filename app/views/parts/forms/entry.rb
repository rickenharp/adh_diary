# auto_register: false

module AdhDiary
  module Views
    module Parts
      module Forms
        class Entry < AdhDiary::Views::Part
          SCOPE_CLASS = Scopes::Shared::Forms::Input

          def date_input(f)
            prepare_scope(f, :date)
              .render("shared/forms/date_field")
          end

          def attention_input(f)
            prepare_scope(f, :attention, label: "Attention span", options: Types::Strength.mapping)
              .render("shared/forms/radio_button_field")
          end

          def organisation_input(f)
            prepare_scope(f, :organisation, label: "Organisation", options: Types::Strength.mapping)
              .render("shared/forms/radio_button_field")
          end

          def mood_swings_input(f)
            prepare_scope(f, :mood_swings, label: "Mood swings", options: Types::Strength.mapping)
              .render("shared/forms/radio_button_field")
          end

          def stress_sensitivity_input(f)
            prepare_scope(f, :stress_sensitivity, label: "Stress sensitivity", options: Types::Strength.mapping)
              .render("shared/forms/radio_button_field")
          end

          def irritability_input(f)
            prepare_scope(f, :irritability, label: "Irritability", options: Types::Strength.mapping)
              .render("shared/forms/radio_button_field")
          end

          def restlessness_input(f)
            prepare_scope(f, :restlessness, label: "Restlessness", options: Types::Strength.mapping)
              .render("shared/forms/radio_button_field")
          end

          def impulsivity_input(f)
            prepare_scope(f, :impulsivity, label: "Impulsivity", options: Types::Strength.mapping)
              .render("shared/forms/radio_button_field")
          end

          def side_effects_input(f)
            prepare_scope(f, :side_effects)
              .render("shared/forms/text_area")
          end

          def blood_pressure_input(f)
            prepare_scope(f, :blood_pressure, icon_name: "heartbeat", placeholder: "120/75")
              .render("shared/forms/text_field")
          end

          def weight_input(f)
            prepare_scope(f, :weight, icon_name: "weight", placeholder: "100.5")
              .render("shared/forms/number_field")
          end

          def dose_input(f)
            prepare_scope(f, :dose, icon_name: "scale-balanced", placeholder: "30")
              .render("shared/forms/number_field")
          end

          def medication_input(f)
            prepare_scope(f, :medication, icon_name: "pills", placeholder: "Lisdexamfetamin")
              .render("shared/forms/text_field")
          end

          def errors(key)
            value.dig(:errors, key).to_a
          end

          def html_form(url:, action:, http_method: "post")
            render("entries/form", url: url, entry: value[:entry], action: action, http_method: http_method)
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
