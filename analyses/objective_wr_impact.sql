{% set objectives = ({
    "Feats of Strength": "won_feats_of_strength",
    "First Blood": "has_slain_first_champion",
    "First Turret": "has_slain_first_tower",
    "First Inhibitor": "has_slain_first_inhibitor",
    "First Dragon": "has_slain_first_dragon",
    "First Grub": "has_slain_first_grub",
    "First Herald": "has_slain_first_rift_herald",
    "Atakhan": "has_slain_first_atakhan",
    "First Baron": "has_slain_first_baron"
    })

%}

{% for objective, status in objectives.items() %}

select
    '{{ objective }}' as objective,

    count(*) as total_matches,

    count(case
            when {{ status }} = true
            then {{ status }}
            else null
        end
    ) as total_matches_with_capture,

    count(
        case
            when win = true and {{ status }} = true
            then win
            else null
        end
    ) as wins_with_capture,

    count(
        case
            when win = true and {{ status }} = false
            then win
            else null
        end
    ) as wins_without_capture,

    round((total_matches_with_capture / total_matches) * 100, 2) as capture_rate,

    round((wins_with_capture / total_matches_with_capture) * 100, 2) as wr_when_captured,

    round((wins_without_capture / total_matches_with_capture) * 100, 2) as wr_when_not_captured

from {{ ref('dim_matches') }}

{% if not loop.last %}

union all

{% endif %}

{% endfor %}