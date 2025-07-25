Hanami.app.register_provider(:now) do
  start do
    register :now, -> { AdhDiary::Now.time }, call: false
  end
end
