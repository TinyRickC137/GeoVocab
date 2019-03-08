--NEVER EXECUTED BECAUSE OF Postgres issues!!
--TODO: ADD connections between country and regions, divisions and states
--Links to source codes can be found on github issue

--Creating stage tables
DROP TABLE IF EXISTS concept_stage;
CREATE TABLE concept_stage
(
  concept_id       integer,
  concept_name     varchar(255),
  domain_id        varchar(20),
  vocabulary_id    varchar(20),
  concept_class_id varchar(20),
  standard_concept varchar(1),
  concept_code     varchar(50),
  valid_start_date date,
  valid_end_date   date,
  invalid_reason   varchar(1)
);

DROP TABLE IF EXISTS concept_relationship_stage;
CREATE TABLE concept_relationship_stage
(
  concept_id_1     integer,
  concept_id_2     integer,
  concept_code_1   varchar(50)     not null,
  concept_code_2   varchar(50)     not null,
  vocabulary_id_1  varchar(20) not null,
  vocabulary_id_2  varchar(20) not null,
  relationship_id  varchar(20) not null,
  valid_start_date date        not null,
  valid_end_date   date        not null,
  invalid_reason   varchar(1)
);

--Creating source tables
CREATE TABLE cb_2017_us_division_500k
(
  gid        integer,
  divisionce varchar(1),
  affgeoid   varchar(10),
  geoid      varchar(1),
  name       varchar(100),
  lsad       varchar(2),
  aland      double precision,
  awater     double precision,
  geom       geometry(MultiPolygon, 4326)
);

CREATE TABLE cb_2017_us_region_500k
(
  gid      integer,
  regionce varchar(1),
  affgeoid varchar(10),
  geoid    varchar(1),
  name     varchar(100),
  lsad     varchar(2),
  aland    double precision,
  awater   double precision,
  geom     geometry(MultiPolygon, 4326)
);

--Add region indicator to divisions
ALTER TABLE cb_2017_us_division_500k
    ADD COLUMN region varchar(50);

UPDATE cb_2017_us_division_500k di
SET region = '0200000US1'
    WHERE name in ('New England' ,'Middle Atlantic');
UPDATE cb_2017_us_division_500k di
SET region = '0200000US2'
    WHERE name in ('East North Central', 'West North Central');
UPDATE cb_2017_us_division_500k di
SET region = '0200000US3'
    WHERE name = ('East South Central', 'West South Central', 'South Atlantic');
UPDATE cb_2017_us_division_500k di
SET region = '0200000US4'
    WHERE name = ('Mountain', 'Pacific');

--Populating concept_stage
--Census regions
INSERT INTO concept_stage
SELECT NULL as concept_id,
       CONCAT(re.name, ' region') as concept_name,
       'Geography' as domain_id,
       'US Census' as vocabulary_id,
       'US Region' as concept_class_id,
       'S' as standard_concept,
       affgeoid as concept_code,
       CAST('1970-01-01' AS DATE) as valid_start_date,
       CAST('2099-12-31' AS DATE) as valid_end_date,
       null as invalid_reason
FROM cb_2017_us_region_500k re;

--Populating concept_stage
--Census divisions
INSERT INTO concept_stage
SELECT NULL as concept_id,
       di.name as concept_name,
       'Geography' as domain_id,
       'US Census' as vocabulary_id,
       'Division' as concept_class_id,
       'S' as standard_concept,
       affgeoid as concept_code,
       CAST('1970-01-01' AS DATE) as valid_start_date,
       CAST('2099-12-31' AS DATE) as valid_end_date,
       null as invalid_reason
FROM cb_2017_us_division_500k di;

--Populating relationship_stage
--Regions -> divisions
INSERT INTO concept_relationship_stage
SELECT NULL as concept_id_1,
       NULL as concept_id_2,
       di.affgeoid as concept_code_1,
       di.region as concept_code_2,
       'US Census' as vocabulary_id_1,
       'US Census' as vocabulary_id_2,
       'Is a' as relationship_id,
       CAST('1970-01-01' AS DATE) as valid_start_date,
       CAST('2099-12-31' AS DATE) as valid_end_date,
       NULL as invalid_reason
FROM cb_2017_us_division_500k di;