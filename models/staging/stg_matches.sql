with

source as (
    
    select * from {{ source('league_raw', 'matches')}}

),

renamed as (

    select
        match_id,
        round(game_duration/60, 2) as game_duration,
        patch_version
    
    from source

)

select * from renamed