psql -h localhost -U postgres -f drop.sql postgres
psql -h localhost -U postgres -f create_schema.sql postgres
psql -h localhost -U postgres -f create.sql postgres
psql -h localhost -U postgres -f create_trigger.sql postgres
..\src\DataRetriever\bin\Debug\DataRetriever.exe 50