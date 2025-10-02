# frozen_string_literal: true

module AdhDiary
  class Routes < Hanami::Routes
    # Add your routes here. See https://guides.hanamirb.org/routing/overview/ for details.
    root to: "home.index"

    # New account registration
    get "/accounts/new", to: "accounts.new", as: "sign_up"
    post "/accounts", to: "accounts.create", as: "create_account"

    # Session management
    get "/login", to: "login.new", as: "login"
    post "/sessions", to: "sessions.create", as: "create_session"
    delete "/logout", to: "sessions.destroy", as: "logout"

    post "/locale", to: "locale.update", as: "locale"

    get "/entries", to: "entries.index", as: "entries"
    get "/entries/new", to: "entries.new", as: "new_entry"
    post "/entries", to: "entries.create", as: "create_entry"
    get "/entries/:id", to: "entries.show", as: "entry"
    get "/entries/:id/edit", to: "entries.edit", as: "edit_entry"
    patch "/entries/:id", to: "entries.update", as: "entry"
    get "/reports", to: "reports.index", as: "reports"
    get "/reports/:week", to: "reports.show", as: "report"
    get "/reports/:week/pdf", to: "reports.pdf", as: "report_pdf"
    post "/reports/export", to: "reports.export", as: "reports_export"

    get "/medications", to: "medications.index", as: "medications"
    get "/medications/:id/delete", to: "medications.delete", as: "delete_medication"
    delete "/medications/:id", to: "medications.destroy", as: "destroy_medication"
    get "/medications/new", to: "medications.new", as: "new_medication"
    post "/medications", to: "medications.create", as: "create_medication"
    get "/medications/:id/edit", to: "medications.edit", as: "edit_medication"
    patch "/medications/:id", to: "medications.update", as: "update_medication"

    get "/medication_schedules", to: "medication_schedules.index", as: "medication_schedules"
    get "/medication_schedules/:id/edit", to: "medication_schedules.edit", as: "edit_medication_schedule"
    patch "/medication_schedules/:id", to: "medication_schedules.update", as: "update_medication_schedule"
    get "/medication_schedules/new", to: "medication_schedules.new", as: "new_medication_schedule"
    post "/medication_schedules", to: "medication_schedules.create", as: "create_medication_schedule"
    get "/medication_schedules/:id/delete", to: "medication_schedules.delete", as: "delete_medication_schedule"
    delete "/medication_schedules/:id", to: "medication_schedules.destroy", as: "destroy_medication_schedule"

    get "/auth/developer/callback", to: "auth.developer.callback"
    get "/auth/withings/callback", to: "auth.withings.callback"
    get "/boom", to: "boom.index"
  end
end
