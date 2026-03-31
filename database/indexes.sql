CREATE INDEX idx_notes_user_id     ON notes(user_id);
CREATE INDEX idx_notes_user_active ON notes(user_id, updated_at DESC, id DESC)
    WHERE deleted_at IS NULL;
CREATE INDEX idx_tags_user_id      ON tags(user_id);
CREATE INDEX idx_note_tags_tag_id  ON note_tags(tag_id);
CREATE INDEX idx_notes_search      ON notes USING GIN(search_vector);
