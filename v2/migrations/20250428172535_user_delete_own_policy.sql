-- +goose Up
-- +goose StatementBegin
CREATE POLICY user_delete_own ON auth.users
FOR DELETE
TO active_role
USING (id = current_setting('user.id')::UUID AND active = TRUE);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
-- +goose StatementEnd
