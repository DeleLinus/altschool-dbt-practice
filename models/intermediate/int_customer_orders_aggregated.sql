{{config(materialized="ephemeral")}}

with
    orders as (
        select * from {{ ref("stg_jaffle_shop__orders")}}
    ),

    customer_orders as (
        select
            customer_id,
            min(order_date) as first_order_date,
            max(order_date) as last_order_date,
            count(order_id) as number_of_orders
        from orders
        group by customer_id
    )
    
    select * from customer_orders