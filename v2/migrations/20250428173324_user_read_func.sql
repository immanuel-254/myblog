-- +goose Up
-- +goose StatementBegin
CREATE OR REPLACE FUNCTION auth.login_user(p_email varchar, p_password varchar)
    RETURNS uuid
    LANGUAGE sql
AS $BODY$
    SELECT id
    FROM auth.users
    WHERE email = p_email
    AND crypt(p_password, password) = password
    AND active = TRUE
    LIMIT 1;
$BODY$;

ALTER FUNCTION auth.login_user(varchar, varchar)
    OWNER TO postgres;

CREATE OR REPLACE FUNCTION auth.read_user_by_email(p_email varchar)
    RETURNS TABLE (
        id UUID,
        email VARCHAR,
        active BOOLEAN,    
        staff BOOLEAN,    
        admin BOOLEAN,
        created TIMESTAMP,    
        updated TIMESTAMP    
        )
    LANGUAGE sql
AS $BODY$
    SELECT id, email, active, staff, admin, created, updated
    FROM auth.users
    WHERE email = p_email
    LIMIT 1;
$BODY$;

ALTER FUNCTION auth.read_user_by_email(varchar)
    OWNER TO postgres;

CREATE OR REPLACE FUNCTION auth.read_user(p_id uuid)
    RETURNS TABLE (
        id UUID,
        email VARCHAR,
        active BOOLEAN,    
        staff BOOLEAN,    
        admin BOOLEAN,
        created TIMESTAMP,    
        updated TIMESTAMP    
        )
    LANGUAGE sql
AS $BODY$
    SELECT id, email, active, staff, admin, created, updated
    FROM auth.users
    WHERE id = p_id
    LIMIT 1;
$BODY$;

ALTER FUNCTION auth.read_user(uuid)
    OWNER TO postgres;

-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
-- +goose StatementEnd
