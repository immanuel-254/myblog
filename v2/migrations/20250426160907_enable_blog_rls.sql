-- +goose Up
-- +goose StatementBegin
ALTER TABLE blog.articles ENABLE ROW LEVEL SECURITY;
ALTER TABLE blog.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE blog.article_categories ENABLE ROW LEVEL SECURITY;
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
-- +goose StatementEnd
