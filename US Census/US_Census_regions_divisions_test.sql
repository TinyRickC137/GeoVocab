--All States and equivalents not covered by regions and divisions
--(They shouldn't)
SELECT cr.concept_code_1, cs.concept_code, cs.concept_name, cs.concept_class_id FROM concept_relationship_stage cr
join concept_stage cs on cr.concept_code_1 = cs.concept_code
WHERE concept_code_2 = '148838' --USA
AND concept_code_1 not in ('0200000US1', '0200000US2', '0200000US3', '0200000US4'); --regions

--Each concept has relationship
SELECT * FROM concept_stage
WHERE vocabulary_id = 'US Census'
AND concept_code NOT IN
    (SELECT concept_code_1 FROM concept_relationship_stage);

SELECT * FROM concept_stage
WHERE vocabulary_id = 'US Census'
AND concept_code NOT IN
    (SELECT concept_code_2 FROM concept_relationship_stage);