-- +goose Up
-- +goose StatementBegin

CREATE OR REPLACE FUNCTION auth.change_user_all_active(target_user_ids UUID[], active_status BOOLEAN)
    RETURNS INTEGER
    LANGUAGE plpgsql
    SECURITY DEFINER
AS $$
DECLARE
    v_caller_id UUID;
    v_updated_count INTEGER;
BEGIN
    -- Validate user.id setting
    BEGIN
        v_caller_id := current_setting('user.id')::UUID;
    EXCEPTION
        WHEN INVALID_TEXT_REPRESENTATION THEN
            RAISE EXCEPTION 'Invalid UUID format for user.id: %', current_setting('user.id');
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Error retrieving user.id: %', SQLERRM;
    END;

    -- Check if caller is active staff or admin
    IF NOT (SELECT staff OR admin FROM auth.users WHERE id = v_caller_id AND active = TRUE) THEN
        Raise Exception 'Caller must be an active staff or admin user';
    END IF;

    -- Check for empty input
    IF array_length(target_user_ids, 1) IS NULL OR array_length(target_user_ids, 1) = 0 THEN
        RAISE EXCEPTION 'Target user IDs array is empty';
    END IF;

    -- Update non-staff, non-admin users
    UPDATE auth.users
    SET active = active_status
    WHERE id = ANY(target_user_ids)
      AND staff = FALSE
      AND admin = FALSE;

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    -- Check if any rows were updated
    IF v_updated_count = 0 THEN
        RAISE EXCEPTION 'No users updated: target users either do not exist or are staff/admin';
    END IF;

    RETURN v_updated_count;
END;
$$;

ALTER FUNCTION auth.change_user_all_active(UUID[], BOOLEAN)
    OWNER TO postgres;

CREATE OR REPLACE FUNCTION auth.change_user_all_staff(target_user_ids UUID[], staff_status BOOLEAN)
    RETURNS INTEGER
    LANGUAGE plpgsql
    SECURITY DEFINER
AS $$
DECLARE
    v_caller_id UUID;
    v_updated_count INTEGER;
BEGIN
    -- Validate user.id setting
    BEGIN
        v_caller_id := current_setting('user.id')::UUID;
    EXCEPTION
        WHEN INVALID_TEXT_REPRESENTATION THEN
            RAISE EXCEPTION 'Invalid UUID format for user.id: %', current_setting('user.id');
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Error retrieving user.id: %', SQLERRM;
    END;

    -- Check if caller is active admin
    IF NOT (SELECT admin FROM auth.users WHERE id = v_caller_id AND active = TRUE) THEN
        RAISE EXCEPTION 'Caller must be an active admin user';
    END IF;

    -- Check for empty input
    IF array_length(target_user_ids, 1) IS NULL OR array_length(target_user_ids, 1) = 0 THEN
        RAISE EXCEPTION 'Target user IDs array is empty';
    END IF;

    -- Update non-staff, non-admin users
    UPDATE auth.users
    SET staff = staff_status
    WHERE id = ANY(target_user_ids)
      AND staff = FALSE
      AND admin = FALSE;

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    -- Check if any rows were updated
    IF v_updated_count = 0 THEN
        RAISE EXCEPTION 'No users updated: target users either do not exist or are staff/admin';
    END IF;

    RETURN v_updated_count;
END;
$$;

ALTER FUNCTION auth.change_user_all_staff(UUID[], BOOLEAN)
    OWNER TO postgres;

-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
-- +goose StatementEnd
