BEGIN;
SET LOCAL user.id = $1;
-- select, update, insert or delete query
COMMIT; -- After commit, user.id reverts to its previous value

CREATE OR REPLACE FUNCTION update_article(user_id UUID, article_id UUID, new_title text)
RETURNS void AS $$
BEGIN
    SET LOCAL user.id = user_id;
    UPDATE blog.articles SET title = new_title WHERE id = article_id;
END;
$$ LANGUAGE plpgsql;

-- queries.sql
-- name: UpdateArticle :exec
SELECT update_article($1::UUID, $2::UUID, $3::TEXT);