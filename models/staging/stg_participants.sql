with

source as (

    select * from {{ source('league_raw', 'participants')}}

),

renamed as (

    select
        -- ids
        match_id,
        puuid,
        json_extract(participant_json, '$.teamId')::int as team_id,

        -- team context
        json_extract(participant_json, '$.placement')::int as placement,
        json_extract(participant_json, '$.subteamPlacement')::int as subteam_placement,
        replace(json_extract(participant_json, '$.teamPosition')::string, '"', '') as team_position,

        case
            when team_id = 100
            then 'blue'
            else 'red'
        end as team_side,

        -- champion & account
        replace(json_extract(participant_json, '$.riotIdGameName')::string, '"', '') as riot_id_game_name,
        replace(json_extract(participant_json, '$.riotIdTagline')::string, '"', '') as riot_id_tagline,
        json_extract(participant_json, '$.profileIcon')::int as profile_icon,
        json_extract(participant_json, '$.summonerLevel')::int as summoner_level,
        json_extract(participant_json, '$.champExperience')::int as champ_experience,
        json_extract(participant_json, '$.champLevel')::int as champ_level,
        json_extract(participant_json, '$.championId')::int as champion_id,
        replace(json_extract(participant_json, '$.championName')::string, '"', '') as champion_name,

        -- spells & casts
        json_extract(participant_json, '$.summoner1Casts')::int as summoner1_casts,
        json_extract(participant_json, '$.summoner1Id')::int as summoner1_id,
        json_extract(participant_json, '$.summoner2Casts')::int as summoner2_casts,
        json_extract(participant_json, '$.summoner2Id')::int as summoner2_id,
        json_extract(participant_json, '$.spell1Casts')::int as spell1_casts,
        json_extract(participant_json, '$.spell2Casts')::int as spell2_casts,
        json_extract(participant_json, '$.spell3Casts')::int as spell3_casts,
        json_extract(participant_json, '$.spell4Casts')::int as spell4_casts,

        -- first events
        json_extract(participant_json, '$.firstBloodKill')::boolean as first_blood_kill,
        json_extract(participant_json, '$.firstBloodAssist')::boolean as first_blood_assist,
        json_extract(participant_json, '$.firstTowerKill')::boolean as first_tower_kill,
        json_extract(participant_json, '$.firstTowerAssist')::boolean as first_tower_assist,

        -- lane & farm
        replace(json_extract(participant_json, '$.individualPosition')::string, '"', '') as individual_position,
        replace(json_extract(participant_json, '$.role')::string, '"', '') as role,
        replace(json_extract(participant_json, '$.lane')::string, '"', '') as lane,
        json_extract(participant_json, '$.participantId')::int as participant_id,
        json_extract(participant_json, '$.neutralMinionsKilled')::int as neutral_minions_killed,
        json_extract(participant_json, '$.totalAllyJungleMinionsKilled')::int as total_ally_jungle_minions_killed,
        json_extract(participant_json, '$.totalEnemyJungleMinionsKilled')::int as total_enemy_jungle_minions_killed,

        -- economy
        json_extract(participant_json, '$.consumablesPurchased')::int as consumables_purchased,
        json_extract(participant_json, '$.goldEarned')::int as gold_earned,
        json_extract(participant_json, '$.goldSpent')::int as gold_spent,
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
        json_extract(participant_json, '$.visionClearedPings')::int as vision_cleared_pings,

        -- vision
        json_extract(participant_json, '$.detectorWardsPlaced')::int as detector_wards_placed,
        json_extract(participant_json, '$.sightWardsBoughtInGame')::int as sight_wards_bought_in_game,
        json_extract(participant_json, '$.visionWardsBoughtInGame')::int as vision_wards_bought_in_game,
        json_extract(participant_json, '$.wardsKilled')::int as wards_killed,
        json_extract(participant_json, '$.wardsPlaced')::int as wards_placed,
        json_extract(participant_json, '$.visionScore')::int as vision_score,

        -- combat outcomes
        json_extract(participant_json, '$.kills')::int as kills,
        json_extract(participant_json, '$.deaths')::int as deaths,
        json_extract(participant_json, '$.assists')::int as assists,
        json_extract(participant_json, '$.killingSprees')::int as killing_sprees,
        json_extract(participant_json, '$.doubleKills')::int as double_kills,
        json_extract(participant_json, '$.tripleKills')::int as triple_kills,
        json_extract(participant_json, '$.quadraKills')::int as quadra_kills,
        json_extract(participant_json, '$.pentaKills')::int as penta_kills,
        json_extract(participant_json, '$.unrealKills')::int as unreal_kills,
        json_extract(participant_json, '$.largestMultiKill')::int as largest_multi_kill,
        json_extract(participant_json, '$.largestKillingSpree')::int as largest_killing_spree,

        -- objectives
        json_extract(participant_json, '$.baronKills')::int as baron_kills,
        json_extract(participant_json, '$.dragonKills')::int as dragon_kills,
        json_extract(participant_json, '$.inhibitorKills')::int as inhibitor_kills,
        json_extract(participant_json, '$.inhibitorTakedowns')::int as inhibitor_takedowns,
        json_extract(participant_json, '$.inhibitorsLost')::int as inhibitors_lost,
        json_extract(participant_json, '$.nexusKills')::int as nexus_kills,
        json_extract(participant_json, '$.nexusTakedowns')::int as nexus_takedowns,
        json_extract(participant_json, '$.nexusLost')::int as nexus_lost,
        json_extract(participant_json, '$.objectivesStolen')::int as objectives_stolen,
        json_extract(participant_json, '$.objectivesStolenAssists')::int as objectives_stolen_assists,
        json_extract(participant_json, '$.turretKills')::int as turret_kills,
        json_extract(participant_json, '$.turretTakedowns')::int as turret_takedowns,
        json_extract(participant_json, '$.turretsLost')::int as turrets_lost,
        
        -- damage, healing, & shielding
        json_extract(participant_json, '$.damageDealtToBuildings')::int as damage_dealt_to_buildings,
        json_extract(participant_json, '$.damageDealtToObjectives')::int as damage_dealt_to_objectives,
        json_extract(participant_json, '$.damageDealtToTurrets')::int as damage_dealt_to_turrets,
        json_extract(participant_json, '$.damageSelfMitigated')::int as damage_self_mitigated,
        json_extract(participant_json, '$.magicDamageDealt')::int as magic_damage_dealt,
        json_extract(participant_json, '$.magicDamageDealtToChampions')::int as magic_damage_dealt_to_champions,
        json_extract(participant_json, '$.magicDamageTaken')::int as magic_damage_taken,
        json_extract(participant_json, '$.trueDamageDealt')::int as true_damage_dealt,
        json_extract(participant_json, '$.trueDamageDealtToChampions')::int as true_damage_dealt_to_champions,
        json_extract(participant_json, '$.trueDamageTaken')::int as true_damage_taken,
        json_extract(participant_json, '$.physicalDamageDealt')::int as physical_damage_dealt,
        json_extract(participant_json, '$.physicalDamageDealtToChampions')::int as physical_damage_dealt_to_champions,
        json_extract(participant_json, '$.physicalDamageTaken')::int as physical_damage_taken,
        json_extract(participant_json, '$.totalDamageDealt')::int as total_damage_dealt,
        json_extract(participant_json, '$.totalDamageDealtToChampions')::int as total_damage_dealt_to_champions,
        json_extract(participant_json, '$.totalDamageShieldedOnTeammates')::int as total_damage_shielded_on_teammates,
        json_extract(participant_json, '$.totalDamageTaken')::int as total_damage_taken,
        json_extract(participant_json, '$.totalUnitsHealed')::int as total_units_healed,
        json_extract(participant_json, '$.totalHeal')::int as total_heal,
        json_extract(participant_json, '$.totalHealsOnTeammates')::int as total_heals_on_teammates,
        json_extract(participant_json, '$.largestCriticalStrike')::int as largest_critical_strike,

        -- game results
        json_extract(participant_json, '$.gameEndedInEarlySurrender')::boolean as game_ended_in_early_surrender,
        json_extract(participant_json, '$.gameEndedInSurrender')::boolean as game_ended_in_surrender,
        json_extract(participant_json, '$.teamEarlySurrendered')::boolean as team_early_surrendered,
        json_extract(participant_json, '$.win')::boolean as win,

        -- timers
        json_extract(participant_json, '$.totalMinionsKilled')::int as total_minions_killed,
        json_extract(participant_json, '$.totalTimeCCDealt')::int / 60 as total_time_cc_dealt,
        json_extract(participant_json, '$.totalTimeSpentDead')::int / 60 as total_time_spent_dead,
        json_extract(participant_json, '$.longestTimeSpentLiving')::int / 60 as longest_time_spent_living,
        json_extract(participant_json, '$.timeCCingOthers')::int / 60 as time_ccing_others,
        json_extract(participant_json, '$.timePlayed')::int / 60 as time_played,

        -- deeper arrays
        json_extract(participant_json, '$.challenges')::string as challenges,
        json_extract(participant_json, '$.missions')::string as missions,
        json_extract(participant_json, '$.perks') as perks

    from source

)

select * from renamed