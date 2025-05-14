-- +goose Up
-- +goose StatementBegin

CREATE OR REPLACE FUNCTION auth.update_timestamp()
    RETURNS TRIGGER
    LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated = NOW();
    RETURN NEW;
END;
$$;

-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
-- +goose StatementEnd
