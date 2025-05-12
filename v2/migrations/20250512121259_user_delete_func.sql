-- +goose Up
-- +goose StatementBegin

CREATE OR REPLACE FUNCTION auth.delete_user(target_user_id UUID, new_email VARCHAR)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Check if the caller is a active user
  IF (SELECT active FROM auth.users WHERE id = current_setting('user.id')::UUID) = TRUE AND target_user_id = current_setting('user.id')::UUID THEN
    -- Staff can update email for non-staff users
    DELETE FROM auth.users
    WHERE id = target_user_id
      AND active = TRUE
      AND admin = FALSE; 
    IF NOT FOUND THEN
      RAISE EXCEPTION 'User not found, not active, or is a admin user';
    END IF;
  END IF;
  
  RETURN;
END;
$$;

ALTER FUNCTION auth.delete_user(UUID, VARCHAR) OWNER TO postgres;

-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
-- +goose StatementEnd
