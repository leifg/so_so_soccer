#!/bin/sh

echo "Creating read store"
mix ecto.create

echo "Migrating database"
mix ecto.migrate
