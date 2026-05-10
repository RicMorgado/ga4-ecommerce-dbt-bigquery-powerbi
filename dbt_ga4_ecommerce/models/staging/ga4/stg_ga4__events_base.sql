with source_events as (

    select
        _table_suffix as source_table_suffix,

        parse_date('%Y%m%d', event_date) as event_date,
        event_timestamp as event_timestamp_micros,
        timestamp_micros(event_timestamp) as event_timestamp_utc,

        event_name,
        event_previous_timestamp as event_previous_timestamp_micros,
        event_value_in_usd,
        event_bundle_sequence_id,
        event_server_timestamp_offset,

        user_id,
        user_pseudo_id,

        stream_id,
        platform,

        device.category as device_category,
        device.mobile_brand_name as device_mobile_brand_name,
        device.mobile_model_name as device_mobile_model_name,
        device.operating_system as device_operating_system,
        device.operating_system_version as device_operating_system_version,
        device.language as device_language,
        device.web_info.browser as browser,
        device.web_info.browser_version as browser_version,
        device.web_info.hostname as hostname,

        geo.continent as geo_continent,
        geo.country as geo_country,
        geo.region as geo_region,
        geo.city as geo_city,

        traffic_source.name as user_first_touch_source_name,
        traffic_source.medium as user_first_touch_medium,
        traffic_source.source as user_first_touch_source,

        ecommerce.total_item_quantity as ecommerce_total_item_quantity,
        ecommerce.purchase_revenue_in_usd as ecommerce_purchase_revenue_in_usd,
        ecommerce.purchase_revenue as ecommerce_purchase_revenue,
        ecommerce.unique_items as ecommerce_unique_items,
        ecommerce.transaction_id as transaction_id,

        event_params,
        user_properties,
        items

    from {{ source('ga4_ecommerce', 'events') }}

    where _table_suffix between '{{ var("ga4_start_date") }}'
                            and '{{ var("ga4_end_date") }}'

),

final as (

    select
        to_hex(md5(concat(
            coalesce(user_pseudo_id, 'unknown_user'), '|',
            cast(event_timestamp_micros as string), '|',
            coalesce(event_name, 'unknown_event'), '|',
            coalesce(cast(event_bundle_sequence_id as string), 'unknown_bundle'), '|',
            source_table_suffix
        ))) as event_key,

        *

    from source_events

)

select *
from final