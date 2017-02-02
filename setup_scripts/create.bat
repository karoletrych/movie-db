psql -h localhost -U postgres -f create_schema.sql postgres
psql -h localhost -U postgres -f create.sql postgres
psql -h localhost -U postgres -f create_functions.sql postgres
psql -h localhost -U postgres -f create_view.sql postgres
psql -h localhost -U postgres -f create_constraints.sql postgres