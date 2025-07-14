{% set old_et1_relation=ref('legacy_code')%}
{% set dbt_relation=ref('legacy_code_final_mart')%}

{{ audit_helper.compare_relations
(
    a_relation=old_et1_relation,
    b_relation=dbt_relation,
    primary_key="order_id"
)
}}