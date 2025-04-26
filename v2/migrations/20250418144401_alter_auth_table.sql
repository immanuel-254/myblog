-- +goose Up
-- +goose StatementBegin
ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
-- +goose StatementEnd
