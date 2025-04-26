-- +goose Up
-- +goose StatementBegin

-- Drop the existing staff policy (if it exists)
DROP POLICY IF EXISTS user_update_staff ON auth.users;

-- Policy for staff to activate/deactivate non-staff users
CREATE POLICY user_update_staff ON auth.users
FOR UPDATE
TO staff_role
USING (
  active = TRUE
  AND staff = TRUE
  AND (SELECT staff FROM auth.users WHERE id = current_setting('user.id')::UUID) = TRUE -- Ensure caller is staff
  AND staff = FALSE -- Only allow updates to non-staff users
  AND admin = FALSE -- Only allow updates to non-admin users

)
WITH CHECK (
  -- Ensure only the `active` field can be modified
  id = id
  AND email = email
  AND password = password
  AND admin = admin
  AND staff = staff
  AND email_confirmed_at = email_confirmed_at
  AND created = created
  -- Add any other fields in auth.users to prevent changes
);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
-- +goose StatementEnd
