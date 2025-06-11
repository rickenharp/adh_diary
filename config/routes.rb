# frozen_string_literal: true

module AdhDiary
  class Routes < Hanami::Routes
    # Add your routes here. See https://guides.hanamirb.org/routing/overview/ for details.
    root to: "home.index"
    get "/entries", to: "entries.index"
    get "/entries/new", to: "entries.new"
    post "/entries", to: "entries.create", as: "create_entry"
    get "/entries/:id", to: "entries.show", as: "show_entry"

    get "/auth/developer/callback", to: "auth.developer_callback"
  end
end
