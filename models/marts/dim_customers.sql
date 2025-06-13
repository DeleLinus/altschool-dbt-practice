{{ config(materialized="table") }}

with
    customers as (select * from {{ ref("stg_jaffle_shop__customers") }}),
    customer_orders as (select * from {{ ref("int_customer_orders_aggregated") }}),
    customer_payments as (select * from {{ ref("int_customer_payments_aggregated") }}),

    final as (
        select *
        from customers
        left join customer_orders using (customer_id)
        left join customer_payments using (customer_id)
    )

select *
from final
