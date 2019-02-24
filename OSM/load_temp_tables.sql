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

--Creation of excluded_objects table
DROP TABLE IF EXISTS excluded_objects
;

CREATE TABLE IF NOT EXISTS excluded_objects AS
    (
    SELECT * FROM boundaries_hierarchy WHERE FALSE
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
		   	WHEN s.adminlevel = s2.adminlevel AND s2.adminlevel = s3.adminlevel AND s3.adminlevel = s4.adminlevel AND s4.adminlevel > s5.adminlevel THEN (regexp_split_to_array(s.rpath, ','))[5] :: INT
		   	WHEN s.adminlevel = 2 THEN (regexp_split_to_array(s.rpath, ','))[2] :: INT
            ELSE 1
		   	END as first_ancestor_id,
       CASE WHEN s.adminlevel > s2.adminlevel THEN (regexp_split_to_array(s.rpath, ','))[3] :: INT
		   	WHEN s.adminlevel = s2.adminlevel AND s2.adminlevel > s3.adminlevel THEN (regexp_split_to_array(s.rpath, ','))[4] :: INT
		   	WHEN s.adminlevel = s2.adminlevel AND s2.adminlevel = s3.adminlevel AND s3.adminlevel > s4.adminlevel THEN (regexp_split_to_array(s.rpath, ','))[5] :: INT
		   	WHEN s.adminlevel = s2.adminlevel AND s2.adminlevel = s3.adminlevel AND s3.adminlevel = s4.adminlevel AND s4.adminlevel > s5.adminlevel THEN (regexp_split_to_array(s.rpath, ','))[6] :: INT
		   	WHEN s.adminlevel = 2 THEN (regexp_split_to_array(s.rpath, ','))[2] :: INT
            ELSE 1
		   	END as second_ancestor_id

FROM osm_2019_02_15 s

LEFT JOIN osm_2019_02_15 s2
	ON	(regexp_split_to_array(s.rpath, ','))[2] :: INT = s2.id

LEFT JOIN osm_2019_02_15 s3
	ON	(regexp_split_to_array(s.rpath, ','))[3] :: INT = s3.id

LEFT JOIN osm_2019_02_15 s4
	ON	(regexp_split_to_array(s.rpath, ','))[4] :: INT = s4.id

LEFT JOIN osm_2019_02_15 s5
	ON	(regexp_split_to_array(s.rpath, ','))[5] :: INT = s5.id

WHERE s.id = (regexp_split_to_array(s.rpath, ','))[1] :: INT
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

FROM osm_2019_02_15 s

LEFT JOIN osm_2019_02_15 s1
	ON	(regexp_split_to_array(s.rpath, ','))[1] :: INT = s1.id

LEFT JOIN osm_2019_02_15 s3
	ON	(regexp_split_to_array(s.rpath, ','))[3] :: INT = s3.id

LEFT JOIN osm_2019_02_15 s4
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
		   	WHEN s.adminlevel = s1.adminlevel AND s.adminlevel = s2.adminlevel AND s.adminlevel = s4.adminlevel AND s.adminlevel = s5.adminlevel AND s.adminlevel > s10.adminlevel THEN (regexp_split_to_array(s.rpath, ','))[10] :: INT
			ELSE 1
		   	END as first_ancestor_id,
	   CASE WHEN s.adminlevel = s1.adminlevel AND s.adminlevel = s2.adminlevel AND s.adminlevel > s4.adminlevel THEN (regexp_split_to_array(s.rpath, ','))[5] :: INT
		   	WHEN s.adminlevel = s1.adminlevel AND s.adminlevel = s2.adminlevel AND s.adminlevel = s4.adminlevel AND s.adminlevel > s5.adminlevel THEN (regexp_split_to_array(s.rpath, ','))[6] :: INT
		   	WHEN s.adminlevel = s1.adminlevel AND s.adminlevel = s2.adminlevel AND s.adminlevel = s4.adminlevel AND s.adminlevel = s5.adminlevel AND s.adminlevel > s10.adminlevel THEN (regexp_split_to_array(s.rpath, ','))[11] :: INT
			ELSE 1
		   	END as second_ancestor_id

FROM osm_2019_02_15 s

LEFT JOIN osm_2019_02_15 s1
	ON	(regexp_split_to_array(s.rpath, ','))[1] :: INT = s1.id

LEFT JOIN osm_2019_02_15 s2
	ON	(regexp_split_to_array(s.rpath, ','))[2] :: INT = s2.id

LEFT JOIN osm_2019_02_15 s4
	ON	(regexp_split_to_array(s.rpath, ','))[4] :: INT = s4.id

LEFT JOIN osm_2019_02_15 s5
	ON	(regexp_split_to_array(s.rpath, ','))[5] :: INT = s5.id

LEFT JOIN osm_2019_02_15 s10
	ON	(regexp_split_to_array(s.rpath, ','))[10] :: INT = s10.id

WHERE s.id = (regexp_split_to_array(s.rpath, ','))[3] :: INT
    AND s.id != (regexp_split_to_array(s.rpath, ','))[1] :: INT
;

CREATE INDEX idx_bh_id on boundaries_hierarchy(id);
CREATE INDEX idx_bh_name on boundaries_hierarchy(name);
ANALYZE boundaries_hierarchy;

--Excluding the useless & no name objects & >2 count objects
INSERT INTO excluded_objects
SELECT *
FROM boundaries_hierarchy
WHERE (name in ('(Neighborhood)', '平野', '村元', 'CFAD Bedford Magazine')
	OR name ilike '%-banchi'
    OR name ~* '(Bear River|Membertou|Millbrook|Acadia|Pictou|Sipekne''katik)( First Nation)'
    OR name ~* '^\d*$'
 --counterpart objects
	OR id in (8864148, 8864203, 8863644, 8554903, 6890921, 341752, 341751, 8864429, 9078749, 627469724, 5776358, 7698707, 5815542, 8612543, 5812080, 9069117, 5289198, 7311462, 7311463, 4494994, 6596786, 112818, 4748341, 4755073)
--wrong objects
	OR id in (8481365, 9103732, 8476276, 6151013, 8283183, 9232301, 1790468, 8209939, 9122618, 3695278, 3185371, 7272976, 8118162, 6769003, 8864042, 3891647, 3883997, 8885026, 6188421, 7297827, 8325776, 5316707, 6190799,
	5317611, 5326982, 6634642, 8461523, 8274922, 5316882, 9256382, 9133146, 7516050, 9245215, 9236300, 7400296, 5668303, 7783258, 2618987, 1614222, 64630, 3807709, 2725328, 8864116, 3879477, 3879474, 8880546,
	3881347, 3884282, 3884273, 8552675, 8885351, 8855702, 3011419, 5683043, 1969640, 6933036, 6891043, 7284117, 7311459, 7300811, 7389694, 2743802, 5476350, 112987, 133295, 3545808, 110743, 113000, 112361, 125443, 112421,
	112395, 8249855, 110692, 141058, 110825, 3460806, 110547, 7008694, 5999407, 8539828, 4618535, 4559221, 8277846, 8250162, 8288009, 8246892, 8540079, 8288011, 5543342, 8158336, 8534055, 7311466, 4536855,904177, 7037589, 8250156,
	8250158, 4603713, 4103691, 9107923, 6164994, 4002153, 8201989, 8199182, 6932977, 9215366, 4142039, 4142040, 9252171, 9302983, 6893574, 4079756, 9266970, 6164118, 3959632)
--wrong objects from different adminlevels, but equal geometry
   OR id in (5808786, 3884168, 6210876, 6992297, 6355818, 5231035, 8402981, 6242282, 6992286, 4587947, 6891534, 8388202, 3856703, 7182975, 7159794, 5758866, 5758865, 7783254, 7815256, 7763854, 3565868, 7972501, 8101735, 5190251))
AND id NOT in (5012169)
AND id not in (SELECT id FROM excluded_objects)
;

--Delete from boundaries_hierarchy
DELETE FROM boundaries_hierarchy
WHERE id in (SELECT id FROM excluded_objects)
;

--Delete counterpart objects with same geometry but without wikidata
INSERT INTO excluded_objects
SELECT *
FROM boundaries_hierarchy
WHERE id in (
	SELECT MIN (a2.id)
	FROM boundaries_hierarchy a1
	JOIN boundaries_hierarchy a2
		ON a1.country = a2.country  AND a1.id != a2.id AND a1.name = a2.name AND a1.firts_ancestor_id = a2.firts_ancestor_id
	JOIN osm_2019_02_15 osm1
        ON a1.id = osm1.id
	JOIN osm_2019_02_15 osm2
        ON a2.id = osm2.id
	WHERE osm1.geom = osm2.geom
		AND (a1.wikidata IS NOT NULL OR a1.wikimedia IS NOT NULL)
	GROUP BY a1.name
	HAVING COUNT (*) = 1
	)
AND id not in (SELECT id FROM excluded_objects)
;

--Delete from boundaries_hierarchy
DELETE FROM boundaries_hierarchy
WHERE id in (SELECT id FROM excluded_objects)
;

--Delete counterpart objects with same geometry, but higher id
INSERT INTO excluded_objects
SELECT *
FROM boundaries_hierarchy
WHERE id in (
	SELECT MAX (a2.id)
	FROM boundaries_hierarchy a1
	JOIN boundaries_hierarchy a2
		ON a1.country = a2.country  AND a1.id != a2.id AND a1.name = a2.name AND a1.firts_ancestor_id = a2.firts_ancestor_id
	JOIN osm_2019_02_15 osm1
        ON a1.id = osm1.id
	JOIN osm_2019_02_15 osm2
        ON a2.id = osm2.id
	WHERE osm1.geom = osm2.geom
	GROUP BY a1.name
	HAVING COUNT (*) = 2
	)
AND id not in (SELECT id FROM excluded_objects)
;

--Delete from boundaries_hierarchy
DELETE FROM boundaries_hierarchy
WHERE id in (SELECT id FROM excluded_objects)
;

--Excluding the useless & no name & counterpart objects in UK
INSERT INTO excluded_objects
SELECT *
FROM boundaries_hierarchy
WHERE name in ('Glebe', 'Mullaghmore', 'Ballykeel', 'Tully', 'Cabragh', 'Tamlaght', 'Dromore', 'Ballymoney', 'Greenan', 'Gorteen')
AND country = 'GBR'
AND adminlevel = 10
AND NOT (id = 4452073 AND firts_ancestor_id not in (156393, 1119534)) --Glebe
AND NOT (id = 5416800 AND firts_ancestor_id not in (156393, 1117773)) --Glebe
AND NOT (id = 5481741 AND firts_ancestor_id not in (156393)) --Glebe
AND NOT (id = 5321265 AND firts_ancestor_id not in (156393, 1117773)) --Mullaghmore
AND NOT (id = 4167260 AND firts_ancestor_id not in (156393, 1119534)) --Ballykeel
AND NOT (id = 3631266 AND firts_ancestor_id not in (156393, 1118085)) --Tully
AND NOT (id = 5476251 AND firts_ancestor_id not in (156393)) --Cabragh
AND NOT (id = 3629081 AND firts_ancestor_id not in (156393)) --Tamlaght
AND NOT (id = 267762718 AND firts_ancestor_id not in (156393)) --Tamlaght
AND NOT (id in (267763207, 267762836) AND firts_ancestor_id not in (156393)) --Dromore
AND NOT (id = 1604307220 AND firts_ancestor_id not in (156393)) --Ballymoney
AND NOT (id = 4519571 AND firts_ancestor_id not in (156393, 1119534)) --Ballymoney
AND id not in (SELECT id FROM excluded_objects);

--Delete from boundaries_hierarchy
DELETE FROM boundaries_hierarchy
WHERE id in (SELECT id FROM excluded_objects)
;

--Excluding the useless & no name & counterpart (>2) objects in UK
INSERT INTO excluded_objects
SELECT *
FROM boundaries_hierarchy
WHERE name in (
    SELECT a1.name
    FROM boundaries_hierarchy a1
    JOIN boundaries_hierarchy a2
        ON a1.country = a2.country AND a1.id != a2.id AND a1.name = a2.name AND a1.firts_ancestor_id = a2.firts_ancestor_id
    GROUP BY a1.name
    HAVING COUNT (*) > 2
    )
AND country = 'GBR'
AND adminlevel = 10
AND id NOT in (4868152, 5218754, 5225378, 2895940, 5160147)
AND id not in (SELECT id FROM excluded_objects);

--Delete from boundaries_hierarchy
DELETE FROM boundaries_hierarchy
WHERE id in (SELECT id FROM excluded_objects)
;

--Excluding the counterpart (=2) objects in UK
INSERT INTO excluded_objects
SELECT *
FROM boundaries_hierarchy
WHERE id in (SELECT MIN(a1.id)
             FROM boundaries_hierarchy a1
	                  JOIN boundaries_hierarchy a2
	                  ON a1.country = a2.country AND a1.id != a2.id AND a1.name = a2.name AND a1.firts_ancestor_id = a2.firts_ancestor_id AND a1.adminlevel = a2.adminlevel
	                  JOIN osm_2019_02_15 osm1 ON a1.id = osm1.id
	                  JOIN osm_2019_02_15 osm2 ON a2.id = osm2.id
             WHERE st_area(osm1.geom :: geography) < st_area(osm2.geom :: geography)
             GROUP BY a1.name
             HAVING COUNT(*) = 1)
AND country = 'GBR'
AND adminlevel = 10
AND wikidata IS NULL
AND wikimedia IS NULL
AND id not in (SELECT id FROM excluded_objects);
;

--...and their counterparts
INSERT INTO excluded_objects
SELECT *
FROM boundaries_hierarchy
WHERE id in (SELECT MIN(a1.id)
             FROM boundaries_hierarchy a1
	                  JOIN boundaries_hierarchy a2
	                  ON a1.country = a2.country AND a1.id != a2.id AND a1.name = a2.name AND a1.firts_ancestor_id = a2.firts_ancestor_id AND a1.adminlevel = a2.adminlevel
	                  JOIN osm_2019_02_15 osm1 ON a1.id = osm1.id
	                  JOIN osm_2019_02_15 osm2 ON a2.id = osm2.id
             WHERE st_area(osm1.geom :: geography) > st_area(osm2.geom :: geography)
             GROUP BY a1.name
             HAVING COUNT(*) = 1)
AND country = 'GBR'
AND adminlevel = 10
AND wikidata IS NULL
AND wikimedia IS NULL
AND id not in (SELECT id FROM excluded_objects);
;

--Delete from boundaries_hierarchy
DELETE FROM boundaries_hierarchy
WHERE id in (SELECT id FROM excluded_objects)
;

--update firts_ancestor_id if parent was deleted
UPDATE boundaries_hierarchy
SET firts_ancestor_id = second_ancestor_id
WHERE id in (
	SELECT *--a.id
	FROM boundaries_hierarchy a
	JOIN excluded_objects b
	ON a.firts_ancestor_id = b.id
	)
	AND country != 'CAN'
;

UPDATE boundaries_hierarchy
SET firts_ancestor_id = 3960529
WHERE id in (3960533, 3960532)
;
UPDATE boundaries_hierarchy
SET firts_ancestor_id = 9150813
WHERE id in (9150812)
;
UPDATE boundaries_hierarchy
SET firts_ancestor_id = 5884638
WHERE id in (206873)
;

--delete remaining children of excluded objects
INSERT INTO excluded_objects
SELECT *
FROM boundaries_hierarchy
WHERE id in (
	SELECT a.id
	FROM boundaries_hierarchy a
	JOIN excluded_objects b
		ON a.firts_ancestor_id = b.id
	)
;

--Delete from boundaries_hierarchy
DELETE FROM boundaries_hierarchy
WHERE id in (SELECT id FROM excluded_objects)
;

--Index
DROP INDEX idx_bh_id;
DROP INDEX idx_bh_name;
CREATE INDEX idx_bh_id on boundaries_hierarchy(id);
CREATE INDEX idx_bh_name on boundaries_hierarchy(name);
ANALYZE boundaries_hierarchy;