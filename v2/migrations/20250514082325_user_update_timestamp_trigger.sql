-- +goose Up
-- +goose StatementBegin

CREATE TRIGGER set_updated_timestamp
    BEFORE UPDATE ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION auth.update_timestamp();

-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
-- +goose StatementEnd
