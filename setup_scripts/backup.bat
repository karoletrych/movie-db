pg_dump  -h localhost -p 5432 -U postgres -F p -b -v -f "dump.sql" --data-only --column-inserts postgres