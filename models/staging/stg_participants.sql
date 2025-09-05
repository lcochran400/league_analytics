with

source as (

    select * from {{ source('league_raw', 'match_participants')}}

),

renamed as (

    select
        match_id,
        participant_id,
        win,
        summoner_name,
        champion_name,
        role,

        case
            when team_id = 100
            then 'blue'
            else 'red'
        end as side,

        kills,
        deaths,
        assists,
        is_first_blood_kill,
        round(longest_time_living/60, 2) as longest_time_living,
        round(total_time_dead/60, 2) as total_time_dead,
        minion_cs as non_minion_farm,
        total_cs as minion_farm,
        non_minion_farm + minion_farm as total_farm,
        all_in_pings,
        assist_pings,
        mia_pings,
        get_back_pings,
        need_vision_pings,
        push_pings,
        turret_kills,
        turret_takedowns,
        dragon_kills,
        baron_kills,
        objectives_stolen,
        consumables_purchased,
        sight_wards_bought,
        vision_wards_bought,
        vision_score,
        wards_placed,
        pink_wards_placed,
        wards_killed

    from source

)

select * from renamed