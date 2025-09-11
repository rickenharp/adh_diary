# auto_register: false

module AdhDiary
  module Views
    module Parts
      module Forms
        class Entry < AdhDiary::Views::Part
          include Deps["repos.medication_schedule_repo"]

          SCOPE_CLASS = Scopes::Shared::Forms::Input

          def date_input(f)
            prepare_scope(f, :date, label: i18n.t("entry.date.full"))
              .render("shared/forms/date_field")
          end

          def attention_input(f)
            prepare_scope(f, :attention, label: i18n.t("entry.attention_span.full"), options: Types::Strength.mapping)
              .render("shared/forms/radio_button_field")
          end

          def organisation_input(f)
            prepare_scope(f, :organisation, label: i18n.t("entry.organisation.full"), options: Types::Strength.mapping)
              .render("shared/forms/radio_button_field")
          end

          def mood_swings_input(f)
            prepare_scope(f, :mood_swings, label: i18n.t("entry.mood_swings.full"), options: Types::Strength.mapping)
              .render("shared/forms/radio_button_field")
          end

          def stress_sensitivity_input(f)
            prepare_scope(f, :stress_sensitivity, label: i18n.t("entry.stress_sensitivity.full"), options: Types::Strength.mapping)
              .render("shared/forms/radio_button_field")
          end

          def irritability_input(f)
            prepare_scope(f, :irritability, label: i18n.t("entry.irritability.full"), options: Types::Strength.mapping)
              .render("shared/forms/radio_button_field")
          end

          def restlessness_input(f)
            prepare_scope(f, :restlessness, label: i18n.t("entry.restlessness.full"), options: Types::Strength.mapping)
              .render("shared/forms/radio_button_field")
          end

          def impulsivity_input(f)
            prepare_scope(f, :impulsivity, label: i18n.t("entry.impulsivity.full"), options: Types::Strength.mapping)
              .render("shared/forms/radio_button_field")
          end

          def side_effects_input(f)
            prepare_scope(f, :side_effects, label: i18n.t("entry.side_effects.full"))
              .render("shared/forms/text_area")
          end

          def blood_pressure_input(f)
            prepare_scope(f, :blood_pressure, label: i18n.t("entry.blood_pressure.full"), icon_name: "heartbeat", placeholder: "120/75")
              .render("shared/forms/text_field")
          end

          def weight_input(f)
            prepare_scope(f, :weight, label: i18n.t("entry.weight.full"), icon_name: "weight", placeholder: "100.5")
              .render("shared/forms/number_field")
          end

          def medication_schedule_input(f)
            values = medication_schedule_repo.all.each_with_object({}) { _2[_1.long_name] = _1.id }
            prepare_scope(f, :medication_schedule_id, label: i18n.t("entry.medication_schedule.full"), icon_name: "pills", values: values, selected: value[:entry].medication_schedule_id)
              .render("shared/forms/select_field")
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
