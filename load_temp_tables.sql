--Creating and populating temp bound_hierarchy table--
--SOURCE TABLES AND CONCEPT_STAGE REQUIRED--
DROP TABLE IF EXISTS bound_hierarchy;
CREATE TABLE bound_hierarchy
(
  concept_id       integer,
  name             varchar(254),
  country          varchar(254),
  adminlevel       integer,
  concept_code     integer,
  vocabulary_id    text,
  rpath            varchar(254),
  closest_ancestor integer
);


--united_states_al2_al12_2018_01_03_v1--
INSERT INTO bound_hierarchy
select cs.concept_id AS concept_id,
       us.name AS name,
       us.country AS country,
       us.adminlevel AS adminlevel,
       cs.concept_code AS concept_code,
       cs.vocabulary_id AS vocabulary_id,
       us.rpath AS rpath,
       CAST((regexp_split_to_array(rpath, ','))[2] AS INT) AS closest_ancestor
    FROM united_states_al2_al12_2018_01_03_v1 us JOIN concept_stage cs
             ON CAST(us.id AS INT) = CAST(cs.concept_code AS INT);


--france_al2_al12_2018_01_11_v1--
INSERT INTO bound_hierarchy
select cs.concept_id AS concept_id,
       fr.name AS name,
       fr.country AS country,
       fr.adminlevel AS adminlevel,
       cs.concept_code AS concept_code,
       cs.vocabulary_id AS vocabulary_id,
       fr.rpath AS rpath,
       CAST((regexp_split_to_array(rpath, ','))[2] AS INT) AS closest_ancestor
    FROM france_al2_al12_2018_01_11_v1 fr JOIN concept_stage cs
             ON CAST(fr.id AS INT) = CAST(cs.concept_code AS INT);