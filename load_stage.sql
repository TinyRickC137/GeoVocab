--TODO: check if the fields in this tables correlate with CDM
--TODO: make a decision for adminlevel names

--Creating concept_stage--
DROP TABLE IF EXISTS concept_stage;
CREATE TABLE concept_stage
(
  concept_id       integer,
  concept_name     text,
  domain_id        text,
  vocabulary_id    text,
  concept_class_id text,
  standard_concept text,
  concept_code     integer,
  valid_start_date date,
  valid_end_date   date,
  invalid_reason   text
);
--Populating concept_stage--
INSERT INTO concept_stage
SELECT ROW_NUMBER() OVER () + 2100000000 AS concept_id,
  name AS concept_name,
	NULL AS domain_id,
  'OSM' AS vocabulary_id,
  CASE CAST(adminlevel AS INT)
    WHEN 2 THEN 'Country'
    WHEN 4 THEN 'State'
    WHEN 5 THEN 'Agglomerate'
    WHEN 6 THEN 'County'
    WHEN 7 THEN 'Civil township'
    WHEN 8 THEN 'Municipality'
    WHEN 9 THEN 'Ward'
    WHEN 10 THEN 'Neighborhood'
    WHEN 11 THEN 'Subarea'
    ELSE 'Unknown geo area'
  END as concept_class_id,
  NULL as standard_concept,
  id as concept_code,
  CAST('1970-01-01' AS DATE) as valid_start_date,
  CAST('2099-12-31' AS DATE) as valid_end_date,
  NULL as invalid_reason
FROM united_states_al2_al12;

--Creating concept_relationship_stage--
DROP TABLE IF EXISTS concept_relationship_stage;
CREATE TABLE concept_relationship_stage
(
  concept_id_1     integer,
  concept_id_2     integer,
  concept_code_1   integer     not null,
  concept_code_2   integer     not null,
  vocabulary_id_1  varchar(20) not null,
  vocabulary_id_2  varchar(20) not null,
  relationship_id  varchar(20) not null,
  valid_start_date date        not null,
  valid_end_date   date        not null,
  invalid_reason   varchar(1)
);
--Populating concept_relationship_stage--
INSERT INTO concept_relationship_stage
SELECT cs.concept_id as concept_id_1,
       bh.concept_id as concept_id_2,
       cs.concept_code as concept_code_1,
       bh.concept_code as concept_code_2,
       cs.vocabulary_id as vocabulary_id_1,
       bh.vocabulary_id as vocabulary_id_2,
       'Is a' as relationship_id,
       CAST('1970-01-01' AS DATE) as valid_start_date,
       CAST('2099-12-31' AS DATE) as valid_end_date,
       NULL as invalid_reason
FROM concept_stage cs JOIN bound_hierarchy bh ON bh.closest_ancestor = cs.concept_code;