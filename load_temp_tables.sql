--to check id 3496792, 114559

--Creation of boundaries_hierarchy table
DROP TABLE IF EXISTS boundaries_hierarchy
;

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
    firts_ancestor_id integer,
    second_ancestor_id integer
)
;

--Creation of levenshtein values table
DROP TABLE IF EXISTS levenshtein_values
;

CREATE TABLE IF NOT EXISTS levenshtein_values
(	id_1 integer,
	id_2 integer,
	levenshtein_value integer
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
		   	WHEN s.adminlevel = s2.adminlevel AND s2.adminlevel = s3.adminlevel AND s3.adminlevel > s4.adminlevel THEN (regexp_split_to_array(s.rpath, ','))[4] :: INT
		   	WHEN s.adminlevel = 2 THEN (regexp_split_to_array(s.rpath, ','))[2] :: INT
            ELSE 1
		   	END as first_ancestor_id,
       CASE WHEN s.adminlevel > s2.adminlevel THEN (regexp_split_to_array(s.rpath, ','))[3] :: INT
		   	WHEN s.adminlevel = s2.adminlevel AND s2.adminlevel > s3.adminlevel THEN (regexp_split_to_array(s.rpath, ','))[4] :: INT
		   	WHEN s.adminlevel = s2.adminlevel AND s2.adminlevel = s3.adminlevel AND s3.adminlevel > s4.adminlevel THEN (regexp_split_to_array(s.rpath, ','))[5] :: INT
		   	WHEN s.adminlevel = 2 THEN (regexp_split_to_array(s.rpath, ','))[2] :: INT
            ELSE 1
		   	END as second_ancestor_id

FROM osm_all_countries s

LEFT JOIN osm_all_countries s2
	ON	(regexp_split_to_array(s.rpath, ','))[2] :: INT = s2.id

LEFT JOIN osm_all_countries s3
	ON	(regexp_split_to_array(s.rpath, ','))[3] :: INT = s3.id

LEFT JOIN osm_all_countries s4
	ON	(regexp_split_to_array(s.rpath, ','))[4] :: INT = s4.id

WHERE s.id = (regexp_split_to_array(s.rpath, ','))[1] :: INT
;

--there is no id in rpath
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
	   CASE WHEN s.adminlevel > s1.adminlevel THEN (regexp_split_to_array(s.rpath, ','))[1] :: INT
			ELSE 1
		   	END as first_ancestor_id,
	   CASE WHEN s.adminlevel > s1.adminlevel THEN (regexp_split_to_array(s.rpath, ','))[2] :: INT
			ELSE 1
		   	END as second_ancestor_id

FROM osm_all_countries s

LEFT JOIN osm_all_countries s1
	ON	(regexp_split_to_array(s.rpath, ','))[1] :: INT = s1.id

WHERE s.rpath !~ ('(?<=(^|\,))' || s.id :: VARCHAR || '(?=\,)')
;

--id has the 2nd position in rpath
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
	   CASE WHEN s.adminlevel = s1.adminlevel AND s.adminlevel > s3.adminlevel THEN (regexp_split_to_array(s.rpath, ','))[3] :: INT
		   	WHEN s.adminlevel = s3.adminlevel AND s3.adminlevel > s4.adminlevel THEN (regexp_split_to_array(s.rpath, ','))[4] :: INT
			ELSE 1
		   	END as first_ancestor_id,
	   CASE WHEN s.adminlevel = s1.adminlevel AND s.adminlevel > s3.adminlevel THEN (regexp_split_to_array(s.rpath, ','))[4] :: INT
		   	WHEN s.adminlevel = s3.adminlevel AND s3.adminlevel > s4.adminlevel THEN (regexp_split_to_array(s.rpath, ','))[5] :: INT
			ELSE 1
		   	END as second_ancestor_id

FROM osm_all_countries s

LEFT JOIN osm_all_countries s1
	ON	(regexp_split_to_array(s.rpath, ','))[1] :: INT = s1.id

LEFT JOIN osm_all_countries s3
	ON	(regexp_split_to_array(s.rpath, ','))[3] :: INT = s3.id

LEFT JOIN osm_all_countries s4
	ON	(regexp_split_to_array(s.rpath, ','))[4] :: INT = s4.id

WHERE s.id = (regexp_split_to_array(s.rpath, ','))[2] :: INT
    AND s.id != (regexp_split_to_array(s.rpath, ','))[1] :: INT
;

--id has the 3rd position in rpath
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
	   CASE WHEN s.adminlevel = s1.adminlevel AND s.adminlevel = s2.adminlevel AND s.adminlevel > s4.adminlevel THEN (regexp_split_to_array(s.rpath, ','))[4] :: INT
		   	WHEN s.adminlevel = s1.adminlevel AND s.adminlevel = s2.adminlevel AND s.adminlevel = s4.adminlevel AND s.adminlevel > s5.adminlevel THEN (regexp_split_to_array(s.rpath, ','))[5] :: INT
			ELSE 1
		   	END as first_ancestor_id,
	   CASE WHEN s.adminlevel = s1.adminlevel AND s.adminlevel = s2.adminlevel AND s.adminlevel > s4.adminlevel THEN (regexp_split_to_array(s.rpath, ','))[5] :: INT
		   	WHEN s.adminlevel = s1.adminlevel AND s.adminlevel = s2.adminlevel AND s.adminlevel = s4.adminlevel AND s.adminlevel > s5.adminlevel THEN (regexp_split_to_array(s.rpath, ','))[6] :: INT
			ELSE 1
		   	END as second_ancestor_id

FROM osm_all_countries s

LEFT JOIN osm_all_countries s1
	ON	(regexp_split_to_array(s.rpath, ','))[1] :: INT = s1.id

LEFT JOIN osm_all_countries s2
	ON	(regexp_split_to_array(s.rpath, ','))[2] :: INT = s2.id

LEFT JOIN osm_all_countries s4
	ON	(regexp_split_to_array(s.rpath, ','))[4] :: INT = s4.id

LEFT JOIN osm_all_countries s5
	ON	(regexp_split_to_array(s.rpath, ','))[5] :: INT = s5.id

WHERE s.id = (regexp_split_to_array(s.rpath, ','))[3] :: INT
    AND s.id != (regexp_split_to_array(s.rpath, ','))[1] :: INT
;

CREATE INDEX idx_bh_id on boundaries_hierarchy(id);
CREATE INDEX idx_bh_name on boundaries_hierarchy(name);
ANALYZE boundaries_hierarchy;

--Population of levenshtein values table
INSERT INTO levenshtein_values
SELECT a.id, a1.id, levenshtein (regexp_replace(a.name, '(?<=( |^))\w(?=( |$))|\d*|(?<=( |^))(I*L*V*X*I*L*V*X*I*L*V*X*I*L*V*X*I*L*V*X*)(?!\w)', '', 'g'), regexp_replace(a1.name, '(?<=( |^))\w(?=( |$))|\d*|(?<=( |^))(I*L*V*X*I*L*V*X*I*L*V*X*I*L*V*X*I*L*V*X*)(?!\w)', '', 'g'))
FROM boundaries_hierarchy a

JOIN boundaries_hierarchy a1
         ON a.country = a1.country AND a.id != a1.id AND (a.firts_ancestor_id = a1.firts_ancestor_id OR a.firts_ancestor_id = a1.id )
;

CREATE INDEX idx_levenshtein_id1 on levenshtein_values(id_1);
CREATE INDEX idx_levenshtein_id2 on levenshtein_values(id_2);
CREATE INDEX idx_levenshtein_values on levenshtein_values(levenshtein_value);
ANALYZE levenshtein_values;


SELECT l.id_1, s1.name, regexp_replace(s1.name, '(?<=( |^))\w(?=( |$))|\d*|(?<=( |^))(I*L*V*X*I*L*V*X*I*L*V*X*I*L*V*X*I*L*V*X*)(?!\w)', '', 'g')--, l.id_2, s2.name, l.levenshtein_value

FROM levenshtein_values l

JOIN osm_all_countries s1
    ON l.id_1 = s1.id

JOIN osm_all_countries s2
    ON l.id_2 = s2.id

WHERE levenshtein_value = 1
;






SELECT COUNT(*)
FROM boundaries_hierarchy
;

SELECT COUNT(*)
FROM osm_all_countries
;



SELECT adminlevel
FROM osm_all_countries
WHERE id = 8617158;





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