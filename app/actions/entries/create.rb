# frozen_string_literal: true

module AdhDiary
  module Actions
    module Entries
      class Create < AdhDiary::AuthenticatedAction
        include Deps["repos.entry_repo"]

        params do
          required(:entry).hash do
            required(:date).filled(:date)
            required(:dose).filled(:integer)
            required(:medication).filled(:string)
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
            entry_repo.on(date).count
          else
            0
          end

          if request.params.valid? && existing_entries.zero?
            request.session[:last_medication] = request.params[:entry][:medication]
            request.session[:last_dose] = request.params[:entry][:dose]
            entry = entry_repo.create(request.params[:entry].merge(user_id: request.session[:user_id]))

            response.flash[:notice] = "Entry created"
            response.redirect_to routes.path(:entries, id: entry[:id])
          else
            response.flash.now[:alert] = "Could not create entry"
            errors = request.params.errors[:entry].to_h

            unless existing_entries.zero?
              errors[:date] = [] unless errors.key?(:date)
              errors[:date] << "already exists"
            end
            response.render(
              view,
              values: request.params[:entry],
              errors:
            )
            # Implicitly re-renders the "new" view
          end
        end
      end
    end
  end
end
