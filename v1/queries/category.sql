-- name: CreateCategory :one
INSERT INTO public."Category" (
    title,
    image,
    author,
    published
)
VALUES (
    $1, 
    $2,  
    $3,  
    $4
)
RETURNING id;

-- name: ReadCategory :one
SELECT 
    c.id AS category_id,
    c.title AS category_title,
    c.image AS category_image,
    c.author AS category_author,
    c.published AS category_published,
    c.created_at AS category_created_at,
    c.updated_at AS category_updated_at,

    COALESCE(
        STRING_AGG(
            DISTINCT 
            CONCAT(
                '{"id":', blog.id, 
                ',"title":', blog.title, 
                ',"image":', blog.image,
                ',"body":', blog.body,
                ',"published":', blog.published,
                ',"created_at":', blog.created_at,    
                ',"updated_at":"', blog.updated_at, '"}'
            ),
            ','
        )::TEXT, '[]'
    ) AS categories
FROM public.category_published_view c
LEFT JOIN public."Blog_Category" cb ON c.id = cb.category_id
LEFT JOIN public.blog_published_view blog ON cb.blog_id = blog.id
WHERE c.id = $1;

-- name: ListCategory :many
SELECT 
    c.id AS category_id,
    c.title AS category_title,
    c.image AS category_image,
    c.author AS category_author,
    c.published AS category_published,
    c.created_at AS category_created_at,
    c.updated_at AS category_updated_at,

    COALESCE(
        STRING_AGG(
            DISTINCT 
            CONCAT(
                '{"id":', blog.id, 
                ',"title":', blog.title, 
                ',"image":', blog.image,
                ',"body":', blog.body,
                ',"published":', blog.published,
                ',"created_at":', blog.created_at,    
                ',"updated_at":"', blog.updated_at, '"}'
            ),
            ','
        )::TEXT, '[]'
    ) AS categories
FROM public.category_published_view c
LEFT JOIN public."Blog_Category" cb ON c.id = cb.category_id
LEFT JOIN public.blog_published_view blog ON cb.blog_id = blog.id;

-- name: UpdateCategory :one
UPDATE public."Category"
SET 
    title = $2,         
    image = $3,         
    published = $4,     
    updated_at = NOW()  
WHERE id = $1           
RETURNING id;

-- name: DeleteCategory :exec
DELETE FROM public."Category" WHERE id = $1;
