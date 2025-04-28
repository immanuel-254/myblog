-- +goose Up
-- +goose StatementBegin
CREATE OR REPLACE FUNCTION auth.create_user(email varchar, password varchar)
    RETURNS uuid
    LANGUAGE sql
AS $BODY$
    INSERT INTO auth.users (email, password)
    VALUES (email, crypt(password, gen_salt('bf', 10)))
    RETURNING id;
$BODY$;

ALTER FUNCTION auth.create_user(varchar, varchar)
    OWNER TO postgres;

CREATE OR REPLACE FUNCTION auth.create_staff(email varchar, password varchar)
    RETURNS uuid
    LANGUAGE sql
AS $BODY$
    INSERT INTO auth.users (email, password, staff)
    VALUES (email, crypt(password, gen_salt('bf', 10)), TRUE)
    RETURNING id;
$BODY$;

ALTER FUNCTION auth.create_staff(varchar, varchar)
    OWNER TO postgres;

CREATE OR REPLACE FUNCTION auth.create_admin(email varchar, password varchar)
    RETURNS uuid
    LANGUAGE sql
AS $BODY$
    INSERT INTO auth.users (email, password, staff, admin)
    VALUES (email, crypt(password, gen_salt('bf', 10)), TRUE, TRUE)
    RETURNING id;
$BODY$;

ALTER FUNCTION auth.create_admin(varchar, varchar)
    OWNER TO postgres;
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
-- +goose StatementEnd
