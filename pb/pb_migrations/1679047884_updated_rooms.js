migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("yhrkdo0oicldako")

  collection.listRule = "status = true"
  collection.viewRule = "status = true"

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("yhrkdo0oicldako")

  collection.listRule = null
  collection.viewRule = null

  return dao.saveCollection(collection)
})
