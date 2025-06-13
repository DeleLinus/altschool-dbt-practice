{{config(materialized="ephemeral")}}

{%- set payment_method = ['coupon', 'credit_card', 'bank_transfer', 'gift_card']-%} -- hyphen to remove trailing spaces

with
    orders as (select * from {{ ref("stg_jaffle_shop__orders") }} ),

    payments as (select * from {{ ref("stg_stripes__payment") }} ),

    order_payments as (
        select order_id,
                {% for method in payment_method -%}
                sum(case when payment_method = '{{ method }}' then amount end) as {{ method }}_amount,
                {% endfor -%}
        sum(case when status = 'success' then amount end) as total_amount
        from payments group by order_id
    )

    select * from order_payments