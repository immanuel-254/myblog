-- +goose Up
-- +goose StatementBegin
CREATE OR REPLACE FUNCTION auth.all_user(p_page_number INTEGER, p_page_size INTEGER)
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
    ORDER BY id
    LIMIT p_page_size
    OFFSET (p_page_number - 1) * p_page_size;
$BODY$;

ALTER FUNCTION auth.all_user(INTEGER, INTEGER)
    OWNER TO postgres;

-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
-- +goose StatementEnd
