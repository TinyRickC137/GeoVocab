-- Creation of divisions temporary table with link to region
DROP TABLE IF EXISTS divisions;
CREATE TABLE divisions
(
	gid int,
	divisionce varchar(1),
	affgeoid varchar(10),
	geoid varchar(1),
	name varchar(100),
	lsad varchar(2),
	aland double precision,
	awater double precision,
	region_code varchar(50)
);

-- Population of divisions temporary table with link to region
INSERT INTO divisions
SELECT gid,
       divisionce,
       affgeoid,
       geoid,
       name,
       lsad,
       aland,
       awater,
       CASE
           WHEN name in ('New England' ,'Middle Atlantic')
                 THEN '0200000US1'
           WHEN name in ('East North Central', 'West North Central')
                 THEN '0200000US2'
           WHEN name in ('East South Central', 'West South Central', 'South Atlantic')
                 THEN '0200000US3'
           WHEN name in ('Mountain', 'Pacific')
                 THEN '0200000US4'
           END as region_code
FROM sources.cb_us_division_500k;

-- Creation of states temporary table with link to divisions
DROP TABLE IF EXISTS states;
CREATE TABLE states
(
  state_concept_code varchar(50), --OSM concept_codes
  division_concept_code varchar(50)
);

-- Population of states temporary table with link to divisions
INSERT INTO states
SELECT id,
       CASE WHEN name in ('Connecticut', 'Maine', 'Massachusetts', 'New Hampshire', 'Rhode Island', 'Vermont')
                 THEN '0300000US1' --Division 1: New England
            WHEN name in ('New Jersey', 'New York', 'Pennsylvania')
                 THEN '0300000US2' --Division 2: Middle Atlantic
            WHEN name in ('Illinois', 'Indiana', 'Michigan', 'Ohio', 'Wisconsin')
                 THEN '0300000US3' --Division 3: East North Central
            WHEN name in ('Iowa', 'Kansas', 'Minnesota', 'Missouri', 'Nebraska', 'North Dakota', 'South Dakota')
                 THEN '0300000US4' --Division 4: West North Central
            WHEN name in ('Delaware', 'District of Columbia', 'Florida', 'Georgia', 'Maryland', 'North Carolina', 'South Carolina', 'Virginia', 'West Virginia')
                 THEN '0300000US5' --Division 5: South Atlantic
            WHEN name in ('Alabama', 'Kentucky', 'Mississippi', 'Tennessee')
                 THEN '0300000US6' --Division 6: East South Central
            WHEN name in ('Arkansas', 'Louisiana', 'Oklahoma', 'Texas')
                 THEN '0300000US7' --Division 7: West South Central
            WHEN name in ('Arizona', 'Colorado', 'Idaho', 'Montana', 'Nevada', 'New Mexico', 'Utah', 'Wyoming')
                 THEN '0300000US8' --Division 8: Mountain
            WHEN name in ('Alaska', 'California', 'Hawaii', 'Oregon', 'Washington')
                 THEN '0300000US9' --Division 9: Pacific
            ELSE '0'
            END as division_concept_code
FROM boundaries_hierarchy
WHERE country = 'USA'
  AND adminlevel = 4;

-- Population of stages
-- Population of concept_stage
-- US Census regions
INSERT INTO concept_stage
SELECT NULL as concept_id,
       name as concept_name,
       'Geography' as domain_id,
       'US Census' as vocabulary_id,
       'US Census Region' as concept_class_id,
       'S' as standard_concept,
       affgeoid as concept_code,
	   TO_DATE('19700101','yyyymmdd') as valid_start_date,
	   TO_DATE('20991231','yyyymmdd') as valid_end_date,
       null as invalid_reason
FROM sources.cb_us_region_500k;

-- US Census divisions
INSERT INTO concept_stage
SELECT NULL as concept_id,
       name as concept_name,
       'Geography' as domain_id,
       'US Census' as vocabulary_id,
       'US Census Division' as concept_class_id,
       'S' as standard_concept,
       affgeoid as concept_code,
	   TO_DATE('19700101','yyyymmdd') as valid_start_date,
	   TO_DATE('20991231','yyyymmdd') as valid_end_date,
       null as invalid_reason
FROM sources.cb_us_division_500k;

-- Population of concept_synonym_stage
-- US Census regions
INSERT INTO concept_synonym_stage
SELECT NULL as synonym_concept_id,
	   'Region ' || geoid || ': ' || name as synonym_name,
	   affgeoid as synonym_concept_code,
	   'US Census' as synonym_vocabulary_id,
	   4180186 as language_concept_id
FROM sources.cb_us_region_500k;

-- US Census divisions
INSERT INTO concept_synonym_stage
SELECT NULL as synonym_concept_id,
	   'Division ' || geoid || ': ' || name as synonym_name,
	   affgeoid as synonym_concept_code,
	   'US Census' as synonym_vocabulary_id,
	   4180186 as language_concept_id
FROM sources.cb_us_division_500k;

--Population of concept_relationship_manual
-- US Census regions
INSERT INTO concept_relationship_manual
SELECT affgeoid as concept_code_1,
       '148838' as concept_code_2, --United States
       'US Census' as vocabulary_id_1,
       'OSM' as vocabulary_id_2,
       'Is a' as relationship_id,
	   TO_DATE('19700101','yyyymmdd') as valid_start_date,
	   TO_DATE('20991231','yyyymmdd') as valid_end_date,
       NULL as invalid_reason
FROM sources.cb_us_region_500k;

-- US Census divisions
INSERT INTO concept_relationship_manual
SELECT affgeoid as concept_code_1,
       region_code as concept_code_2,
       'US Census' as vocabulary_id_1,
       'US Census' as vocabulary_id_2,
       'Is a' as relationship_id,
	   TO_DATE('19700101','yyyymmdd') as valid_start_date,
	   TO_DATE('20991231','yyyymmdd') as valid_end_date,
       NULL as invalid_reason
FROM divisions;

-- US states
INSERT INTO concept_relationship_manual
SELECT state_concept_code as concept_code_1,
       division_concept_code as concept_code_2,
       'OSM' as vocabulary_id_1,
       'US Census' as vocabulary_id_2,
       'Is a' as relationship_id,
	   TO_DATE('19700101','yyyymmdd') as valid_start_date,
	   TO_DATE('20991231','yyyymmdd') as valid_end_date,
       NULL as invalid_reason
FROM states
WHERE division_concept_code <> '0';



--Removing old OSM relationships between USA and target states
DELETE FROM concept_relationship_stage
WHERE concept_code_2 = '148838'  --United States
AND concept_code_1 in (
        SELECT state_concept_code
        FROM states
        WHERE division_concept_code <> '0'
        );

--Clean up
DROP TABLE states;
DROP TABLE divisions;