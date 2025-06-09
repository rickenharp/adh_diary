# frozen_string_literal: true

module AdhDiary
  class Routes < Hanami::Routes
    # Add your routes here. See https://guides.hanamirb.org/routing/overview/ for details.
    root to: "home.index"
    get "/entries", to: "entries.index"
  end
end
