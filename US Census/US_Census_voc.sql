--US CENSUS
--Some states or their equivalents were NOT included in US Census regions and divisions
--according to 2017 US Census bureau information

--List of excluded concepts with concept_codes (all of them are direct children of USA)
--2177187	American Samoa
--306001	Guam
--306004	Northern Mariana Islands
--4422604	Puerto Rico
--286898	United States Virgin Islands

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
    WHERE name in ('East South Central', 'West South Central', 'South Atlantic');
UPDATE cb_2017_us_division_500k di
SET region = '0200000US4'
    WHERE name in ('Mountain', 'Pacific');

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
FROM cb_us_region_500k;

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
FROM cb_us_division_500k;













--Populating relationship_stage
--United States -> regions
INSERT INTO concept_relationship_stage
SELECT NULL as concept_id_1,
       NULL as concept_id_2,
       re.affgeoid as concept_code_1,
       '148838' as concept_code_2, --United States
       'US Census' as vocabulary_id_1,
       'OSM' as vocabulary_id_2,
       'Is a' as relationship_id,
       CAST('1970-01-01' AS DATE) as valid_start_date,
       CAST('2099-12-31' AS DATE) as valid_end_date,
       NULL as invalid_reason
FROM cb_2017_us_region_500k re;

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

--Create temp table with divisions and states
CREATE TABLE temp_div_states
(
  division_concept_code varchar(50),
  division_concept_name varchar(255),
  state_concept_code varchar(50),  --OSM concept_codes
  state_concept_name varchar(255)
);

--Populate temp table with states and corresponding divisions
INSERT INTO temp_div_states (division_concept_code, division_concept_name, state_concept_code, state_concept_name)
       --Division 1: New England
VALUES ('0300000US1', 'New England', '165794', 'Connecticut'),
       ('0300000US1', 'New England', '63512', 'Maine'),
       ('0300000US1', 'New England', '61315', 'Massachusetts'),
       ('0300000US1', 'New England', '67213', 'New Hampshire'),
       ('0300000US1', 'New England', '392915', 'Rhode Island'),
       ('0300000US1', 'New England', '60759', 'Vermont'),
       --Division 2: Middle Atlantic
       ('0300000US2', 'Middle Atlantic', '224951', 'New Jersey'),
       ('0300000US2', 'Middle Atlantic', '61320', 'New York'),
       ('0300000US2', 'Middle Atlantic', '162109', 'Pennsylvania'),
       --Division 3: East North Central
       ('0300000US3', 'East North Central', '122586', 'Illinois'),
       ('0300000US3', 'East North Central', '161816', 'Indiana'),
       ('0300000US3', 'East North Central', '165789', 'Michigan'),
       ('0300000US3', 'East North Central', '162061', 'Ohio'),
       ('0300000US3', 'East North Central', '165466', 'Wisconsin'),
       --Division 4: West North Central
       ('0300000US4', 'West North Central', '161650', 'Iowa'),
       ('0300000US4', 'West North Central', '161644', 'Kansas'),
       ('0300000US4', 'West North Central', '165471', 'Minnesota'),
       ('0300000US4', 'West North Central', '161638', 'Missouri'),
       ('0300000US4', 'West North Central', '161648', 'Nebraska'),
       ('0300000US4', 'West North Central', '161653', 'North Dakota'),
       ('0300000US4', 'West North Central', '161652', 'South Dakota'),
       --Division 5: South Atlantic
       ('0300000US5', 'South Atlantic', '162110', 'Delaware'),
       ('0300000US5', 'South Atlantic', '162069', 'District of Columbia'),
       ('0300000US5', 'South Atlantic', '162050', 'Florida'),
       ('0300000US5', 'South Atlantic', '161957', 'Georgia'),
       ('0300000US5', 'South Atlantic', '162112', 'Maryland'),
       ('0300000US5', 'South Atlantic', '224045', 'North Carolina'),
       ('0300000US5', 'South Atlantic', '224040', 'South Carolina'),
       ('0300000US5', 'South Atlantic', '224042', 'Virginia'),
       ('0300000US5', 'South Atlantic', '162068', 'West Virginia'),
       --Division 6: East South Central
       ('0300000US6', 'East South Central', '161950', 'Alabama'),
       ('0300000US6', 'East South Central', '161655', 'Kentucky'),
       ('0300000US6', 'East South Central', '161943', 'Mississippi'),
       ('0300000US6', 'East South Central', '161838', 'Tennessee'),
       --Division 7: West South Central
       ('0300000US7', 'West South Central', '161646', 'Arkansas'),
       ('0300000US7', 'West South Central', '224922', 'Louisiana'),
       ('0300000US7', 'West South Central', '161645', 'Oklahoma'),
       ('0300000US7', 'West South Central', '114690', 'Texas'),
       --Division 8: Mountain
       ('0300000US8', 'Mountain', '162018', 'Arizona'),
       ('0300000US8', 'Mountain', '161961', 'Colorado'),
       ('0300000US8', 'Mountain', '162116', 'Idaho'),
       ('0300000US8', 'Mountain', '162115', 'Montana'),
       ('0300000US8', 'Mountain', '165473', 'Nevada'),
       ('0300000US8', 'Mountain', '162014', 'New Mexico'),
       ('0300000US8', 'Mountain', '161993', 'Utah'),
       ('0300000US8', 'Mountain', '161991', 'Wyoming'),
       --Division 9: Pacific
       ('0300000US9', 'Pacific', '1116270', 'Alaska'),
       ('0300000US9', 'Pacific', '165475', 'California'),
       ('0300000US9', 'Pacific', '166563', 'Hawaii'),
       ('0300000US9', 'Pacific', '165476', 'Oregon'),
       ('0300000US9', 'Pacific', '165479', 'Washington');

--Populating relationship_stage
--Divisions -> states
INSERT INTO concept_relationship_stage
SELECT NULL as concept_id_1,
       NULL as concept_id_2,
       ds.state_concept_code as concept_code_1,
       ds.division_concept_code as concept_code_2,
       'OSM' as vocabulary_id_1,
       'US Census' as vocabulary_id_2,
       'Is a' as relationship_id,
       CAST('1970-01-01' AS DATE) as valid_start_date,
       CAST('2099-12-31' AS DATE) as valid_end_date,
       NULL as invalid_reason
FROM temp_div_states ds;

--Removing old relationships between USA and states
DELETE FROM concept_relationship_stage
    WHERE concept_code_2 = '148838'
AND concept_code_1 in (
        SELECT state_concept_code from temp_div_states
        );

--Clean up
DROP TABLE temp_div_states;