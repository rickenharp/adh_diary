Hanami.app.register_provider(:current_account) do
  start do
    register :current_account, AdhDiary::CurrentAccount.new
  end
end
