with

source as (

    select * from {{ source('league_raw','match_objectives') }}

),

renamed as (

    select
        match_id,

        case
            when team_id = 100
            then 'blue'
            else 'red'
        end as side,

        is_my_team,
        is_first_dragon as killed_first_dragon,
        total_dragon_kills,
        total_baron_kills,
        total_grub_kills,
        rift_herald_kills,
        atakhan_kills

        from source

)

select * from renamed