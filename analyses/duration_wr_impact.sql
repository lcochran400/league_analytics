with

matches as (
    select * from {{ ref('dim_matches') }}

),

duration_buckets as (

    select 
        case
            when match_duration_minutes <= 25
            then 'Short (<= 25 mins)'
            when match_duration_minutes > 25 and match_duration_minutes <= 35
            then 'Medium (25 - 35 mins)'
            when match_duration_minutes > 35
            then 'Long (> 35 mins)'
        end as match_duration,

        count(*) as total_matches,

        count(
            case
                when win = true
                then win
                else null
            end
        ) as total_wins,

        round((total_wins / total_matches) * 100, 2) as winrate

    from matches
    group by match_duration
)

select * from duration_buckets
order by (
    case
        when match_duration = 'Short (<= 25 mins)'
        then 1
        when match_duration = 'Medium (25 - 35 mins)'
        then 2
        when match_duration = 'Long (> 35 mins)'
        then 3
    end
)