with players as (

    select * from {{ ref('stg_participants')}}

),

enriched as (

    select
        match_id,

        case
            when team_id = 100
            then 'blue'
            else 'red'
        end as team_map_side,

        riot_id_game_name,
        champion_name,
        first_blood_kill,
        first_tower_kill,
        cs_first_10_minutes,
        total_minions_killed + neutral_minions_killed as total_cs,
        round(max_cs_advantage_vs_opponent, 0) as max_cs_advantage_vs_opponent,
        round(gold_per_minute, 2) as gold_per_minute,

        (
            all_in_pings + 
            assist_me_pings + 
            command_pings + 
            enemy_missing_pings + 
            enemy_vision_pings + 
            hold_pings + 
            get_back_pings + 
            need_vision_pings + 
            on_my_way_pings + 
            push_pings 
        ) as total_pings,

        wards_placed,
        control_wards_bought,
        control_wards_placed,
        wards_killed,
        vision_score,
        round(vision_score_per_minute, 2) as vision_score_per_minute,
        kills,
        deaths,
        assists,
        kda,
        kill_participation,
        turret_kills,
        inhibitor_kills,
        dragon_kills,
        baron_kills,
        turret_takedowns,
        inhibitor_takedowns,
        total_time_spent_dead,
        longest_time_spent_living,
        time_played,
        win

    from players

)

select * from enriched