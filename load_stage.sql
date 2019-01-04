CREATE EXTENSION postgis;
CREATE INDEX us_geo_geom ON geo USING GIST (geom);
--creating concept_stage
create table public.concept_stage
(
  concept_id       integer,
  concept_name     varchar(255),
  domain_id        varchar(20),
  vocabulary_id    varchar(20) not null,
  concept_class_id varchar(20),
  standard_concept varchar(1),
  concept_code     varchar(50) not null,
  valid_start_date date        not null,
  valid_end_date   date        not null,
  invalid_reason   varchar(1)
);
--populating concept_stage with data
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
FROM "united states_al2-al12";
--creating concept_relationship_stage
create table concept_relationship_stage
(
  concept_id_1     integer,
  concept_id_2     integer,
  concept_code_1   varchar(50) not null,
  concept_code_2   varchar(50) not null,
  vocabulary_id_1  varchar(20) not null,
  vocabulary_id_2  varchar(20) not null,
  relationship_id  varchar(20) not null,
  valid_start_date date        not null,
  valid_end_date   date        not null,
  invalid_reason   varchar(1)
);
--creating temp table with closest ancestor
select cs.concept_id AS concept_id, name, adminlevel, concept_code, vocabulary_id, rpath, (regexp_split_to_array(rpath, ','))[2] AS closest_ancestor
    into bound_hierarchy from "united states_al2-al12" us JOIN concept_stage cs ON CAST(us.id AS INT) = CAST(cs.concept_code AS INT);

--populating concept_relationship_stage with data
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

