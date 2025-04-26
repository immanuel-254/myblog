-- +goose Up
-- +goose StatementBegin
CREATE ROLE active_role;
CREATE ROLE admin_role;
CREATE ROLE staff_role;
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
-- +goose StatementEnd
