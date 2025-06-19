Hanami.app.register_provider(:warden) do
  prepare do
    user_repo = target["repos.user_repo"]
    require "warden"
    require "adh_diary/bcrypt_strategy"

    Warden::Strategies.add(:password, AdhDiary::BcryptStrategy)

    Warden::Manager.serialize_into_session { |user| user.id }
    Warden::Manager.serialize_from_session { |id| user_repo.by_id(id) }
  end
end
