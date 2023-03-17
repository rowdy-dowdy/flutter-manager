migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("yhrkdo0oicldako")

  collection.listRule = ""

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("yhrkdo0oicldako")

  collection.listRule = null

  return dao.saveCollection(collection)
})
