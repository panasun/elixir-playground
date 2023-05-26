# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
Graphql.Repo.insert!(%Graphql.Menu.Item{
  added_on: ~D[2022-08-27],
  description: "test",
  name: "BinTest",
  price: 100
})

#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
