with

source as (
    
    select * from {{ source('league_raw', 'matches')}}

),

renamed as (

    select

        -- ids
        match_id,
        json_extract(match_json, '$.queueId') as queue_id,
        json_extract(match_json, '$.mapId') as map_id,
        json_extract(match_json, '$.gameId') as game_id,

        -- time
        {{ extract_json_unix_ts_to_utc('match_json', '$.gameCreation')}} as match_created_at,
        {{ extract_json_unix_ts_to_utc('match_json', '$.gameStartTimestamp')}} as match_started_at,
        {{ extract_json_unix_ts_to_utc('match_json', '$.gameEndTimestamp')}} as match_ended_at,
        {{ extract_json_seconds_to_minutes('match_json', '$.gameDuration')}} as match_duration_minutes,

        -- match details
        {{ extract_json_string('match_json', '$.gameMode') }} as game_mode,
        {{ extract_json_string('match_json', '$.gameName') }} as match_type_name,
        {{ extract_json_string('match_json', '$.gameType') }} as game_type,
        {{ extract_json_string('match_json', '$.endOfGameResult') }} as end_of_match_result,
        {{ extract_json_string('match_json', '$.gameVersion') }} as patch_version,
        {{ extract_json_string('match_json', '$.platformId') }} as region_code,
        {{ extract_json_string('match_json', '$.tournamentCode') }} as tournament_code,
        match_json
        
    from source

)

select * from renamed