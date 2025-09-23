{% macro extract_json_string(json_column, json_path) %}

replace(json_extract({{ json_column }}, '{{ json_path }}')::string, '"', '')

{% endmacro %}

{% macro extract_json_unix_ts_to_utc(json_column, json_path) %}

to_timestamp(json_extract({{ json_column }}, '{{ json_path }}')::bigint / 1000 )

{% endmacro %}

{% macro extract_json_seconds_to_minutes(json_column, json_path) %}

round(json_extract({{ json_column }}, '{{ json_path }}')::decimal / 60, 2)

{% endmacro %}

{% macro extract_json_rate(json_column, json_path) %}

round(json_extract({{ json_column }}, '{{ json_path }}')::decimal * 100, 2)

{% endmacro %}