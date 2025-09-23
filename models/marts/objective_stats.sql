with

objectives as (

    select * from {{ ref('stg_teams')}}

),

match_results as (

    select
        match_id,
        win
    from {{ ref('int__match_win_enrichments')}}

),

objective_stats as (

    select

        count(distinct objectives.match_id) as total_matches,

        sum(
            case
                when win = true
                then .5
                else null
            end
        ) as total_team_wins,

        sum(
            case
                when objectives.is_my_team = true
                    and objectives.killed_first_dragon = true
                then 1
                else 0
            end
        ) as total_first_dragon_kills,

        sum(
            case
                when objectives.is_my_team = true
                    and match_results.win = true
                    and objectives.killed_first_dragon = true
                then 1
                else 0
            end
        ) as total_wins_with_first_dragon_kills,

        sum(
            case
                when objectives.is_my_team = true
                    and match_results.win = false
                    and objectives.killed_first_dragon = true
                then 1
                else 0
            end
        ) as total_losses_with_first_dragon_kills,

        sum(
            case
                when objectives.is_my_team = true
                then objectives.total_dragon_kills
                else 0
                end
        ) as total_dragons_killed,

        sum(
            case
                when objectives.is_my_team = false
                then objectives.total_dragon_kills
                else 0
                end
        ) as total_dragons_lost,

        round((total_team_wins/total_matches * 100), 2) as team_win_rate,

        round((total_first_dragon_kills / total_matches * 100), 2) as first_dragon_kill_rate,

        round((total_dragons_killed / (total_dragons_killed + total_dragons_lost) * 100), 2) as dragon_kill_rate


    from objectives
    left join match_results
        on objectives.match_id = match_results.match_id
)

select * from objective_stats