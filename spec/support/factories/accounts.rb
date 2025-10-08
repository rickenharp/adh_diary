require "bcrypt"

Factory.define(:account, struct_namespace: AdhDiary::Structs) do |f|
  f.name { fake(:name, :name) }
  f.email { fake(:internet, :email) }
  f.password_hash { |password| BCrypt::Password.create(password) }
  f.locale "en"
  f.status_id 2
  f.association(:identities, count: 1)
  f.transient do |t|
    t.password "gnarf"
  end
end
