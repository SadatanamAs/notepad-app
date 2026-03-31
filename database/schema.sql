-- ============================================================
-- 1. USERS
-- ============================================================
CREATE TABLE users (
    id            BIGSERIAL    PRIMARY KEY,
    email         VARCHAR(255) NOT NULL UNIQUE
                    CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    username      VARCHAR(50)  NOT NULL UNIQUE
                    CHECK (LENGTH(TRIM(username)) >= 3),
    password_hash VARCHAR(255) NOT NULL
                    CHECK (LENGTH(password_hash) > 0),
    is_active     BOOLEAN      NOT NULL DEFAULT true,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- ============================================================
-- 2. NOTES
-- ============================================================
CREATE TABLE notes (
    id            BIGSERIAL    PRIMARY KEY,
    user_id       BIGINT       NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title         VARCHAR(500) NOT NULL
                    CHECK (LENGTH(TRIM(title)) > 0),
    body          TEXT,
    is_pinned     BOOLEAN      NOT NULL DEFAULT false,
    deleted_at    TIMESTAMPTZ,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),

    search_vector TSVECTOR GENERATED ALWAYS AS (
        setweight(to_tsvector('english', COALESCE(title, '')), 'A') ||
        setweight(to_tsvector('english', COALESCE(body,  '')),  'B')
    ) STORED,

    CHECK (deleted_at IS NULL OR deleted_at > created_at)
);

-- ============================================================
-- 3. TAGS
-- ============================================================
CREATE TABLE tags (
    id         BIGSERIAL    PRIMARY KEY,
    user_id    BIGINT       NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name       VARCHAR(100) NOT NULL
                 CHECK (LENGTH(TRIM(name)) > 0),
    created_at TIMESTAMPTZ  NOT NULL DEFAULT NOW(),

    UNIQUE(user_id, name)
);

-- ============================================================
-- 4. NOTE_TAGS (junction)
-- ============================================================
CREATE TABLE note_tags (
    note_id BIGINT NOT NULL REFERENCES notes(id) ON DELETE CASCADE,
    tag_id  BIGINT NOT NULL REFERENCES tags(id)  ON DELETE CASCADE,

    PRIMARY KEY (note_id, tag_id)
);
