--TODO: use parameterized sql where it is possible
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


--Lower or the same admin level cannot be the parent of higher admin level--
--(EXCLUDED BROKEN HIERARCHY)--
SELECT us.id, us.name, us.adminlevel, bh.closest_ancestor, us2.name, us2.adminlevel
FROM united_states_al2_al12_2018_01_03_v1 us
JOIN bound_hierarchy bh on bh.concept_code = us.id
JOIN united_states_al2_al12_2018_01_03_v1 us2 ON bh.closest_ancestor = us2.id
WHERE (us.adminlevel < us2.adminlevel OR us.adminlevel = us2.adminlevel)
AND us.id NOT IN (
    SELECT us3.id
FROM united_states_al2_al12_2018_01_03_v1 us3
WHERE us3.id != CAST((regexp_split_to_array(us3.rpath, ','))[1] as INT)
    );


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
    ON us.id = usn.id AND us.name = usn.name and us.rpath = usn.rpath
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