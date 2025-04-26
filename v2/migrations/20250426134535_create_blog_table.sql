-- +goose Up
-- +goose StatementBegin
CREATE TABLE blog.categories (
	id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
	title VARCHAR(100) NOT NULL,
	author uuid REFERENCES auth.users(id) NOT NULL,
    image VARCHAR(100),
	description VARCHAR(200),
    created TIMESTAMP DEFAULT NOW() NOT NULL,
	updated TIMESTAMP DEFAULT NOW() NOT NULL
);

CREATE TABLE blog.articles (
	id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
	title VARCHAR(100) NOT NULL,
	author uuid REFERENCES auth.users(id) ON DELETE CASCADE,
    image VARCHAR(100),
    body TEXT NOT NULL,
	publish BOOLEAN DEFAULT FALSE NOT NULL,
    created TIMESTAMP DEFAULT NOW() NOT NULL,
	updated TIMESTAMP DEFAULT NOW() NOT NULL
);

CREATE TABLE blog.article_categories (
    article_id uuid REFERENCES blog.articles(id) ON DELETE CASCADE,
    category_id uuid REFERENCES blog.categories(id) ON DELETE CASCADE,
    PRIMARY KEY (article_id, category_id)
);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
-- +goose StatementEnd
