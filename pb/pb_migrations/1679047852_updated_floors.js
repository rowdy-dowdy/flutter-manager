migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("82t41kovkganbgh")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "yxlnxdmp",
    "name": "rooms",
    "type": "relation",
    "required": false,
    "unique": false,
    "options": {
      "collectionId": "yhrkdo0oicldako",
      "cascadeDelete": false,
      "minSelect": null,
      "maxSelect": null,
      "displayFields": [
        "title"
      ]
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("82t41kovkganbgh")

  // remove
  collection.schema.removeField("yxlnxdmp")

  return dao.saveCollection(collection)
})
