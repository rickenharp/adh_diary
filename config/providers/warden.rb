Hanami.app.register_provider(:warden) do
  prepare do
    account_repo = target["repos.account_repo"]
    require "warden"
    require "adh_diary/bcrypt_strategy"

    Warden::Strategies.add(:password, AdhDiary::BcryptStrategy)

    Warden::Manager.serialize_into_session { |account| account.id }
    Warden::Manager.serialize_from_session { |id| account_repo.by_id(id) }
  end
end
