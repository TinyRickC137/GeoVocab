--Creating source tables
DROP TABLE IF EXISTS united_states_al2_al12_2018_01_03_v1;
CREATE TABLE united_states_al2_al12_2018_01_03_v1
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
    geom       varchar --Should be geometry(MultiPolygon,4326) instead.
);


DROP TABLE IF EXISTS united_states_al2_al12_2018_01_09_v2;
CREATE TABLE united_states_al2_al12_2018_01_09_v2
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
    geom       varchar --Should be geometry(MultiPolygon,4326) instead.
);


DROP TABLE IF EXISTS france_al2_al12_2018_01_11_v1;
CREATE TABLE france_al2_al12_2018_01_11_v1
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
    geom       varchar --Should be geometry(MultiPolygon,4326) instead.
);