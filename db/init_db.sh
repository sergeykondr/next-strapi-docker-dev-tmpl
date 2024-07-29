#!/bin/bash

set -e

# Directory with database dumps
DUMP_DIR=/dump_importing
IMPORTED_DIR=/dump_importing/imported

# Ensure the imported directory exists
mkdir -p "$IMPORTED_DIR"

# Find the first file in the dump directory
DUMP_FILE=$(find "$DUMP_DIR" -maxdepth 1 -type f | head -n 1)

# Check if a dump file is found and import it
if [ -n "$DUMP_FILE" ]; then
  echo "Dump file found: $DUMP_FILE"
  echo "Restoring database..."

  # Drop all tables in the database
  psql -U $POSTGRES_USER -d $POSTGRES_DB -c "DROP SCHEMA public CASCADE"
  psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE SCHEMA public"

  # Restore the database
  if [[ "$DUMP_FILE" == *.gz ]]; then
    gunzip -c "$DUMP_FILE" | pg_restore -U $POSTGRES_USER -d $POSTGRES_DB -v
  else
    pg_restore -U $POSTGRES_USER -d $POSTGRES_DB -v "$DUMP_FILE"
  fi

  # Move the dump file to the imported directory
  mv "$DUMP_FILE" "$IMPORTED_DIR/"
  echo "Database restored successfully and file moved to $IMPORTED_DIR/"
else
  echo "No suitable dump file found, skipping restore."
fi

# Start the main postgres process
exec "$@"