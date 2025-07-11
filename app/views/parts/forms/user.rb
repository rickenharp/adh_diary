# auto_register: false

module AdhDiary
  module Views
    module Parts
      module Forms
        class User < AdhDiary::Views::Part
          SCOPE_CLASS = Scopes::Shared::Forms::Input

          def name_input(f)
            prepare_scope(f, :name, label: i18n.t("user.name"), icon_name: "user")
              .render("shared/forms/text_field")
          end

          def email_input(f)
            prepare_scope(f, :email, label: i18n.t("user.email"), icon_name: "envelope")
              .render("shared/forms/email_field")
          end

          def password_input(f)
            prepare_scope(f, :password, label: i18n.t("user.password"), icon_name: "key")
              .render("shared/forms/password_field")
          end

          def password_confirmation_input(f)
            prepare_scope(f, :password_confirmation, label: i18n.t("user.password_confirmation"), icon_name: "key")
              .render("shared/forms/password_field")
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
