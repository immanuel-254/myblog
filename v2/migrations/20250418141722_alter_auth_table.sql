-- +goose Up
-- +goose StatementBegin
ALTER TABLE auth.users
ADD CONSTRAINT unique_email UNIQUE (email);
-- +goose StatementEnd
-- +goose Down
-- +goose StatementBegin
-- +goose StatementEnd
