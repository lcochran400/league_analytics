{% set monster_slaying_feat_count_goal = '2' %}
{% set warfare_feat_count_goal = '3' %}
{% set first_turret_feat_count_goal = '1' %}

with

matches as (

    select * from {{ ref('stg_matches')}}

),

teams as (

    select * from {{ ref('stg_teams')}}
    {# where is_my_team = true #}

),

joined as (

    select
        matches.match_id,
        matches.patch_version,
        matches.match_duration_minutes,
        teams.is_my_team,
        teams.team_id,
        teams.monster_slaying_feat_count,
        teams.warfare_feat_count,
        teams.first_turret_feat_count,
        teams.has_slain_first_champion,
        teams.has_slain_first_tower,
        teams.has_slain_first_inhibitor,
        teams.has_slain_first_dragon,
        teams.has_slain_first_grub,
        teams.has_slain_first_rift_herald,
        teams.has_slain_first_atakhan,
        teams.has_slain_first_baron,
        teams.total_champion_kills,
        teams.total_tower_kills,
        teams.total_inhibitor_kills,
        teams.total_dragon_kills,
        teams.total_grub_kills,
        teams.total_rift_herald_kills,
        teams.total_atakhan_kills,
        teams.total_baron_kills,
        teams.win
    
    from matches
    left join teams
        on matches.match_id = teams.match_id

),

enriched as (

    select

        match_id,
        patch_version,
        match_duration_minutes,
        is_my_team,

        case
            when team_id = 100
            then 'blue'
            else 'red'
        end as team_map_side,

        case
            when monster_slaying_feat_count = 1001
            then false
            when monster_slaying_feat_count >= {{ monster_slaying_feat_count_goal }}
            then true
            else false
        end as won_monster_slaying_feat,

        case
            when warfare_feat_count = 1001
            then false
            when warfare_feat_count = {{ warfare_feat_count_goal }}
            then true
            else false
        end as won_warfare_feat,

        case
            when first_turret_feat_count = 1001
            then false
            when first_turret_feat_count >= {{ first_turret_feat_count_goal }}
            then true
            else false
        end as won_first_turret_feat,

        case
            when (
                won_monster_slaying_feat::int + won_warfare_feat::int + won_first_turret_feat::int
            ) >= 2
            then true
            else false
        end as won_feats_of_strength,
    
        has_slain_first_champion,
        has_slain_first_tower,
        has_slain_first_inhibitor,
        has_slain_first_dragon,
        has_slain_first_grub,
        has_slain_first_rift_herald,
        has_slain_first_atakhan,
        has_slain_first_baron,
        total_champion_kills,
        total_tower_kills,
        total_inhibitor_kills,
        total_dragon_kills,
        total_grub_kills,
        total_rift_herald_kills,
        total_atakhan_kills,
        total_baron_kills,
        win

    from joined

)

select * from enriched