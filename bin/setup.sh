#!/bin/sh

echo "Creating EventSourced Writestore"
mix do event_store.create, event_store.init

echo "Creating CRUD/read database"
mix ecto.create

echo "Migrating CRUD/read database"
mix ecto.migrate
