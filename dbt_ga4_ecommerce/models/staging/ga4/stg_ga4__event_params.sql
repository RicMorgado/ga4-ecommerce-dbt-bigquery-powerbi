with events_base as (

    select
        event_key,
        event_date,
        event_timestamp_utc,
        event_name,
        user_pseudo_id,
        source_table_suffix,
        event_params

    from {{ ref('stg_ga4__events_base') }}

),

flattened_event_params as (

    select
        events_base.event_key,
        events_base.event_date,
        events_base.event_timestamp_utc,
        events_base.event_name,
        events_base.user_pseudo_id,
        events_base.source_table_suffix,

        event_param_index,
        event_param.key as event_param_key,

        event_param.value.string_value as event_param_string_value,
        event_param.value.int_value as event_param_int_value,
        event_param.value.float_value as event_param_float_value,
        event_param.value.double_value as event_param_double_value,

        case
            when event_param.value.string_value is not null then 'string'
            when event_param.value.int_value is not null then 'int'
            when event_param.value.float_value is not null then 'float'
            when event_param.value.double_value is not null then 'double'
            else 'unknown'
        end as event_param_value_type,

        coalesce(
            event_param.value.string_value,
            cast(event_param.value.int_value as string),
            cast(event_param.value.float_value as string),
            cast(event_param.value.double_value as string)
        ) as event_param_value_as_string

    from events_base

    cross join unnest(events_base.event_params) as event_param with offset as event_param_index

),

final as (

    select
        to_hex(md5(concat(
            event_key, '|',
            cast(event_param_index as string), '|',
            coalesce(event_param_key, 'unknown_param')
        ))) as event_param_key_id,

        *

    from flattened_event_params

)

select *
from final