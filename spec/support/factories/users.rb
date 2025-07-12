require "bcrypt"

Factory.define(:user) do |f|
  f.name { fake(:name, :name) }
  f.email { fake(:internet, :email) }
  f.password_salt { fake(:lorem, :sentence) }
  f.password_hash { fake(:lorem, :sentence) }
  f.locale "en"
end
