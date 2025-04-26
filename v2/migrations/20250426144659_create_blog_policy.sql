-- +goose Up
-- +goose StatementBegin
CREATE POLICY article_update_own ON blog.articles
FOR UPDATE
TO staff_role
USING (
    author = current_setting('user.id')::UUID
    AND EXISTS (
        SELECT 1
        FROM auth.users
        WHERE auth.users.id = current_setting('user.id')::UUID
        AND auth.users.active = TRUE
        AND auth.users.staff = TRUE
    ));

CREATE POLICY article_delete_own ON blog.articles
FOR DELETE
TO staff_role
USING (
    author = current_setting('user.id')::UUID
    AND EXISTS (
        SELECT 1
        FROM auth.users
        WHERE auth.users.id = current_setting('user.id')::UUID
        AND auth.users.active = TRUE
        AND auth.users.staff = TRUE
    ));

CREATE POLICY article_all ON blog.articles
FOR ALL
TO admin_role
USING (
    EXISTS (
        SELECT 1
        FROM auth.users
        WHERE auth.users.id = current_setting('user.id')::UUID
        AND auth.users.active = TRUE
        AND auth.users.admin = TRUE
    )
);

-- category

CREATE POLICY category_update_own ON blog.categories
FOR UPDATE
TO staff_role
USING (
    author = current_setting('user.id')::UUID
    AND EXISTS (
        SELECT 1
        FROM auth.users
        WHERE auth.users.id = current_setting('user.id')::UUID
        AND auth.users.active = TRUE
        AND auth.users.staff = TRUE
    ));

CREATE POLICY category_delete_own ON blog.categories
FOR DELETE
TO staff_role
USING (
    author = current_setting('user.id')::UUID
    AND EXISTS (
        SELECT 1
        FROM auth.users
        WHERE auth.users.id = current_setting('user.id')::UUID
        AND auth.users.active = TRUE
        AND auth.users.staff = TRUE
    ));

CREATE POLICY category_all ON blog.categories
FOR ALL
TO admin_role
USING (
    EXISTS (
        SELECT 1
        FROM auth.users
        WHERE auth.users.id = current_setting('user.id')::UUID
        AND auth.users.active = TRUE
        AND auth.users.admin = TRUE
    )
);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
-- +goose StatementEnd
