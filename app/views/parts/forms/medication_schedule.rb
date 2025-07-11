# auto_register: false

module AdhDiary
  module Views
    module Parts
      module Forms
        class MedicationSchedule < AdhDiary::Views::Part
          include Deps["repos.medication_schedule_repo", "repos.medication_repo"]
          SCOPE_CLASS = Scopes::Shared::Forms::Input

          def medication_id_input(f)
            values = medication_repo.all.each_with_object({}) { _2[_1.name] = _1.id }
            prepare_scope(f, :medication_id, label: i18n.t("medication_schedule.medication"), icon_name: "pills", values: values, selected: value[:medication_schedule].medication_id)
              .render("shared/forms/select_field")
          end

          def morning_input(f)
            prepare_scope(f, :morning, label: i18n.t("medication_schedule.morning"), icon_name: "sun")
              .render("shared/forms/number_field")
          end

          def noon_input(f)
            prepare_scope(f, :noon, label: i18n.t("medication_schedule.noon"), icon_name: "bowl-food")
              .render("shared/forms/number_field")
          end

          def evening_input(f)
            prepare_scope(f, :evening, label: i18n.t("medication_schedule.evening"), icon_name: "moon")
              .render("shared/forms/number_field")
          end

          def before_bed_input(f)
            prepare_scope(f, :before_bed, label: i18n.t("medication_schedule.before_bed"), icon_name: "bed")
              .render("shared/forms/number_field")
          end

          def errors(key)
            value.dig(:errors, key).to_a
          end

          def html_form(url:, action:, http_method: "post")
            render("medication_schedules/form", url: url, medication_schedule: value[:medication_schedule], action: action, http_method: http_method)
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
