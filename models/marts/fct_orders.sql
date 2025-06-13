{{ config(materialized="table") }}

with
    orders as (select * from {{ ref("stg_jaffle_shop__orders") }}),
    order_payments as (select * from {{ ref("int_order_payments_pivoted") }}),

    final as (
        select
            o.order_id,
            o.customer_id,
            o.order_date,
            o.status,
            op.coupon_amount,
            op.gift_card_amount,
            op.credit_card_amount,
            op.bank_transfer_amount,
            op.total_amount
        from orders o
        left join order_payments op on o.order_id = op.order_id
    )

select *
from final
