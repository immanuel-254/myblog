-- +goose Up
-- +goose StatementBegin
CREATE POLICY user_all_admin ON auth.users
FOR ALL
TO admin_role
USING (active = TRUE AND admin = TRUE);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
-- +goose StatementEnd
