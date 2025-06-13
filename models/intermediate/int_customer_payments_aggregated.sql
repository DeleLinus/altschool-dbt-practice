{{ config(materialized="ephemeral") }}

with
    orders as (
        select * from {{ ref("stg_jaffle_shop__orders")}}
    ),

    payments as (
        select * from {{ ref("stg_stripes__payment")}}
    ),
    customer_payments as (
        select orders.customer_id, sum(payments.amount) as total_amount
        from payments
        left join orders on payments.order_id = orders.order_id
        group by orders.customer_id
    )

    select * from customer_payments

