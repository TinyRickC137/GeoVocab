--Creating source table--
DROP TABLE IF EXISTS united_states_al2_al12;
CREATE TABLE united_states_al2_al12
(
    gid        integer,
    id         integer,
    country    varchar(254),
    name       varchar(254),
    enname     varchar(254),
    locname    varchar(254),
    offname    varchar(254),
    boundary   varchar(254),
    adminlevel integer,
    wikidata   varchar(254),
    wikimedia  varchar(254),
    timestamp  varchar(254),
    note       varchar(254),
    rpath      varchar(254),
    iso3166_2  varchar(254),
    geom       varchar
);
