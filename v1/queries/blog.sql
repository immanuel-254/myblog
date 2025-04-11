-- name: CreateBlog :one
WITH new_blog AS (
    INSERT INTO public."Blog" (
        title,
        image,
        body,
        author,
        published
    )
    VALUES (
        $1, 
        $2,  
        $3,  
        $4,  
        $5  
    )
    RETURNING id
)
INSERT INTO public."Blog_Category" (
    blog_id,
    category_id
)
SELECT 
    new_blog.id,
    unnest($6::int8[]) AS category_id  
FROM new_blog
RETURNING blog_id AS id;

-- name: ReadBlog :one
SELECT 
    b.id AS blog_id,
    b.title AS blog_title,
    b.image AS blog_image,
    b.body AS blog_body,
    b.published AS blog_published,
    b.created_at AS blog_created_at,
    b.updated_at AS blog_updated_at,

    COALESCE(
        STRING_AGG(
            DISTINCT 
            CONCAT(
                '{"id":', cat.id, 
                ',"title":"', cat.title, '"}'
            ),
            ','
        )::TEXT, '[]'
    ) AS categories
FROM public.blog_published_view b
LEFT JOIN public."Blog_Category" cb ON b.id = cb.blog_id
LEFT JOIN public.category_published_view cat ON cb.category_id = cat.id
WHERE b.id = $1;

-- name: ListBlog :many
SELECT 
    b.id AS blog_id,
    b.title AS blog_title,
    b.image AS blog_image,
    b.body AS blog_body,
    b.published AS blog_published,
    b.created_at AS blog_created_at,
    b.updated_at AS blog_updated_at,

    COALESCE(
        STRING_AGG(
            DISTINCT 
            CONCAT(
                '{"id":', cat.id, 
                ',"title":"', cat.title, '"}'
            ),
            ','
        )::TEXT, '[]'
    ) AS categories
FROM public.blog_published_view b
LEFT JOIN public."Blog_Category" cb ON b.id = cb.blog_id
LEFT JOIN public.category_published_view cat ON cb.category_id = cat.id;

-- name: UpdateBlog :one
WITH updated_blog AS (
    UPDATE public."Blog"
    SET 
        title = $2,         
        image = $3,         
        body = $4,          
        published = $5,     
        updated_at = NOW()  
    WHERE public."Blog".id = $1           
    RETURNING public."Blog".id  -- Explicitly qualify the id here
),
delete_old_categories AS (
    DELETE FROM public."Blog_Category"
    WHERE blog_id = $1
)  
INSERT INTO public."Blog_Category" (
    blog_id,
    category_id,
    created_at
)
SELECT 
    updated_blog.id,
    unnest($6::int8[]) AS category_id,
    NOW()
FROM updated_blog
RETURNING blog_id AS id;  

-- name: DeleteBlog :exec
DELETE FROM public."Blog" WHERE id = $1;
