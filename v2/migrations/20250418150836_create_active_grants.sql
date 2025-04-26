-- +goose Up
-- +goose StatementBegin
GRANT USAGE ON SCHEMA auth TO active_role, admin_role, staff_role;
GRANT USAGE ON SCHEMA blog TO active_role, admin_role, staff_role;

CREATE FUNCTION auth.set_user_context(user_id UUID) RETURNS VOID AS $$
BEGIN
    PERFORM set_config('user.id', user_id::TEXT, true);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
GRANT EXECUTE ON FUNCTION auth.set_user_context(UUID) TO active_role, admin_role, staff_role;



-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
-- +goose StatementEnd
