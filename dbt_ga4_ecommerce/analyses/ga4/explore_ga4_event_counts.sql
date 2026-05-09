/*
Exploratory query: GA4 event counts by event name.

Purpose:
- Inspect available GA4 events.
- Confirm ecommerce funnel events exist.
- Estimate event volume and user reach before building staging models.

This query is intentionally stored as an analysis, not as a dbt model.
It does not create a table or view in BigQuery.
*/

select
    event_name,
    count(*) as event_count,
    count(distinct user_pseudo_id) as unique_users,
    min(parse_date('%Y%m%d', event_date)) as first_event_date,
    max(parse_date('%Y%m%d', event_date)) as last_event_date

from {{ source('ga4_ecommerce', 'events') }}

where _table_suffix between '{{ var("ga4_start_date") }}'
                        and '{{ var("ga4_end_date") }}'

group by
    event_name

order by
    event_count desc


    