# frozen_string_literal: true

module AdhDiary
  module Actions
    module Entries
      class Update < AdhDiary::AuthenticatedAction
        include Deps[
          entry_repo: "repos.entry_repo",
          show_view: "views.entries.show"
                ]

        params do
          required(:id).filled(:integer)
          required(:entry).hash do
            required(:date).filled(:date)
            required(:medication).filled(:string)
            required(:dose).filled(:integer)
            required(:attention).filled(:integer)
            required(:organisation).filled(:integer)
            required(:mood_swings).filled(:integer)
            required(:stress_sensitivity).filled(:integer)
            required(:irritability).filled(:integer)
            required(:restlessness).filled(:integer)
            required(:impulsivity).filled(:integer)
            optional(:side_effects)
            required(:blood_pressure).filled(:string)
            required(:weight).filled(:float)
          end
        end

        def handle(request, response)
          existing_entries = if (date = request.params.dig(:entry, :date))
            entry_repo.on(date).where(Sequel.~(id: request.params[:id])).count
          else
            0
          end

          if request.params.valid? && existing_entries.zero?
            entry = entry_repo.update(request.params[:id], request.params[:entry].merge(user_id: request.session[:user_id]))

            response.flash[:notice] = "Entry updated"
            response.redirect_to routes.path(:entries, id: entry[:id])
          else
            response.flash.now[:alert] = "Could not update entry"
            errors = request.params.errors[:entry].to_h

            unless existing_entries.zero?
              errors[:date] = [] unless errors.key?(:date)
              errors[:date] << "already exists"
            end
            response.render(
              show_view,
              values: request.params[:entry],
              errors:,
              id: request.params[:id]
            )
            # Implicitly re-renders the "new" view
          end
        end
      end
    end
  end
end
