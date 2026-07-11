# frozen_string_literal: true

module AdhDiary
  class Routes < Hanami::Routes
    # Add your routes here. See https://guides.hanamirb.org/routing/overview/ for details.
    use AuthenticationApp
    use AccountDryEffect

    root to: "home.index"

    post "/locale", to: "locale.update", as: "locale"

    resources :entries, except: [:destroy]

    get "/reports/weekly", to: "weekly_reports.index", as: "weekly_reports"
    get "/reports/weekly/:week", to: "weekly_reports.show", as: "weekly_report"
    get "/reports/weekly/:week/pdf", to: "weekly_reports.pdf", as: "weekly_report_pdf"
    post "/reports/weekly/export", to: "weekly_reports.export", as: "weekly_reports_export"

    get "/reports/monthly", to: "monthly_reports.index", as: "monthly_reports"
    get "/reports/monthly/:month", to: "monthly_reports.show", as: "monthly_report"
    get "/reports/monthly/:month/pdf", to: "monthly_reports.pdf", as: "monthly_report_pdf"
    get "/reports/monthly/pdf", to: "monthly_reports.single_pdf", as: "monthly_report_single_pdf"
    post "/reports/monthly/export", to: "monthly_reports.export", as: "monthly_reports_export"

    resources :medications, except: [:show]
    get "/medications/:id/delete", to: "medications.delete", as: "delete_medication"

    resources :medication_schedules, except: [:show]
    get "/medication_schedules/:id/delete", to: "medication_schedules.delete", as: "delete_medication_schedule"

    get "/auth/developer/callback", to: "auth.developer.callback"
    get "/auth/withings/callback", to: "auth.withings.callback"

    get "/boom", to: "boom.index"
  end
end
