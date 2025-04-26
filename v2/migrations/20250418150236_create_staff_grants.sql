-- +goose Up
-- +goose StatementBegin
GRANT ALL ON SCHEMA blog TO staff_role;
GRANT SELECT, UPDATE ON auth.users TO staff_role;
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
-- +goose StatementEnd
