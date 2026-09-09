-- EE476 weekly learning progress extension
--
-- Run this file ONCE in Supabase > SQL Editor after the original
-- lab-progress-supabase-setup.sql has been installed successfully.
-- It reuses the existing roster, profiles, progress table, RLS policies,
-- and instructor dashboard function. No student data is deleted.

begin;

-- ---------------------------------------------------------------------------
-- 1. Create two equally weighted activities for every week, W01 through W16.
-- ---------------------------------------------------------------------------
insert into public.lab_tasks (task_id, lab_id, task_order, title)
select
  format(
    'course-week-%s-%s',
    lpad(week_number::text, 2, '0'),
    activity.activity_key
  ) as task_id,
  'course-weekly' as lab_id,
  ((week_number - 1) * 2) + activity.activity_offset as task_order,
  format(
    'Week %s — %s',
    lpad(week_number::text, 2, '0'),
    activity.activity_title
  ) as title
from generate_series(1, 16) as weeks(week_number)
cross join (
  values
    ('slides', 1, 'Slides read'),
    ('homework', 2, 'Homework completed')
) as activity(activity_key, activity_offset, activity_title)
on conflict (task_id) do update set
  lab_id = excluded.lab_id,
  task_order = excluded.task_order,
  title = excluded.title;

-- ---------------------------------------------------------------------------
-- 2. Keep the generic instructor report correct when several task groups exist.
--    The extra task.task_id check prevents null values from entering the JSON.
-- ---------------------------------------------------------------------------
create or replace function public.instructor_lab_progress(requested_lab_id text)
returns table (
  roster_id bigint,
  roll_number text,
  full_name text,
  email text,
  activated boolean,
  completed_count bigint,
  completed_task_ids jsonb,
  last_update timestamptz
)
language plpgsql
stable
security definer
set search_path = public
as $$
begin
  if not public.current_user_is_instructor() then
    raise exception 'Instructor access is required.';
  end if;

  return query
  select
    roster.id as roster_id,
    roster.roll_number,
    roster.full_name,
    roster.email,
    profile.user_id is not null as activated,
    count(task.task_id)
      filter (where progress.completed is true and task.task_id is not null)
      as completed_count,
    coalesce(
      jsonb_agg(task.task_id order by task.task_order)
        filter (where progress.completed is true and task.task_id is not null),
      '[]'::jsonb
    ) as completed_task_ids,
    max(progress.updated_at)
      filter (where task.task_id is not null)
      as last_update
  from public.course_roster as roster
  left join public.profiles as profile
    on profile.roster_id = roster.id
  left join public.lab_progress as progress
    on progress.user_id = profile.user_id
  left join public.lab_tasks as task
    on task.task_id = progress.task_id
   and task.lab_id = requested_lab_id
  where roster.role = 'student'
  group by
    roster.id,
    roster.roll_number,
    roster.full_name,
    roster.email,
    profile.user_id
  order by roster.roll_number, roster.full_name;
end;
$$;

revoke all on function public.instructor_lab_progress(text) from public;
grant execute on function public.instructor_lab_progress(text) to authenticated;

commit;
