--Creating and populating temp bound_hierarchy table--
--Source tables and concept_stage required--
DROP TABLE IF EXISTS bound_hierarchy;
select cs.concept_id AS concept_id, name, adminlevel, concept_code, vocabulary_id, rpath, CAST((regexp_split_to_array(rpath, ','))[2] AS INT) AS closest_ancestor
    into bound_hierarchy from united_states_al2_al12 us JOIN concept_stage cs ON CAST(us.id AS INT) = CAST(cs.concept_code AS INT);