psql -h localhost -U postgres -f drop.sql postgres
psql -h localhost -U postgres -f create_schema.sql postgres
psql -h localhost -U postgres -f create.sql postgres
