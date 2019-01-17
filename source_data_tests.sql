--TODO: use parameterized sql where it is possible
--TODO: check old and new IDs changes: if they are changed when hierarchy changes
------------------------------------------------
------------------COMMON TESTS------------------
------------------------------------------------

--Finding the not-unique IDs--
SELECT us.id, us.name, count(us.id)
FROM united_states_al2_al12_2018_01_03_v1 us
GROUP BY us.id, us.name
HAVING COUNT(us.id) >1;


--Finding concepts with broken hierarchy (ID is not the end of rpath)--
SELECT us.id, us.name, us.rpath
FROM united_states_al2_al12_2018_01_09_v2 us
WHERE us.id != CAST((regexp_split_to_array(us.rpath, ','))[1] as INT);


--Finding the position of id in rpath if it is not the first--
SELECT usn.id, usn.name, usn.rpath,
CASE
    when usn.id = CAST((regexp_split_to_array(usn.rpath, ','))[2] as INT) THEN '2'
    when usn.id = CAST((regexp_split_to_array(usn.rpath, ','))[3] as INT) THEN '3'
    when usn.id = CAST((regexp_split_to_array(usn.rpath, ','))[4] as INT) THEN '4'
    end as place_of_its_own_id
FROM united_states_al2_al12_2018_01_09_v2 usn
WHERE usn.id != CAST((regexp_split_to_array(usn.rpath, ','))[1] as INT)
ORDER BY place_of_its_own_id;


--Lower or the same admin level cannot be the parent of higher admin level--
--(EXCLUDED BROKEN HIERARCHY)--
SELECT us.id, us.name, us.adminlevel, bh.closest_ancestor, us2.name, us2.adminlevel
FROM france_al2_al12_2018_01_11_v1 us
JOIN bound_hierarchy bh on bh.concept_code = us.id
JOIN france_al2_al12_2018_01_11_v1 us2 ON bh.closest_ancestor = us2.id
WHERE (us.adminlevel < us2.adminlevel OR us.adminlevel = us2.adminlevel)
AND us.id NOT IN (
    SELECT us3.id
FROM france_al2_al12_2018_01_11_v1 us3
WHERE us3.id != CAST((regexp_split_to_array(us3.rpath, ','))[1] as INT)
    );


--Finding Doppelgangers with same rpath--
select id, name, adminlevel, rpath from france_al2_al12_2018_01_11_v1
where rpath in (
select rpath
from france_al2_al12_2018_01_11_v1
group by rpath
having count(rpath) > 1)
order by rpath;

-----------------------------------------------
--TESTS for different versions of one country--
-----------------------------------------------

--not existing rows in each table--
--current version: old USA vs new USA--
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


--Finding concepts with name and hierarchy changes--
--Name changed--
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