 with payments as (
        select id as payment_id, 
        orderid as order_id, 
        paymentmethod as payment_method,
        status,
        created as created_at, 
        amount / 100 as amount
        from {{ source("stripe","payment")}}
    )

    select * from payments