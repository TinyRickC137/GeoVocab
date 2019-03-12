--Creation of concept_stage
DROP TABLE IF EXISTS concept_stage;
CREATE TABLE concept_stage
(
	concept_id integer,
	concept_name varchar(255),
	domain_id varchar(20),
	vocabulary_id varchar(20) not null,
	concept_class_id varchar(20),
	standard_concept varchar(1),
	concept_code varchar(50) not null,
	valid_start_date date not null,
	valid_end_date date not null,
	invalid_reason varchar(1)
);

--Creation of concept_synonym_stage
DROP TABLE IF EXISTS concept_synonym_stage;
CREATE TABLE concept_synonym_stage
(
	synonym_concept_id integer,
	synonym_name varchar(1000) not null,
	synonym_concept_code varchar(50) not null,
	synonym_vocabulary_id varchar(20) not null,
	language_concept_id integer
);

--Creation of concept_relationship_stage
DROP TABLE IF EXISTS concept_relationship_stage;
CREATE TABLE concept_relationship_stage
(
	concept_id_1 integer,
	concept_id_2 integer,
	concept_code_1 varchar(50) not null,
	concept_code_2 varchar(50) not null,
	vocabulary_id_1 varchar(20) not null,
	vocabulary_id_2 varchar(20) not null,
	relationship_id varchar(20) not null,
	valid_start_date date not null,
	valid_end_date date not null,
	invalid_reason varchar(1)
);

--Creation of concept_relationship_manual
DROP TABLE IF EXISTS concept_relationship_manual;
CREATE TABLE concept_relationship_manual
(
	concept_code_1 varchar(50) not null,
	concept_code_2 varchar(50) not null,
	vocabulary_id_1 varchar(20) not null,
	vocabulary_id_2 varchar(20) not null,
	relationship_id varchar(20) not null,
	valid_start_date date not null,
	valid_end_date date not null,
	invalid_reason varchar(1)
);