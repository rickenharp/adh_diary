require "gitlab-chronic"

Factory.define(:identity) do |f|
  f.provider "withings"
  f.uid 1234
  f.token "decafbad"
  f.refresh_token "deadbeef"
  f.expires_at { Chronic.parse("2 hours from now") }
  f.association(:user)
end
