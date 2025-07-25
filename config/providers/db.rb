Hanami.app.configure_provider :db do
  Sequel.application_timezone = :utc
  config.gateway :default do |gw|
    # The default PostgreSQL configuration would look like this
    gw.adapter :sql do |sql|
      # ROM plugins are organized under the applicable component type
      # this plugin is named 'instrumentation' and applies to ROM::Relation
      # sql.plugin relations: :instrumentation do |plugin|
      # If the plugin defines a config object with more options
      # you can yield it here and set the values
      # plugin.notifications = slice["notifications"]
      # end

      # Not every plugin requires extra configuration
      # sql.plugin relations: :auto_restrictions

      # Sequel extensions are registered with a single symbolic name
      # sql.extension supports multiple arguments, and you can call it
      # multiple times. We split these up into two simply for readability.
      # sql.extension :caller_logging, :error_sql, :sql_comments
      # sql.extension :pg_array, :pg_enum, :pg_json, :pg_range
    end
  end
end
