--TODO: check old and new IDs changes: if they are changed when hierarchy changes

--COMMON CHECKS
--Count of records
SELECT COUNT (*)
FROM osm_2019_02_12;

--Absence of not-unique IDs
SELECT id, count(*)
FROM osm_2019_02_12
GROUP BY id
HAVING COUNT(*) > 1;

--Counts of records by Country
SELECT country, COUNT (*)
FROM osm_2019_02_12
GROUP BY country;


--Adminlevels distribution
SELECT adminlevel, COUNT (*)
FROM osm_2019_02_12
GROUP BY adminlevel
ORDER BY adminlevel;

--Consistency of hierarchy in upper parent
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
FROM osm_2019_02_12
WHERE rpath !~ '\,0$'
;

--Finding records with broken hierarchy (ID is not the beginning of rpath)
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
FROM osm_2019_02_12
WHERE id != (regexp_split_to_array(rpath, ','))[1] :: INT;

--Finding the position of id in rpath in records with broken hierarchy
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
       iso3166_2,
    CASE
    when id = (regexp_split_to_array(rpath, ','))[2] :: INT THEN '2'
    when id = (regexp_split_to_array(rpath, ','))[3] :: INT THEN '3'
    when id = (regexp_split_to_array(rpath, ','))[4] :: INT THEN '4'
    when id = (regexp_split_to_array(rpath, ','))[5] :: INT THEN '5'
    when id = (regexp_split_to_array(rpath, ','))[6] :: INT THEN '6'
    when id = (regexp_split_to_array(rpath, ','))[7] :: INT THEN '7'
    when id = (regexp_split_to_array(rpath, ','))[8] :: INT THEN '8'
    when id = (regexp_split_to_array(rpath, ','))[9] :: INT THEN '9'
    when id = (regexp_split_to_array(rpath, ','))[10] :: INT THEN '10'
    when id = (regexp_split_to_array(rpath, ','))[11] :: INT THEN '11'
    when id = (regexp_split_to_array(rpath, ','))[12] :: INT THEN '12'
    when id = (regexp_split_to_array(rpath, ','))[13] :: INT THEN '13'
    when id = (regexp_split_to_array(rpath, ','))[14] :: INT THEN '14'
    when id = (regexp_split_to_array(rpath, ','))[15] :: INT THEN '15'
    ELSE '0'
    end as place_of_its_own_id
FROM osm_2019_02_12
WHERE id != (regexp_split_to_array(rpath, ','))[1] :: INT
ORDER BY place_of_its_own_id;

--Lower or the same admin level cannot be the parent of higher admin level
--(EXCLUDING BROKEN HIERARCHY)
SELECT t.gid,
       t.id,
       t.country,
       t.name,
       t.enname,
       t.locname,
       t.offname,
       t.boundary,
       t.adminlevel,
       t.wikidata,
       t.wikimedia,
       t.timestamp,
       t.note,
       t.rpath,
       t.iso3166_2
FROM osm_2019_02_12 t
JOIN osm_2019_02_12 t1
    ON (regexp_split_to_array(t.rpath, ','))[1] :: INT = t1.id
JOIN osm_2019_02_12 t2
    ON (regexp_split_to_array(t.rpath, ','))[2] :: INT = t2.id

WHERE (t1.adminlevel = t2.adminlevel OR t1.adminlevel < t2.adminlevel)

  AND t.id not in (

    SELECT id
    FROM osm_2019_02_12
    WHERE id != (regexp_split_to_array(rpath, ','))[1] :: INT
    )
;

--Finding counterparts with same rpath--
select id, name, adminlevel, rpath
from osm_all_countries
where rpath in (
select rpath
from osm_all_countries
group by rpath, name, adminlevel
having count(rpath) > 1)
order by rpath;

-----------------------------------------------
--TESTS for different versions
-----------------------------------------------

--new ids & deprecated ids
SELECT old.id as old_id,
       new.id as new_id,
       CASE
           WHEN new.id IS NULL THEN 'Deprecated ID'
           WHEN old.id IS NULL THEN 'New ID'
       END AS changes,
       old.name as old_name,
       new.name as new_name,
       old.rpath as old_rpath,
       new.rpath as new_rpath
from united_states_al2_al12_2018_01_03 old

full outer join united_states_al2_al12_2018_01_09 new
    ON old.id = new.id-- and old.name = new.name and old.rpath = new.rpath

where old.id IS NULL OR
      new.id IS NULL
;


--Finding concepts with name and hierarchy changes
--Name changed
SELECT us.id as id, 'Name changed' as changes, us.name as old_name, usn.name as new_name,
       us.rpath as old_rpath, usn.rpath as new_rpath
FROM united_states_al2_al12_2018_01_03_v1 us
LEFT JOIN united_states_al2_al12_2018_01_09_v2 usn ON us.id = usn.id
    Where us.name != usn.name
UNION


--Rpath_changed--
SELECT us.id as id, 'Path changed' as changes, us.name as old_name, usn.name as new_name,
       us.rpath as old_rpath, usn.rpath as new_rpath
FROM united_states_al2_al12_2018_01_03_v1 us
LEFT JOIN united_states_al2_al12_2018_01_09_v2 usn ON us.id = usn.id
    Where us.rpath != usn.rpath
ORDER BY changes;


--Select object by id
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
FROM united_states_al2_al12
WHERE id = 119133;





--counterparts with equal geography
CREATE TABLE counterparts (id_1 integer, id_2 integer);

INSERT INTO counterparts
SELECT a1.id as id_1, a2.id as id_2
FROM boundaries_hierarchy a1

JOIN boundaries_hierarchy a2
         ON a1.country = a2.country AND a1.id != a2.id --AND (/*a1.firts_ancestor_id = a2.firts_ancestor_id OR*/ a1.firts_ancestor_id = a2.id)

JOIN osm_2019_02_15 osm1
    ON a1.id = osm1.id

JOIN osm_2019_02_15 osm2
    ON a2.id = osm2.id

WHERE osm1.geom = osm2.geom
;

SELECT c.id_1, c.id_2, a1.name, a1.enname, a1.locname, a1.offname, a2.name, a2.enname, a2.locname, a2.offname
FROM counterparts c

JOIN boundaries_hierarchy a1
	ON c.id_1 = a1.id

JOIN boundaries_hierarchy a2
	ON c.id_2 = a2.id

WHERE a1.adminlevel < a2.adminlevel
	AND regexp_replace(a1.name, '^Town of |^City of |^Ortsbeirat \d+ : | City$', '') = regexp_replace (a2.name, '^Gemarkung | Adentro$| City$', '')
	AND (regexp_replace(a1.locname, '^Town of |^City of |^Ortsbeirat \d+ : | City$', '') = regexp_replace (a2.locname, '^Gemarkung | Adentro$| City$', '') OR (a1.locname IS NULL AND a2.locname IS NULL))
	AND (a1.offname = a2.offname OR (a1.offname IS NULL AND a2.offname IS NULL))
	AND a2.firts_ancestor_id != a1.id
	--AND c.id_1 NOT IN (71525, 1641193, 7444, 2796746, 5190243, 5190251) -->2 objects with the same geometry
;


SELECT a1.id, a1.name, a1.locname, a2.id, a2.name, a2.locname,
       st_distance(osm1.geom::geography, osm2.geom::geography) as distance,
       --st_distance((st_pointonsurface(osm1.geom)::geography), (st_pointonsurface(osm2.geom)::geography)) as distance_pos,
       --st_distance((ST_Centroid(osm1.geom::geography)), (ST_Centroid(osm2.geom::geography))) as distance_centroid,
       st_area (osm2.geom::geography) / st_area (osm1.geom::geography) as area_factor,
	   st_area (osm1.geom::geography) as area_1,
	   st_area (osm2.geom::geography) as area_2,
	   CASE WHEN st_distance(osm1.geom::geography, osm2.geom::geography) > 0 THEN
	       (|/ st_area (osm2.geom::geography)) / st_distance(osm1.geom::geography, osm2.geom::geography)
		ELSE 0 END as factor

--a1.name, COUNT (*)

FROM boundaries_hierarchy a1

JOIN boundaries_hierarchy a2
         ON a1.country = a2.country AND a1.id != a2.id AND a1.name = a2.name AND (a1.firts_ancestor_id = a2.firts_ancestor_id /*OR a1.firts_ancestor_id = a2.id*/) AND a1.adminlevel = a2.adminlevel

 JOIN osm_2019_02_15 osm1
    ON a1.id = osm1.id

JOIN osm_2019_02_15 osm2
    ON a2.id = osm2.id


WHERE st_area (osm1.geom::geography) < st_area (osm2.geom::geography)
	AND (a1.locname = a2.locname OR (a1.locname IS NULL AND a2.locname IS NULL))
	AND (a1.enname = a2.enname OR (a1.enname IS NULL AND a2.enname IS NULL))
	AND (a1.offname = a2.offname OR (a1.offname IS NULL AND a2.offname IS NULL))
	--AND (|/ st_area (osm2.geom::geography)) > st_distance(osm1.geom::geography, osm2.geom::geography)
--GROUP BY a1.name
--HAVING COUNT(*) = 2
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

SELECT l.id_1, s1.name, l.id_2, s2.name, l.levenshtein_value

FROM levenshtein_values l

JOIN osm_all_countries s1
    ON l.id_1 = s1.id

JOIN osm_all_countries s2
    ON l.id_2 = s2.id

WHERE levenshtein_value = 1 AND s1.country in ('USA')
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

FROM osm_2019_02_15 s

LEFT JOIN osm_2019_02_15 s1
	ON	(regexp_split_to_array(s.rpath, ','))[1] :: INT = s1.id

WHERE s.rpath !~ ('(?<=(^|\,))' || s.id :: VARCHAR || '(?=\,)')
;