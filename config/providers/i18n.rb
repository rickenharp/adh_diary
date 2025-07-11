Hanami.app.register_provider(:i18n) do
  prepare do
    require "i18n"
  end

  start do
    load_paths = Dir["#{target.root}/config/locales/**/*.yml"]

    I18n.load_path += load_paths
    I18n.available_locales = [:en, :de]
    I18n.default_locale = :en
    I18n.backend.load_translations

    register :i18n, I18n
  end
end
