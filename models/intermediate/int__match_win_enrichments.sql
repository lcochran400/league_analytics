with

matches as (

    select * from {{ ref('stg_matches')}}

),

match_result as (

    select distinct
        match_id,
        win
    
    from {{ ref('stg_participants')}}

),

joined as (

    select
        matches.*,
        match_result.win
    
    from matches
    left join match_result
        on matches.match_id = match_result.match_id

)

select * from joined