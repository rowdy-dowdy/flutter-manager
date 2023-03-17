migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("82t41kovkganbgh")

  collection.listRule = "status = true"
  collection.viewRule = "status = true"

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("82t41kovkganbgh")

  collection.listRule = null
  collection.viewRule = null

  return dao.saveCollection(collection)
})
