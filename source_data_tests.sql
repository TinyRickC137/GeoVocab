--TODO: check old and new IDs changes: if they are changed when hierarchy changes

--COMMON CHECKS
--Count of records
SELECT COUNT (*)
FROM osm_all_countries;

--Absence of not-unique IDs
SELECT id, count(*)
FROM osm_all_countries
GROUP BY id
HAVING COUNT(*) > 1;

--Counts of records by Country
SELECT country, COUNT (*)
FROM osm_all_countries
GROUP BY country;


--Adminlevels distribution
SELECT adminlevel, COUNT (*)
FROM osm_all_countries
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
FROM osm_all_countries
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
FROM osm_all_countries
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
FROM osm_all_countries
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
FROM osm_all_countries t
JOIN osm_all_countries t1
    ON (regexp_split_to_array(t.rpath, ','))[1] :: INT = t1.id
JOIN osm_all_countries t2
    ON (regexp_split_to_array(t.rpath, ','))[2] :: INT = t2.id

WHERE (t1.adminlevel = t2.adminlevel OR t1.adminlevel < t2.adminlevel)

  AND t.id not in (

    SELECT id
    FROM osm_all_countries
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
--TESTS for different versions of one country--
-----------------------------------------------

--not existing rows in each table
--current version: old USA vs new USA
SELECT us.id as old_id,
       usn.id as new_id,
       CASE
           WHEN usn.id IS NULL THEN 'Deprecated area ID'
           ELSE 'New area ID'
       END AS changes,
       us.name as old_name,
       usn.name as new_name,
       us.rpath as old_rpath,
       usn.rpath as new_rpath
from united_states_al2_al12_2018_01_03_v1 us full outer join united_states_al2_al12_2018_01_09_v2 usn
    ON us.id = usn.id and us.name = usn.name and us.rpath = usn.rpath
where us.id IS NULL OR usn.id IS NULL;


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
	   s.iso3166_2
FROM osm_all_countries s

LEFT JOIN osm_all_countries s2
	ON	(regexp_split_to_array(s.rpath, ','))[2] :: INT = s2.id

WHERE s.id = (regexp_split_to_array(s.rpath, ','))[1] :: INT
AND s.adminlevel = s2.adminlevel
;












