migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("82t41kovkganbgh")

  collection.listRule = ""

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("82t41kovkganbgh")

  collection.listRule = null

  return dao.saveCollection(collection)
})
