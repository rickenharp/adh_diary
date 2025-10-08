# This seeds file should create the database records required to run the app.
#
# The code should be idempotent so that it can be executed at any time.
#
# To load the seeds, run `hanami db seed`. Seeds are also loaded as part of `hanami db prepare`.

# For example, if you have appropriate repos available:
#
#   category_repo = Hanami.app["repos.category_repo"]
#   category_repo.create(title: "General")
#
# Alternatively, you can use relations directly:
#
#   categories = Hanami.app["relations.categories"]
#   categories.insert(title: "General")
# medications = Hanami.app["relations.medications"]
# medications.dataset.insert_conflict.insert(name: "Lisdexamfetamin")
# medications.dataset.insert_conflict.insert(name: "Medikinet")
account_statuses_table = Hanami.app["db.gateway"].connection[:account_statuses]
unless account_statuses_table.to_a.any?
  account_statuses_table.multi_insert(
    [
      {id: 1, name: "Unverified"},
      {id: 2, name: "Verified"},
      {id: 3, name: "Closed"}
    ]
  )
end
