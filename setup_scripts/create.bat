psql -h localhost -U postgres -f create_schema.sql postgres
psql -h localhost -U postgres -f create.sql postgres
psql -h localhost -U postgres -f create_functions.sql postgres
psql -h localhost -U postgres -f create_view.sql postgres
..\src\DataRetriever\bin\Debug\DataRetriever.exe 500