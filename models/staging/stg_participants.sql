with

source as (

    select * from {{ source('league_raw', 'participants')}}

),

renamed as (

    select
        -- ids
        {{ dbt_utils.generate_surrogate_key(['match_id', 'puuid']) }} as match_participant_sk,
        match_id,
        puuid,
        json_extract(participant_json, '$.teamId')::int as team_id,

        -- team context
        case
            when team_id = 100
            then 'blue'
            else 'red'
        end as team_side,

        -- champion & account
        {{ extract_json_string('participant_json', '$.riotIdGameName') }} as riot_id_game_name,        
        {{ extract_json_string('participant_json', '$.riotIdTagline') }} as riot_id_tagline,        
        json_extract(participant_json, '$.summonerLevel')::int as summoner_level,
        {{ extract_json_string('participant_json', '$.championName') }} as champion_name, 
        json_extract(participant_json, '$.champLevel')::int as end_game_champ_level,
        json_extract(participant_json, '$.champExperience')::int as end_game_champ_experience,

        -- spells & casts
        json_extract(participant_json, '$.summoner1Id')::int as primary_summoner_spell,
        json_extract(participant_json, '$.summoner2Id')::int as secondary_summoner_spell,
        json_extract(participant_json, '$.summoner1Casts')::int as primary_summoner_spell_casts,
        json_extract(participant_json, '$.summoner2Casts')::int as secondary_summoner_spell_casts,
        json_extract(participant_json, '$.spell1Casts')::int as q_spell_casts,
        json_extract(participant_json, '$.spell2Casts')::int as w_spell_casts,
        json_extract(participant_json, '$.spell3Casts')::int as e_spell_casts,
        json_extract(participant_json, '$.spell4Casts')::int as r_spell_casts,

        -- first events
        json_extract(participant_json, '$.firstBloodKill')::boolean as first_blood_kill,
        json_extract(participant_json, '$.firstTowerKill')::boolean as first_tower_kill,
        json_extract(participant_json, '$.firstBloodAssist')::boolean as first_blood_assist,
        json_extract(participant_json, '$.firstTowerAssist')::boolean as first_tower_assist,

        -- lane & farm
        {{ extract_json_string('participant_json', '$.teamPosition') }} as position_on_team,   
        {{ extract_json_string('participant_json', '$.individualPosition') }} as individual_position,   
        {{ extract_json_string('participant_json', '$.lane') }} as lane,   
        {{ extract_json_string('participant_json', '$.role') }} as role,   
        json_extract(participant_json, '$.participantId')::int as participant_id,
        json_extract(participant_json, '$.neutralMinionsKilled')::int as neutral_minions_killed,
        json_extract(participant_json, '$.totalAllyJungleMinionsKilled')::int as total_ally_jungle_minions_killed,
        json_extract(participant_json, '$.totalEnemyJungleMinionsKilled')::int as total_enemy_jungle_minions_killed,
        json_extract(participant_json, '$.totalMinionsKilled')::int as total_minions_killed,
        json_extract(participant_json, '$.challenges.laneMinionsFirst10Minutes') as cs_first_10_minutes,
        json_extract(participant_json, '$.challenges.maxCsAdvantageOnLaneOpponent') as max_cs_advantage_vs_opponent,

        -- economy
        json_extract(participant_json, '$.consumablesPurchased')::int as consumables_purchased,
        json_extract(participant_json, '$.goldEarned')::int as gold_earned,
        json_extract(participant_json, '$.goldSpent')::int as gold_spent,
        json_extract(participant_json, '$.challenges.goldPerMinute') as gold_per_minute,
        json_extract(participant_json, '$.item0')::int as item0,
        json_extract(participant_json, '$.item1')::int as item1,
        json_extract(participant_json, '$.item2')::int as item2,
        json_extract(participant_json, '$.item3')::int as item3,
        json_extract(participant_json, '$.item4')::int as item4,
        json_extract(participant_json, '$.item5')::int as item5,
        json_extract(participant_json, '$.item6')::int as item6,
        json_extract(participant_json, '$.itemsPurchased')::int as items_purchased,

        -- pings
        json_extract(participant_json, '$.allInPings')::int as all_in_pings,
        json_extract(participant_json, '$.assistMePings')::int as assist_me_pings,
        json_extract(participant_json, '$.commandPings')::int as command_pings,
        json_extract(participant_json, '$.enemyMissingPings')::int as enemy_missing_pings,
        json_extract(participant_json, '$.enemyVisionPings')::int as enemy_vision_pings,
        json_extract(participant_json, '$.holdPings')::int as hold_pings,
        json_extract(participant_json, '$.getBackPings')::int as get_back_pings,
        json_extract(participant_json, '$.needVisionPings')::int as need_vision_pings,
        json_extract(participant_json, '$.onMyWayPings')::int as on_my_way_pings,
        json_extract(participant_json, '$.pushPings')::int as push_pings,

        -- vision
        json_extract(participant_json, '$.wardsPlaced')::int as wards_placed,
        json_extract(participant_json, '$.visionWardsBoughtInGame')::int as control_wards_bought,
        json_extract(participant_json, '$.challenges.controlWardsPlaced') as control_wards_placed,
        json_extract(participant_json, '$.wardsKilled')::int as wards_killed,
        json_extract(participant_json, '$.visionScore')::int as vision_score,
        json_extract(participant_json, '$.challenges.visionScorePerMinute') as vision_score_per_minute,

        -- combat outcomes
        json_extract(participant_json, '$.kills')::int as kills,
        json_extract(participant_json, '$.deaths')::int as deaths,
        json_extract(participant_json, '$.assists')::int as assists,
        json_extract(participant_json, '$.challenges.kda')::decimal as kda,
        {{ extract_json_rate('participant_json', '$.challenges.killParticipation') }} as kill_participation,  
        json_extract(participant_json, '$.doubleKills')::int as double_kills,
        json_extract(participant_json, '$.tripleKills')::int as triple_kills,
        json_extract(participant_json, '$.quadraKills')::int as quadra_kills,
        json_extract(participant_json, '$.pentaKills')::int as penta_kills,
        json_extract(participant_json, '$.unrealKills')::int as unreal_kills,
        json_extract(participant_json, '$.killingSprees')::int as killing_sprees,
        json_extract(participant_json, '$.largestMultiKill')::int as largest_multi_kill,
        json_extract(participant_json, '$.largestKillingSpree')::int as largest_killing_spree,

        -- objectives
        -- missing: horde, riftHerald, atakhan
        json_extract(participant_json, '$.turretKills')::int as turret_kills,
        json_extract(participant_json, '$.inhibitorKills')::int as inhibitor_kills,
        json_extract(participant_json, '$.dragonKills')::int as dragon_kills,
        json_extract(participant_json, '$.baronKills')::int as baron_kills,
        json_extract(participant_json, '$.nexusKills')::int as nexus_kills,
        json_extract(participant_json, '$.turretTakedowns')::int as turret_takedowns,
        json_extract(participant_json, '$.inhibitorTakedowns')::int as inhibitor_takedowns,
        json_extract(participant_json, '$.nexusTakedowns')::int as nexus_takedowns,
        json_extract(participant_json, '$.turretsLost')::int as turrets_lost,
        json_extract(participant_json, '$.inhibitorsLost')::int as inhibitors_lost,
        json_extract(participant_json, '$.nexusLost')::int as nexus_lost,
        json_extract(participant_json, '$.objectivesStolen')::int as objectives_stolen,
        json_extract(participant_json, '$.objectivesStolenAssists')::int as objectives_stolen_assists,
        
        -- damage, healing, & shielding
        json_extract(participant_json, '$.totalDamageDealtToChampions')::int as total_damage_dealt_to_champions,
        json_extract(participant_json, '$.damageDealtToBuildings')::int as total_damage_dealt_to_buildings,
        json_extract(participant_json, '$.damageDealtToObjectives')::int as total_damage_dealt_to_objectives,
        json_extract(participant_json, '$.damageDealtToTurrets')::int as total_damage_dealt_to_turrets,
        json_extract(participant_json, '$.damageSelfMitigated')::int as total_damage_self_mitigated,
        json_extract(participant_json, '$.physicalDamageDealt')::int as total_physical_damage_dealt,
        json_extract(participant_json, '$.physicalDamageDealtToChampions')::int as total_physical_damage_dealt_to_champions,
        json_extract(participant_json, '$.physicalDamageTaken')::int as total_physical_damage_taken,
        json_extract(participant_json, '$.magicDamageDealt')::int as total_magic_damage_dealt,
        json_extract(participant_json, '$.magicDamageDealtToChampions')::int as total_magic_damage_dealt_to_champions,
        json_extract(participant_json, '$.magicDamageTaken')::int as total_magic_damage_taken,
        json_extract(participant_json, '$.trueDamageDealt')::int as total_true_damage_dealt,
        json_extract(participant_json, '$.trueDamageDealtToChampions')::int as total_true_damage_dealt_to_champions,
        json_extract(participant_json, '$.trueDamageTaken')::int as total_true_damage_taken,
        json_extract(participant_json, '$.totalDamageShieldedOnTeammates')::int as total_damage_shielded_on_teammates,
        json_extract(participant_json, '$.totalHealsOnTeammates')::int as total_heals_on_teammates,
        json_extract(participant_json, '$.totalUnitsHealed')::int as total_units_healed,
        json_extract(participant_json, '$.totalHeal')::int as total_heal,
        json_extract(participant_json, '$.totalDamageDealt')::int as total_damage_dealt,
        json_extract(participant_json, '$.totalDamageTaken')::int as total_damage_taken,
        json_extract(participant_json, '$.challenges.highestChampionDamage') as highest_champion_damage,
        json_extract(participant_json, '$.largestCriticalStrike')::int as largest_critical_strike,

        -- timers
        {{ extract_json_seconds_to_minutes('participant_json', '$.totalTimeCCDealt')}} as total_time_cc_dealt,
        {{ extract_json_seconds_to_minutes('participant_json', '$.totalTimeSpentDead')}} as total_time_spent_dead,
        {{ extract_json_seconds_to_minutes('participant_json', '$.longestTimeSpentLiving')}} as longest_time_spent_living,
        {{ extract_json_seconds_to_minutes('participant_json', '$.timeCCingOthers')}} as time_ccing_others,
        {{ extract_json_seconds_to_minutes('participant_json', '$.timePlayed')}} as time_played,

        -- game results
        json_extract(participant_json, '$.gameEndedInEarlySurrender')::boolean as game_ended_in_early_surrender,
        json_extract(participant_json, '$.gameEndedInSurrender')::boolean as game_ended_in_surrender,
        json_extract(participant_json, '$.teamEarlySurrendered')::boolean as team_early_surrendered,
        json_extract(participant_json, '$.win')::boolean as win

    from source

)

select * from renamed