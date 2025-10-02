require "bcrypt"

Factory.define(:account, struct_namespace: AdhDiary::Structs) do |f|
  f.name { fake(:name, :name) }
  f.email { fake(:internet, :email) }
  f.password_salt { fake(:lorem, :sentence) }
  f.password_hash { fake(:lorem, :sentence) }
  f.locale "en"
  f.association(:identities, count: 1)
end
