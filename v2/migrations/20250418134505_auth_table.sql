-- +goose Up
-- +goose StatementBegin
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE auth.users (
	id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(100) NOT NULL,
    password VARCHAR(48) NOT NULL,
	active BOOLEAN DEFAULT TRUE NOT NULL,
	admin BOOLEAN DEFAULT FALSE NOT NULL,
	staff BOOLEAN DEFAULT FALSE NOT NULL,
	email_confirmed_at TIMESTAMP,
    created TIMESTAMP DEFAULT NOW() NOT NULL,
	updated TIMESTAMP DEFAULT NOW() NOT NULL
);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
-- +goose StatementEnd
