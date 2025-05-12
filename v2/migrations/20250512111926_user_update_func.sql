-- +goose Up
-- +goose StatementBegin

CREATE OR REPLACE FUNCTION auth.change_user_email(target_user_id UUID, new_email VARCHAR)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Check if the caller is a active user
  IF (SELECT active FROM auth.users WHERE id = current_setting('user.id')::UUID) = TRUE THEN
    -- Staff can update email for non-staff users
    UPDATE auth.users
    SET email = new_email
    WHERE id = target_user_id
      AND active = TRUE
      AND staff = FALSE; -- Only non-staff users
    IF NOT FOUND THEN
      RAISE EXCEPTION 'User not found, not active, or is a staff user';
    END IF;
  ELSE
    -- Non-staff users can only update their own email
    IF target_user_id = current_setting('user.id')::UUID THEN
      UPDATE auth.users
      SET email = new_email
      WHERE id = target_user_id
        AND active = TRUE;
      IF NOT FOUND THEN
        RAISE EXCEPTION 'User not found or not active';
      END IF;
    ELSE
      RAISE EXCEPTION 'Non-staff users can only update their own email';
    END IF;
  END IF;
  
  RETURN target_user_id;
END;
$$;

ALTER FUNCTION auth.change_user_email(UUID, VARCHAR) OWNER TO postgres;

CREATE OR REPLACE FUNCTION auth.change_user_password(target_user_id UUID, old_password VARCHAR, new_password VARCHAR)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Check if the caller is a active user
  IF (SELECT active FROM auth.users WHERE id = current_setting('user.id')::UUID) = TRUE AND target_user_id = current_setting('user.id')::UUID THEN
    -- Staff can update email for non-staff users
    UPDATE auth.users
    SET password = crypt(new_password, gen_salt('bf', 10))
    WHERE id = target_user_id
      AND active = TRUE
      AND staff = FALSE
      AND crypt(old_password, password) = password;
    IF NOT FOUND THEN
      RAISE EXCEPTION 'User not found, not active, or is a staff user';
    END IF;
    END IF;

  RETURN target_user_id;
END;
$$;

ALTER FUNCTION auth.change_user_password(UUID, VARCHAR, VARCHAR) OWNER TO postgres;

CREATE OR REPLACE FUNCTION auth.change_user_active(target_user_id UUID, active_status BOOLEAN)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Check if the caller is a staff or admin user
  IF (SELECT staff FROM auth.users WHERE id = current_setting('user.id')::UUID) = TRUE OR (SELECT ADMIN FROM auth.users WHERE id = current_setting('user.id')::UUID) = TRUE THEN
    -- Staff can update email for non-staff users
    UPDATE auth.users
    SET active = active_status
    WHERE id = target_user_id
      AND active = TRUE
      AND staff = FALSE -- Only non-staff users
        AND admin = FALSE;
    IF NOT FOUND THEN
      RAISE EXCEPTION 'User not found, not active, or is a staff user';
    END IF;
    END IF;  
  RETURN target_user_id;
END;
$$;

ALTER FUNCTION auth.change_user_active(UUID, BOOLEAN) OWNER TO postgres;

CREATE OR REPLACE FUNCTION auth.change_staff_active(target_user_id UUID, active_status BOOLEAN)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Check if the caller admin user
  IF (SELECT admin FROM auth.users WHERE id = current_setting('user.id')::UUID) = TRUE THEN
    UPDATE auth.users
    SET active = active_status
    WHERE id = target_user_id
      AND staff = TRUE
        AND admin = FALSE;
    IF NOT FOUND THEN
      RAISE EXCEPTION 'User not found, not staff';
    END IF;  
    END IF;
  RETURN target_user_id;
END;
$$;

ALTER FUNCTION auth.change_staff_active(UUID, BOOLEAN) OWNER TO postgres;

CREATE OR REPLACE FUNCTION auth.change_staff_active(target_user_id UUID, active_status BOOLEAN)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Check if the caller admin user
  IF (SELECT admin FROM auth.users WHERE id = current_setting('user.id')::UUID) = TRUE THEN
    UPDATE auth.users
    SET active = active_status
    WHERE id = target_user_id
    AND admin = FALSE;
    IF NOT FOUND THEN
      RAISE EXCEPTION 'User not found, not staff';
    END IF;
    END IF;
  RETURN target_user_id;
END;
$$;

ALTER FUNCTION auth.change_staff_active(UUID, BOOLEAN) OWNER TO postgres;
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
-- +goose StatementEnd
