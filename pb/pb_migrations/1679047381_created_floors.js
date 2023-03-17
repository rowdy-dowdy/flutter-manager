migrate((db) => {
  const collection = new Collection({
    "id": "82t41kovkganbgh",
    "created": "2023-03-17 10:03:01.445Z",
    "updated": "2023-03-17 10:03:01.445Z",
    "name": "floors",
    "type": "base",
    "system": false,
    "schema": [
      {
        "system": false,
        "id": "je0xxy9z",
        "name": "title",
        "type": "text",
        "required": true,
        "unique": true,
        "options": {
          "min": null,
          "max": null,
          "pattern": ""
        }
      },
      {
        "system": false,
        "id": "cxlwwhap",
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
  const collection = dao.findCollectionByNameOrId("82t41kovkganbgh");

  return dao.deleteCollection(collection);
})
