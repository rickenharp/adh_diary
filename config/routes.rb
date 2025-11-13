# frozen_string_literal: true

module AdhDiary
  class Routes < Hanami::Routes
    # Add your routes here. See https://guides.hanamirb.org/routing/overview/ for details.
    use AuthenticationApp
    use AccountDryEffect

    root to: "home.index"

    post "/locale", to: "locale.update", as: "locale"

    resources :entries, except: [:destroy]

    get "/reports", to: "reports.index", as: "reports"
    get "/reports/:week", to: "reports.show", as: "report"
    get "/reports/:week/pdf", to: "reports.pdf", as: "report_pdf"
    post "/reports/export", to: "reports.export", as: "reports_export"

    resources :medications, except: [:show]
    get "/medications/:id/delete", to: "medications.delete", as: "delete_medication"

    resources :medication_schedules, except: [:show]
    get "/medication_schedules/:id/delete", to: "medication_schedules.delete", as: "delete_medication_schedule"

    get "/auth/developer/callback", to: "auth.developer.callback"
    get "/auth/withings/callback", to: "auth.withings.callback"

    get "/boom", to: "boom.index"
  end
end
