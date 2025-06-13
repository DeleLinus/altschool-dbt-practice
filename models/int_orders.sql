{{config(materialized="table")}}

with
    orders as (select * from {{ ref("stg_jaffle_shop__orders") }} ),
    payments as (select * from {{ ref("stg_stripes__payment") }} ),
    order_payments as (
        select order_id,
                sum(case when payment_method = 'coupon' then amount end) as coupon_amount,
                sum(case when payment_method = 'credit_card' then amount end) as credit_card_amount,
                sum(case when payment_method = 'bank_transfer' then amount end) as bank_transfer_amount, 
                sum(case when payment_method = 'gift_card' then amount end) as gift_card_amount,
                sum(case when status = 'success' then amount end) as total_amount
        from payments group by order_id
    ),

    final as (
        select 
            o.order_id, o.customer_id,
            o.order_date, o.status, 
            op.coupon_amount, op.gift_card_amount,
            op.credit_card_amount, op.bank_transfer_amount,
            op.total_amount
        from orders as o left join payments as p on o.order_id = p.order_id
        left join order_payments as op on o.order_id = op.order_id
    )

    select * from final