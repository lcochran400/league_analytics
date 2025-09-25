with

match_stats as (

    select * from {{ ref('int_match_enriched') }}

),

team_results as (

    select
        match_id,
        patch_version,
        match_duration_minutes,
        team_map_side,
        won_feats_of_strength,
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

    from match_stats
    where is_my_team = true

),

opponent_results as (

    select
        match_id,
        total_champion_kills as opponent_total_champion_kills,
        total_tower_kills as opponent_total_tower_kills,
        total_inhibitor_kills as opponent_total_inhibitor_kills,
        total_dragon_kills as opponent_total_dragon_kills,
        total_grub_kills as opponent_total_grub_kills,
        total_rift_herald_kills as opponent_total_rift_herald_kills,
        total_atakhan_kills as opponent_total_atakhan_kills,
        total_baron_kills as opponent_total_baron_kills

    from match_stats
    where is_my_team = false

),

joined as (

    select
        team_results.match_id,
        team_results.patch_version,
        team_results.match_duration_minutes,
        team_results.team_map_side,
        team_results.won_feats_of_strength,
        team_results.has_slain_first_champion,
        team_results.has_slain_first_tower,
        team_results.has_slain_first_inhibitor,
        team_results.has_slain_first_dragon,
        team_results.has_slain_first_grub,
        team_results.has_slain_first_rift_herald,
        team_results.has_slain_first_atakhan,
        team_results.has_slain_first_baron,
        team_results.total_champion_kills,
        team_results.total_tower_kills,
        team_results.total_inhibitor_kills,
        team_results.total_dragon_kills,
        team_results.total_grub_kills,
        team_results.total_rift_herald_kills,
        team_results.total_atakhan_kills,
        team_results.total_baron_kills,
        opponent_results.opponent_total_champion_kills,
        opponent_results.opponent_total_tower_kills,
        opponent_results.opponent_total_inhibitor_kills,
        opponent_results.opponent_total_dragon_kills,
        opponent_results.opponent_total_grub_kills,
        opponent_results.opponent_total_rift_herald_kills,
        opponent_results.opponent_total_atakhan_kills,
        opponent_results.opponent_total_baron_kills,
        team_results.win

    from team_results
    left join opponent_results
        on team_results.match_id = opponent_results.match_id

)

select * from joined