migrate((db) => {
  const collection = new Collection({
    "id": "yhrkdo0oicldako",
    "created": "2023-03-17 10:04:12.172Z",
    "updated": "2023-03-17 10:04:12.172Z",
    "name": "rooms",
    "type": "base",
    "system": false,
    "schema": [
      {
        "system": false,
        "id": "tcpxpyvf",
        "name": "title",
        "type": "text",
        "required": false,
        "unique": false,
        "options": {
          "min": null,
          "max": null,
          "pattern": ""
        }
      },
      {
        "system": false,
        "id": "udc5kyky",
        "name": "floor",
        "type": "relation",
        "required": true,
        "unique": false,
        "options": {
          "collectionId": "82t41kovkganbgh",
          "cascadeDelete": false,
          "minSelect": null,
          "maxSelect": 1,
          "displayFields": [
            "title"
          ]
        }
      },
      {
        "system": false,
        "id": "tpcoflom",
        "name": "status",
        "type": "bool",
        "required": false,
        "unique": false,
        "options": {}
      }
    ],
    "listRule": "status = true",
    "viewRule": null,
    "createRule": null,
    "updateRule": null,
    "deleteRule": null,
    "options": {}
  });

  return Dao(db).saveCollection(collection);
}, (db) => {
  const dao = new Dao(db);
  const collection = dao.findCollectionByNameOrId("yhrkdo0oicldako");

  return dao.deleteCollection(collection);
})
