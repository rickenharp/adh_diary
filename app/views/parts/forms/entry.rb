# auto_register: false

module AdhDiary
  module Views
    module Parts
      module Forms
        class Entry < AdhDiary::Views::Part
          SCOPE_CLASS = Scopes::Shared::Forms::Input
          OPTIONS = {
            "gar nicht" => 0,
            "leicht" => 1,
            "mäßig" => 2,
            "mittel" => 3,
            "stärker" => 4,
            "stark" => 5
          }.freeze

          def date_input(f)
            prepare_scope(f, :date, value: value.dig(:values, :date) || Date.today.to_s)
              .render("shared/forms/date_field")
          end

          def attention_input(f)
            prepare_scope(f, :attention, label: "Attention span", options: OPTIONS)
              .render("shared/forms/radio_button_field")
          end

          def organisation_input(f)
            prepare_scope(f, :organisation, label: "Organisation", options: OPTIONS)
              .render("shared/forms/radio_button_field")
          end

          def mood_swings_input(f)
            prepare_scope(f, :mood_swings, label: "Mood swings", options: OPTIONS)
              .render("shared/forms/radio_button_field")
          end

          def stress_sensitivity_input(f)
            prepare_scope(f, :stress_sensitivity, label: "Stress sensitivity", options: OPTIONS)
              .render("shared/forms/radio_button_field")
          end

          def irritability_input(f)
            prepare_scope(f, :irritability, label: "Irritability", options: OPTIONS)
              .render("shared/forms/radio_button_field")
          end

          def restlessness_input(f)
            prepare_scope(f, :restlessness, label: "Restlessness", options: OPTIONS)
              .render("shared/forms/radio_button_field")
          end

          def impulsivity_input(f)
            prepare_scope(f, :impulsivity, label: "Impulsivity", options: OPTIONS)
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

          def errors(key)
            value.dig(:errors, key).to_a
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
