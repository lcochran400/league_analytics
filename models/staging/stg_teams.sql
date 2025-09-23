with

source as (

    select * from {{ source('league_raw','teams') }}

),

renamed as (

    select
        -- ids
        {{ dbt_utils.generate_surrogate_key(['match_id', 'team_id'])}} as match_team_sk,
        match_id,
        team_id,

        -- team context
        is_my_team,
        json_extract(team_json, '$.win') as win,

        -- feats of strength
        json_extract(team_json, '$.feats.EPIC_MONSTER_KILL.featState') as monster_slaying_feat_count,
        json_extract(team_json, '$.feats.FIRST_BLOOD.featState') as warfare_feat_count,
        json_extract(team_json, '$.feats.FIRST_TURRET.featState') as first_turret_feat_count,

        -- objectives
        json_extract(objectives_json, '$.atakhan.first') as has_slain_first_atakhan,
        json_extract(objectives_json, '$.atakhan.kills') as total_atakhan_kills,
        json_extract(objectives_json, '$.baron.first') as has_slain_first_baron,
        json_extract(objectives_json, '$.baron.kills') as total_baron_kills,
        json_extract(objectives_json, '$.champion.first') as has_slain_first_champion,
        json_extract(objectives_json, '$.champion.kills') as total_champion_kills,
        json_extract(objectives_json, '$.dragon.first') as has_slain_first_dragon,
        json_extract(objectives_json, '$.dragon.kills') as total_dragon_kills,
        json_extract(objectives_json, '$.horde.first') as has_slain_first_grub,
        json_extract(objectives_json, '$.horde.kills') as total_horde_kills,
        json_extract(objectives_json, '$.inhibitor.first') as has_slain_first_inhibitor,
        json_extract(objectives_json, '$.inhibitor.kills') as total_inhibitor_kills,
        json_extract(objectives_json, '$.riftHerald.first') as has_slain_first_rift_herald,
        json_extract(objectives_json, '$.riftHerald.kills') as total_rift_herald_kills,
        json_extract(objectives_json, '$.tower.first') as has_slain_first_tower,
        json_extract(objectives_json, '$.tower.kills') as total_tower_kills

        from source

)

select * from renamed