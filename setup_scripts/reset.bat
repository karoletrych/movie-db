rem SET url=-h localhost -U postgres
SET url=postgres://mckkwsfs:LN6I-UIiHXA16XkjFtvBbA_x03Q6TeWs@elmer.db.elephantsql.com:5432/mckkwsfs


psql -f drop.sql %url% 
psql -f create_schema.sql %url% 
psql -f create.sql %url% 
psql -f create_functions.sql %url% 
psql -f create_view.sql %url% 
psql -f dump.sql %url% 
psql -f create_constraints.sql %url% 