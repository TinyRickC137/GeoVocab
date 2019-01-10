--not existing rows in each table--
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
from united_states_al2_al12 us full outer join united_states_al2_al12_2018_01_09 usn
    ON us.id = usn.id AND us.name = usn.name and us.rpath = usn.rpath
where us.id IS NULL OR usn.id IS NULL;

--Finding concepts with name and hierarchy changes--
--Name changed--
SELECT us.id as id, 'Name changed' as changes, us.name as old_name, usn.name as new_name,
       us.rpath as old_rpath, usn.rpath as new_rpath
FROM united_states_al2_al12 us
LEFT JOIN united_states_al2_al12_2018_01_09 usn ON us.id = usn.id
    Where us.name != usn.name
UNION
--Rpath_changed--
SELECT us.id as id, 'Path changed' as changes, us.name as old_name, usn.name as new_name,
       us.rpath as old_rpath, usn.rpath as new_rpath
FROM united_states_al2_al12 us
LEFT JOIN united_states_al2_al12_2018_01_09 usn ON us.id = usn.id
    Where us.rpath != usn.rpath
ORDER BY changes;

--Finding concepts with broken hierarchy (ID is not the end of rpath)--
SELECT us.id, us.name, us.rpath
FROM united_states_al2_al12 us
WHERE us.id != CAST((regexp_split_to_array(us.rpath, ','))[1] as INT);


--Lower or the same admin level cannot be the parent of higher admin level--
-- (EXCLUDED BROKEN HIERARCHY)--
select us.id, us.name, us.adminlevel, bh.closest_ancestor, us2.name, us2.adminlevel
from united_states_al2_al12 us
join bound_hierarchy bh on CAST(bh.concept_code AS INT) = us.id
join united_states_al2_al12 us2 ON CAST(bh.closest_ancestor AS INT) = us2.id
where (us.adminlevel < us2.adminlevel OR us.adminlevel = us2.adminlevel)
AND us.id NOT IN (
    select us3.id
from united_states_al2_al12 us3
where us3.id != CAST((regexp_split_to_array(us3.rpath, ','))[1] as INT)
    );