--Creation of boundaries_hierarchy table
DROP TABLE IF EXISTS boundaries_hierarchy;
CREATE TABLE IF NOT EXISTS boundaries_hierarchy
(	gid integer,
	id integer,
	country varchar(254),
	name varchar(254),
	enname varchar(254),
	locname varchar(254),
	offname varchar(254),
	boundary varchar(254),
	adminlevel integer,
	wikidata varchar(254),
	wikimedia varchar(254),
	timestamp varchar(254),
	note varchar(254),
	rpath varchar(254),
	iso3166_2 varchar(254),
    ancestor_id integer
)
;

--Population of boundaries_hierarchy table
--id has the 1st position in rpath
INSERT INTO boundaries_hierarchy
SELECT s.gid,
	   s.id,
	   s.country,
	   s.name,
	   s.enname,
	   s.locname,
	   s.offname,
	   s.boundary,
	   s.adminlevel,
	   s.wikidata,
	   s.wikimedia,
	   s.timestamp,
	   s.note,
	   s.rpath,
	   s.iso3166_2,
	   CASE WHEN s.adminlevel > s2.adminlevel THEN (regexp_split_to_array(s.rpath, ','))[2] :: INT
		   	WHEN s.adminlevel = s2.adminlevel AND s2.adminlevel > s3.adminlevel THEN (regexp_split_to_array(s.rpath, ','))[3] :: INT
		   	WHEN s.adminlevel = s2.adminlevel AND s2.adminlevel = s3.adminlevel AND s3.adminlevel > s4.adminlevel THEN (regexp_split_to_array(s.rpath, ','))[3] :: INT
			ELSE 1
		   	END as ancestor_id

FROM osm_all_countries s

LEFT JOIN osm_all_countries s2
	ON	(regexp_split_to_array(s.rpath, ','))[2] :: INT = s2.id

LEFT JOIN osm_all_countries s3
	ON	(regexp_split_to_array(s.rpath, ','))[3] :: INT = s3.id

LEFT JOIN osm_all_countries s4
	ON	(regexp_split_to_array(s.rpath, ','))[4] :: INT = s4.id

WHERE s.id = (regexp_split_to_array(s.rpath, ','))[1] :: INT
AND s.adminlevel > 2;
;

--there is no id in rpath
INSERT INTO boundaries_hierarchy
SELECT s1.gid,
	   s1.id,
	   s1.country,
	   s1.name,
	   s1.enname,
	   s1.locname,
	   s1.offname,
	   s1.boundary,
	   s1.adminlevel,
	   s1.wikidata,
	   s1.wikimedia,
	   s1.timestamp,
	   s1.note,
	   s1.rpath,
	   s1.iso3166_2,
	   CASE WHEN s1.adminlevel > s2.adminlevel THEN (regexp_split_to_array(s1.rpath, ','))[2] :: INT
		   	WHEN s1.adminlevel = s2.adminlevel AND s2.adminlevel > s3.adminlevel THEN (regexp_split_to_array(s1.rpath, ','))[3] :: INT
		   	WHEN s1.adminlevel = s2.adminlevel AND s2.adminlevel = s3.adminlevel AND s3.adminlevel > s4.adminlevel THEN (regexp_split_to_array(s1.rpath, ','))[3] :: INT
			ELSE 1
		   	END as ancestor_id

FROM osm_all_countries s1

LEFT JOIN osm_all_countries s2
	ON	(regexp_split_to_array(s1.rpath, ','))[2] :: INT = s2.id

LEFT JOIN osm_all_countries s3
	ON	(regexp_split_to_array(s1.rpath, ','))[3] :: INT = s3.id

LEFT JOIN osm_all_countries s4
	ON	(regexp_split_to_array(s1.rpath, ','))[4] :: INT = s4.id

WHERE s1.rpath !~ (s1.id :: VARCHAR || '(?=\,)')
;

SELECT gid,
	   id,
	   country,
	   name,
	   enname,
	   locname,
	   offname,
	   boundary,
	   adminlevel,
	   wikidata,
	   wikimedia,
	   timestamp,
	   note,
	   rpath,
	   iso3166_2
FROM osm_all_countries
WHERE rpath !~ '\,0$'
;





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