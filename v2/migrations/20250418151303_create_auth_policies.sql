-- +goose Up
-- +goose StatementBegin
CREATE POLICY user_select_own ON auth.users
FOR SELECT
TO active_role
USING (id = current_setting('user.id')::UUID AND active = TRUE);

CREATE POLICY user_update_own ON auth.users
FOR UPDATE
TO active_role
USING (id = current_setting('user.id')::UUID AND active = TRUE);

CREATE POLICY user_delete_own ON auth.users
FOR DELETE
TO active_role
USING (id = current_setting('user.id')::UUID AND active = TRUE);

CREATE POLICY user_all ON auth.users
FOR ALL
TO admin_role
USING (active = TRUE AND admin = TRUE);

CREATE POLICY user_select_staff ON auth.users
FOR SELECT
TO staff_role
USING (active = TRUE AND staff = TRUE);

CREATE POLICY user_update_staff ON auth.users
FOR UPDATE
TO staff_role
USING (active = TRUE AND staff = TRUE);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
-- +goose StatementEnd
