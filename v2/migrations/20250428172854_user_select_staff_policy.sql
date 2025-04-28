-- +goose Up
-- +goose StatementBegin
CREATE POLICY user_select_staff ON auth.users
FOR SELECT
TO staff_role
USING (active = TRUE AND staff = TRUE);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
-- +goose StatementEnd
