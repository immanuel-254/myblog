create policy "Enable delete for users based on user_id"
on "public"."Blog"
as permissive
for delete
to authenticated
using ((( SELECT auth.uid() AS uid) = author));


create policy "Enable read access for all users"
on "public"."Blog"
as permissive
for select
to authenticated, anon, dashboard_user
using (true);


create policy "Enable update for users based on email"
on "public"."Blog"
as permissive
for update
to authenticated
using ((( SELECT auth.uid() AS uid) = author))
with check ((( SELECT auth.uid() AS uid) = author));


create policy "Enable delete for users based on user_id"
on "public"."Blog_Category"
as permissive
for delete
to authenticated
using (true);


create policy "Enable delete for users based on user_id"
on "public"."Category"
as permissive
for delete
to public
using ((( SELECT auth.uid() AS uid) = author));


create policy "Enable read access for all users"
on "public"."Category"
as permissive
for select
to authenticated, anon, dashboard_user
using (true);


create policy "Enable update for users based on email"
on "public"."Category"
as permissive
for update
to authenticated
using ((( SELECT auth.uid() AS uid) = author))
with check ((( SELECT auth.uid() AS uid) = author));


create policy "Enable read access for all users"
on "public"."Logs"
as permissive
for select
to dashboard_user, supabase_admin
using (true);



