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