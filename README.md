# stack-ops-infra

Infrastructure and database schema for Career OS.

## Structure

```
stack-ops-infra/
├── migrations/          # Sequential SQL migration files (e.g. 0001_initial.sql)
└── .github/
    └── workflows/       # GitHub Actions workflows (e.g. migrate.yml)
```

## Migration conventions

- Files named `NNNN_description.sql` (sequential, never edited after merge)
- Idempotent (`IF NOT EXISTS`) so re-runs are safe
- Applied in alphabetical order by the CI workflow
- Applied migrations tracked in a `schema_migrations` table

## Deploy flow

1. Create a feature branch
2. Add a migration file to `/migrations/`
3. Open a PR to `main`
4. Review and merge
5. GitHub Actions runs the migration against the `prod` environment (reads `DATABASE_URL` from the `prod` environment secret)
