/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_3610008286")

  // remove field
  collection.fields.removeById("relation2635870233")

  // add field
  collection.fields.addAt(3, new Field({
    "hidden": false,
    "id": "json3012992423",
    "maxSize": 0,
    "name": "breakdown",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "json"
  }))

  // add field
  collection.fields.addAt(4, new Field({
    "hidden": false,
    "id": "number914873104",
    "max": null,
    "min": null,
    "name": "estimated_value",
    "onlyInt": false,
    "presentable": false,
    "required": false,
    "system": false,
    "type": "number"
  }))

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_3610008286")

  // add field
  collection.fields.addAt(2, new Field({
    "cascadeDelete": false,
    "collectionId": "pbc_653341844",
    "hidden": false,
    "id": "relation2635870233",
    "maxSelect": 1,
    "minSelect": 0,
    "name": "participant_id",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "relation"
  }))

  // remove field
  collection.fields.removeById("json3012992423")

  // remove field
  collection.fields.removeById("number914873104")

  return app.save(collection)
})
