--Creation of concept_stage
DROP TABLE IF EXISTS concept_stage
;

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
)
;

--Creation of concept_synonym_stage
DROP TABLE IF EXISTS concept_synonym_stage
;

CREATE TABLE concept_synonym_stage
(
	synonym_concept_id integer,
	synonym_name varchar(1000),
	synonym_concept_code varchar(50),
	synonym_vocabulary_id varchar(20),
	language_concept_id integer
)
;

--Creation of concept_relationship_stage
DROP TABLE IF EXISTS concept_relationship_stage
;

CREATE TABLE concept_relationship_stage
(
  concept_id_1     integer,
  concept_id_2     integer,
  concept_code_1   varchar(50),
  concept_code_2   varchar(50),
  vocabulary_id_1  varchar(20),
  vocabulary_id_2  varchar(20),
  relationship_id  varchar(20),
  valid_start_date date,
  valid_end_date   date,
  invalid_reason   varchar(1)
)
;

--Population of concept_stage
INSERT INTO concept_stage
SELECT NULL AS concept_id,
	   name AS concept_name,
	   'Geography' AS domain_id,
	   'OSM' AS vocabulary_id,
	   CASE adminlevel :: INT
		   WHEN 2 THEN '2nd level'
		   WHEN 3 THEN '3rd level'
		   WHEN 4 THEN '4th level'
		   WHEN 5 THEN '5th level'
		   WHEN 6 THEN '6th level'
		   WHEN 7 THEN '7th level'
		   WHEN 8 THEN '8th level'
		   WHEN 9 THEN '9th level'
		   WHEN 10 THEN '10th level'
		   WHEN 11 THEN '11th level'
		   WHEN 12 THEN '12th level' END as concept_class_id,
	   'S' as standard_concept,
	   id as concept_code,
	   '1970-01-01' :: DATE as valid_start_date,
	   '2099-12-31' :: DATE as valid_end_date,
	   NULL as invalid_reason
FROM boundaries_hierarchy
;

--Population of concept_synonym_stage
--locname
INSERT INTO concept_synonym_stage
SELECT NULL as synonym_concept_id,
	   locname as synonym_name,
	   id as synonym_concept_code,
	   'OSM' as synonym_vocabulary_id,
	   CASE country
		   WHEN 'BEL' THEN 4180186
		   WHEN 'BRA' THEN 4181536
		   WHEN 'CAN' THEN 4180190
		   WHEN 'CHN' THEN 4182948
		   WHEN 'DEU' THEN 4182504
		   WHEN 'DNK' THEN 4180183
		   WHEN 'ESP' THEN 4182511
		   WHEN 'FRA' THEN 4180190
		   WHEN 'GBR' THEN 4180186
		   WHEN 'ISR' THEN CASE WHEN locname ~* 'א‬|ב|ג|ד|ה|ו|ז|ח|ט|י|מ|נ|ם|ן|פ|צ|ף|ץ|ס|ע|ק|ר|ש|ת|ל|כ|ך' THEN 4180047
		                        WHEN locname !~* 'א‬|ב|ג|ד|ה|ו|ז|ח|ט|י|מ|נ|ם|ן|פ|צ|ף|ץ|ס|ע|ק|ר|ש|ת|ל|כ|ך' THEN 4181374 END
		   WHEN 'ITA' THEN 4182507
		   WHEN 'JPN' THEN 4181524
		   WHEN 'KOR' THEN 4175771
		   WHEN 'NLD' THEN 4182503
		   WHEN 'SAU' THEN 4181374
		   WHEN 'SWE' THEN 4175777
		   WHEN 'USA' THEN 4180186
		   WHEN 'ZAF' THEN 4180186
		   ELSE 0 END as language_concept_id
FROM boundaries_hierarchy
WHERE locname != name
;

--offname
INSERT INTO concept_synonym_stage
SELECT NULL as synonym_concept_id,
	   offname as synonym_name,
	   id as synonym_concept_code,
	   'OSM' as synonym_vocabulary_id,
	   CASE country
		   WHEN 'BEL' THEN 4180186
		   WHEN 'BRA' THEN 4181536
		   WHEN 'CAN' THEN 4180190
		   WHEN 'CHN' THEN 4182948
		   WHEN 'DEU' THEN 4182504
		   WHEN 'DNK' THEN 4180183
		   WHEN 'ESP' THEN 4182511
		   WHEN 'FRA' THEN 4180190
		   WHEN 'GBR' THEN 4180186
		   WHEN 'ISR' THEN CASE WHEN locname ~* 'א‬|ב|ג|ד|ה|ו|ז|ח|ט|י|מ|נ|ם|ן|פ|צ|ף|ץ|ס|ע|ק|ר|ש|ת|ל|כ|ך' THEN 4180047
		                        WHEN locname !~* 'א‬|ב|ג|ד|ה|ו|ז|ח|ט|י|מ|נ|ם|ן|פ|צ|ף|ץ|ס|ע|ק|ר|ש|ת|ל|כ|ך' THEN 4181374 END
		   WHEN 'ITA' THEN 4182507
		   WHEN 'JPN' THEN 4181524
		   WHEN 'KOR' THEN 4175771
		   WHEN 'NLD' THEN 4182503
		   WHEN 'SAU' THEN 4181374
		   WHEN 'SWE' THEN 4175777
		   WHEN 'USA' THEN 4180186
		   WHEN 'ZAF' THEN 4180186
		   ELSE 0 END as language_concept_id
FROM boundaries_hierarchy
WHERE   offname != name
	AND offname != locname
;



--202722
SELECT COUNT (*)
FROM boundaries_hierarchy a
;

--Just name is used
--184622
SELECT COUNT (*)
FROM boundaries_hierarchy a
WHERE (name = enname OR enname IS NULL)
  AND (name = locname OR locname IS NULL)
  AND (name = offname OR offname IS NULL)
;

--enname is always useless since it's equal to name if NOT NULL
--0
SELECT *
FROM boundaries_hierarchy a
WHERE (name != enname)
;

--locname
SELECT *
FROM boundaries_hierarchy a
WHERE locname != name
;


--Hebrew language
SELECT *
FROM boundaries_hierarchy a
WHERE country = 'ISR' AND locname != name
AND locname !~* 'א‬|ב|ג|ד|ה|ו|ז|ח|ט|י|מ|נ|ם|ן|פ|צ|ף|ץ|ס|ע|ק|ר|ש|ת|ל|כ|ך'
ORDER BY locname
;


--CHN parcing
SELECT id,
       locname,
       regexp_replace(regexp_split_to_table (locname, ' / | \('), '\)$', ''),
	   CASE WHEN regexp_replace(regexp_split_to_table (locname, ' / | \('), '\)$', '') ~* '' THEN 'Eng'
		   END as language

FROM boundaries_hierarchy a
WHERE locname != name
	AND country = 'CHN'
;

--offname
SELECT *
FROM boundaries_hierarchy a
WHERE   offname != name
	AND offname != locname
;





--Population of concept_relationship_stage
--Is a relationship
INSERT INTO concept_relationship_stage
SELECT NULL as concept_id_1,
       NULL as concept_id_2,
       id as concept_code_1,
       firts_ancestor_id as concept_code_2,
       'OSM' as vocabulary_id_1,
       'OSM' as vocabulary_id_2,
       'Is a' as relationship_id,
       '1970-01-01' :: DATE as valid_start_date,
       '2099-12-31' :: DATE as valid_end_date,
       NULL as invalid_reason
FROM boundaries_hierarchy
WHERE firts_ancestor_id != '0'
;

--Subsumes relationship
INSERT INTO concept_relationship_stage
SELECT NULL as concept_id_1,
       NULL as concept_id_2,
       firts_ancestor_id as concept_code_1,
       id as concept_code_2,
       'OSM' as vocabulary_id_1,
       'OSM' as vocabulary_id_2,
       'Subsumes' as relationship_id,
       '1970-01-01' :: DATE as valid_start_date,
       '2099-12-31' :: DATE as valid_end_date,
       NULL as invalid_reason
FROM boundaries_hierarchy
WHERE firts_ancestor_id != '0'
;