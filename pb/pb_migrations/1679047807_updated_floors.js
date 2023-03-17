migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("82t41kovkganbgh")

  collection.viewRule = ""

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "t877larh",
    "name": "field",
    "type": "text",
    "required": false,
    "unique": false,
    "options": {
      "min": null,
      "max": null,
      "pattern": ""
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("82t41kovkganbgh")

  collection.viewRule = null

  // remove
  collection.schema.removeField("t877larh")

  return dao.saveCollection(collection)
})
