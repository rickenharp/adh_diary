# frozen_string_literal: true

module AdhDiary
  class Routes < Hanami::Routes
    # Add your routes here. See https://guides.hanamirb.org/routing/overview/ for details.
    root to: "home.index"

    # New user registration
    get "/users/new", to: "users.new", as: "sign_up"
    post "/users", to: "users.create", as: "create_user"

    # Session management
    get "/login", to: "login.new"
    post "/sessions", to: "sessions.create", as: "create_session"
    delete "/logout", to: "sessions.destroy"

    get "/entries", to: "entries.index", as: "entries"
    get "/entries/new", to: "entries.new", as: "new_entry"
    post "/entries", to: "entries.create", as: "create_entry"
    get "/entries/:id", to: "entries.show", as: "entry"
    get "/entries/:id/edit", to: "entries.edit", as: "edit_entry"
    patch "/entries/:id", to: "entries.update", as: "entry"
    get "/reports", to: "reports.index"
    get "/reports/:week", to: "reports.show", as: "report"
  end
end
