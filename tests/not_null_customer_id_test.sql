select customer_id from {{ ref("stg_jaffle_shop__customers") }} where customer_id is null
