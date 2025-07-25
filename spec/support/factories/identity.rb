Factory.define(:identity) do |f|
  f.provider "withings"
  f.uid 1234
  f.token "decafbad"
  f.refresh_token "deadbeef"
  f.expires_at { Hanami.app["now"].call + 60 * 60 * 2 }
  f.association(:user)
end
