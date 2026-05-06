-- Migration: 0001_initial
-- Creates the four core tables for Career OS:
--   person        – singleton profile row (one row, ever)
--   employer      – companies worked at or being tracked
--   role          – positions held at employers
--   activity_event – append-only log of career events

-- person: singleton; only one row is ever inserted
CREATE TABLE IF NOT EXISTS person (
    id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    name        text        NOT NULL,
    email       text,
    location    text,
    summary     text,
    created_at  timestamptz NOT NULL DEFAULT now(),
    updated_at  timestamptz NOT NULL DEFAULT now(),
    deleted_at  timestamptz
);

-- employer: companies worked at or actively tracked
CREATE TABLE IF NOT EXISTS employer (
    id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    name        text        NOT NULL,
    industry    text,
    size_range  text,
    location    text,
    summary     text,
    created_at  timestamptz NOT NULL DEFAULT now(),
    updated_at  timestamptz NOT NULL DEFAULT now(),
    deleted_at  timestamptz
);

-- role: positions held; ended_at NULL means current role
CREATE TABLE IF NOT EXISTS role (
    id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    employer_id uuid        NOT NULL REFERENCES employer(id) ON DELETE RESTRICT,
    title       text        NOT NULL,
    level       text,
    started_at  date,
    ended_at    date,
    summary     text,
    created_at  timestamptz NOT NULL DEFAULT now(),
    updated_at  timestamptz NOT NULL DEFAULT now(),
    deleted_at  timestamptz
);

-- activity_event: append-only career log.
-- No updated_at or deleted_at: events are immutable facts.
-- Corrections are recorded as new events, never by editing history.
CREATE TABLE IF NOT EXISTS activity_event (
    id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    occurred_at timestamptz NOT NULL DEFAULT now(),
    kind        text        NOT NULL,  -- e.g. 'shipped', 'learned', 'decided', 'failed', 'won'
    summary     text        NOT NULL,
    payload     jsonb,
    tags        text[],
    created_at  timestamptz NOT NULL DEFAULT now()
);
