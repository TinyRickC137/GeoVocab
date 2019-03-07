--TODO:
--Find out about districts, villages and small areas
--Decide if we need to unite states in regions (4 regions)
--Check Alaska and other strange areas

--States--
DROP TABLE IF EXISTS tl_2018_us_state;
CREATE TABLE tl_2018_us_state
(
  gid      integer,
  region   varchar(2),
  division varchar(2),
  statefp  varchar(2),
  statens  varchar(8),
  geoid    varchar(2),
  stusps   varchar(2),
  name     varchar(100),
  lsad     varchar(2),
  mtfcc    varchar(5),
  funcstat varchar(1),
  aland    double precision,
  awater   double precision,
  intptlat varchar(11),
  intptlon varchar(12),
  geom     geometry(MultiPolygon, 4326)
);

--Counties--
DROP TABLE IF EXISTS tl_2018_us_county;
CREATE TABLE tl_2018_us_county
(
  gid      integer,
  statefp  varchar(2),
  countyfp varchar(3),
  countyns varchar(8),
  geoid    varchar(5),
  name     varchar(100),
  namelsad varchar(100),
  lsad     varchar(2),
  classfp  varchar(2),
  mtfcc    varchar(5),
  csafp    varchar(3),
  cbsafp   varchar(5),
  metdivfp varchar(5),
  funcstat varchar(1),
  aland    double precision,
  awater   double precision,
  intptlat varchar(11),
  intptlon varchar(12),
  geom     geometry(MultiPolygon, 4326)
);

--County subdivisions--
DROP TABLE IF EXISTS tl_2018_01_78_cousub;
CREATE TABLE tl_2018_01_78_cousub
(
  gid      integer,
  statefp  varchar(2),
  countyfp varchar(3),
  cousubfp varchar(5),
  cousubns varchar(8),
  geoid    varchar(10),
  name     varchar(100),
  namelsad varchar(100),
  lsad     varchar(2),
  classfp  varchar(2),
  mtfcc    varchar(5),
  cnectafp varchar(3),
  nectafp  varchar(5),
  nctadvfp varchar(5),
  funcstat varchar(1),
  aland    double precision,
  awater   double precision,
  intptlat varchar(11),
  intptlon varchar(12),
  layer    varchar(100),
  path     varchar(200),
  geom     geometry(MultiPolygon, 4326)
);
--Removing column path: this column stores information about your local machine path to files--
ALTER TABLE tl_2018_01_78_cousub
DROP COLUMN IF EXISTS path;




--START FROM HERE--
--Creating concept_stage--
DROP TABLE IF EXISTS concept_stage_CENSUS;
CREATE TABLE concept_stage_CENSUS
(
  concept_id       numeric,
  concept_name     text,
  domain_id        text,
  vocabulary_id    text,
  concept_class_id text,
  standard_concept text,
  concept_code     numeric,
  valid_start_date date,
  valid_end_date   date,
  invalid_reason   text
);

--Creating concept_relationship_stage--
DROP TABLE IF EXISTS concept_relationship_stage_CENSUS;
CREATE TABLE concept_relationship_stage_CENSUS
(
  concept_id_1     numeric,
  concept_id_2     numeric,
  concept_code_1   numeric     not null,
  concept_code_2   numeric     not null,
  vocabulary_id_1  varchar(20) not null,
  vocabulary_id_2  varchar(20) not null,
  relationship_id  varchar(20) not null,
  valid_start_date date        not null,
  valid_end_date   date        not null,
  invalid_reason   varchar(1)
);

--Populating concept_stage with states--
INSERT INTO concept_stage_CENSUS
SELECT CAST(geoid AS numeric) AS concept_id,
  name AS concept_name,
	NULL AS domain_id,
  'US Census' AS vocabulary_id,
  'State' as concept_class_id,
  NULL as standard_concept,
  CAST(geoid AS numeric) as concept_code,
  CAST('1970-01-01' AS DATE) as valid_start_date,
  CAST('2099-12-31' AS DATE) as valid_end_date,
  NULL as invalid_reason
FROM tl_2018_us_state;

--Populating concept_stage with counties--
INSERT INTO concept_stage_CENSUS
SELECT CAST(geoid AS numeric) AS concept_id,
  namelsad AS concept_name,
	NULL AS domain_id,
  'US Census' AS vocabulary_id,
  'County' as concept_class_id,
  NULL as standard_concept,
  CAST(geoid AS numeric) as concept_code,
  CAST('1970-01-01' AS DATE) as valid_start_date,
  CAST('2099-12-31' AS DATE) as valid_end_date,
  NULL as invalid_reason
FROM tl_2018_us_county;

--Populating concept_stage with counties subdivisions--
INSERT INTO concept_stage_CENSUS
SELECT CAST(geoid AS numeric) AS concept_id,
  namelsad AS concept_name,
	NULL AS domain_id,
  'US Census' AS vocabulary_id,
  'County subdivision' as concept_class_id,
  NULL as standard_concept,
  CAST(geoid AS numeric) as concept_code,
  CAST('1970-01-01' AS DATE) as valid_start_date,
  CAST('2099-12-31' AS DATE) as valid_end_date,
  NULL as invalid_reason
FROM tl_2018_01_78_cousub;

--Populating concept_relationship_stage--
--Relationship between states and counties--
WITH counties_concepts AS (SELECT * FROM concept_stage_CENSUS WHERE concept_class_id = 'County')
INSERT INTO concept_relationship_stage_CENSUS
SELECT cc.concept_id as concept_id_1,
       cs.concept_id as concept_id_2,
       cc.concept_code as concept_code_1,
       cs.concept_code as concept_code_2,
       cc.vocabulary_id as vocabulary_id_1,
       cs.vocabulary_id as vocabulary_id_2,
       'Is a' as relationship_id,
       CAST('1970-01-01' AS DATE) as valid_start_date,
       CAST('2099-12-31' AS DATE) as valid_end_date,
       NULL as invalid_reason
FROM concept_stage_CENSUS cs
       JOIN tl_2018_us_county co ON CAST(co.statefp AS numeric) = cs.concept_code
       JOIN counties_concepts cc ON cc.concept_code = CAST(co.geoid AS numeric);

--Populating concept_relationship_stage--
--Relationship between counties and subdivisions--
WITH counties_subdivisions_concepts AS (SELECT * FROM concept_stage_CENSUS WHERE concept_class_id = 'County subdivision')
INSERT INTO concept_relationship_stage_CENSUS
SELECT cc.concept_id as concept_id_1,
       cs.concept_id as concept_id_2,
       cc.concept_code as concept_code_1,
       cs.concept_code as concept_code_2,
       cc.vocabulary_id as vocabulary_id_1,
       cs.vocabulary_id as vocabulary_id_2,
       'Is a' as relationship_id,
       CAST('1970-01-01' AS DATE) as valid_start_date,
       CAST('2099-12-31' AS DATE) as valid_end_date,
       NULL as invalid_reason
FROM concept_stage_CENSUS cs
       JOIN tl_2018_01_78_cousub co ON CAST(co.geoid AS numeric) = cs.concept_code
       JOIN counties_subdivisions_concepts cc ON cc.concept_code = CAST(co.geoid AS numeric);

--TESTS--
Select count(concept_id), count(distinct concept_id) from concept_stage_CENSUS;