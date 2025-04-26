-- +goose Up
-- +goose StatementBegin
GRANT ALL ON SCHEMA auth TO admin_role;
GRANT ALL ON SCHEMA blog TO admin_role;
GRANT ALL ON SCHEMA public TO admin_role;
-- +goose StatementEnd
-- +goose Down
-- +goose StatementBegin
-- +goose StatementEnd
