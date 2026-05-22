-- Runs during first database init (empty PGDATA), after upstream init scripts.
-- Idempotent: safe if upstream or another run already created an extension.

CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
CREATE EXTENSION IF NOT EXISTS pg_buffercache;
CREATE EXTENSION IF NOT EXISTS pg_visibility;
CREATE EXTENSION IF NOT EXISTS pgstattuple;
