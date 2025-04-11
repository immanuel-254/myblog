alter table "public"."Blog" drop constraint "Blog_image_fkey";

alter table "public"."Category" drop constraint "Category_image_fkey";

drop view if exists "public"."blog_draft_view";

drop view if exists "public"."blog_published_view";

drop view if exists "public"."category_draft_view";

drop view if exists "public"."category_published_view";

alter table "public"."Blog" alter column "image" drop default;

alter table "public"."Blog" alter column "image" set data type character varying using "image"::character varying;

alter table "public"."Category" alter column "image" drop default;

alter table "public"."Category" alter column "image" set data type character varying using "image"::character varying;

create or replace view "public"."blog_draft_view" as  SELECT "Blog".id,
    "Blog".created_at,
    "Blog".title,
    "Blog".image,
    "Blog".body,
    "Blog".author,
    "Blog".updated_at,
    "Blog".published
   FROM "Blog"
  WHERE ("Blog".published = false);


create or replace view "public"."blog_published_view" as  SELECT "Blog".id,
    "Blog".created_at,
    "Blog".title,
    "Blog".image,
    "Blog".body,
    "Blog".author,
    "Blog".updated_at,
    "Blog".published
   FROM "Blog"
  WHERE ("Blog".published = true);


create or replace view "public"."category_draft_view" as  SELECT "Category".id,
    "Category".created_at,
    "Category".updated_at,
    "Category".title,
    "Category".image,
    "Category".published,
    "Category".author
   FROM "Category"
  WHERE ("Category".published = false);


create or replace view "public"."category_published_view" as  SELECT "Category".id,
    "Category".created_at,
    "Category".updated_at,
    "Category".title,
    "Category".image,
    "Category".published,
    "Category".author
   FROM "Category"
  WHERE ("Category".published = true);



