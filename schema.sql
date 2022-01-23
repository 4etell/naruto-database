create table fights
(
    id         bigserial primary key,
    start_date timestamp,
    end_date   timestamp,
    event_id   bigint
);
create table weapons
(
    id            bigserial primary key,
    name          text    not null,
    type          text,
    damage_points integer not null
        check ( damage_points >= 0 )
);
create table creatures
(
    id            bigserial primary key,
    name          text    not null,
    birth_date    timestamp,
    damage_points integer not null,
    country_id    bigint
        check ( damage_points >= 0 )
);
create table events
(
    id          bigserial primary key,
    start_date  timestamp,
    end_date    timestamp,
    type        text,
    name        text not null,
    description text
);
create table shinobi
(
    id              bigserial primary key,
    name            text    not null,
    surname         text,
    birth_date      timestamp,
    health_points   integer not null,
    rank            text,
    chakra_reserve  integer not null,
    damage_points   integer not null,
    clan_id         bigint,
    team_id         bigint,
    school_id       bigint,
    village_id      bigint,
    organization_id bigint
        check ( health_points >= 0 and chakra_reserve >= 0 and damage_points >= 0)
);
create table elements
(
    id   bigserial primary key,
    name text not null
);
create table techniques
(
    id                bigserial primary key,
    name              text    not null,
    complexity_points integer not null,
    damage_points     integer not null,
    type              text,
    heal_points       integer not null,
    chakra_cost       integer not null,
    description       text
        check ( complexity_points >= 0 and damage_points >= 0 and heal_points >= 0 and chakra_cost >= 0)
);
create table hand_seals
(
    id   bigserial primary key,
    name text not null
);
create table schools
(
    id   bigserial primary key,
    name text not null
);
create table clans
(
    id          bigserial primary key,
    name        text not null,
    description text,
    leader_id   bigint unique,
    village_id  bigint
);
create table villages
(
    id         bigserial primary key,
    name       text not null,
    country_id bigint,
    kage_id    bigint unique
);
create table teams
(
    id         bigserial primary key,
    name       text not null,
    village_id bigint,
    leader_id  bigint unique
);
create table organizations
(
    id          bigserial primary key,
    name        text not null,
    description text,
    village_id  bigint,
    leader_id   bigint unique
);
create table countries
(
    id        bigserial primary key,
    name      text not null,
    daimyo_id bigint unique
);
create table scrolls
(
    id   bigserial primary key,
    name text not null,
    type text
);

create table winners_in_fights
(
    fight_id   bigint references fights,
    shinobi_id bigint references shinobi,
    primary key (fight_id, shinobi_id)
);

create table shinobi_in_fights
(
    fight_id   bigint references fights,
    shinobi_id bigint references shinobi,
    primary key (fight_id, shinobi_id)
);

create table shinobi_in_events
(
    event_id   bigint references events,
    shinobi_id bigint references shinobi,
    primary key (event_id, shinobi_id)
);

create table creatures_in_fights
(
    fight_id    bigint references fights,
    creature_id bigint references creatures,
    primary key (fight_id, creature_id)
);

create table creature_weapons
(
    creature_id bigint references creatures,
    weapon_id   bigint references weapons,
    primary key (creature_id, weapon_id)
);

create table shinobi_weapons
(
    shinobi_id bigint references shinobi,
    weapon_id  bigint references weapons,
    primary key (shinobi_id, weapon_id)
);

create table shinobi_creatures
(
    shinobi_id  bigint references shinobi,
    creature_id bigint references creatures,
    primary key (shinobi_id, creature_id)
);

create table creatures_in_events
(
    event_id    bigint references events,
    creature_id bigint references creatures,
    primary key (event_id, creature_id)
);

create table shinobi_elements
(
    shinobi_id bigint references shinobi,
    element_id bigint references elements,
    primary key (shinobi_id, element_id)
);

create table shinobi_techniques
(
    shinobi_id   bigint references shinobi,
    technique_id bigint references techniques,
    primary key (shinobi_id, technique_id)
);

create table creature_techniques
(
    creature_id  bigint references creatures,
    technique_id bigint references techniques,
    primary key (creature_id, technique_id)
);

create table technical_elements
(
    technique_id bigint references techniques,
    element_id   bigint references elements,
    primary key (technique_id, element_id)
);

create table clan_techniques
(
    clan_id      bigint references clans,
    technique_id bigint references techniques,
    primary key (clan_id, technique_id)
);

create table shinobi_scrolls
(
    shinobi_id bigint references shinobi,
    scroll_id  bigint references scrolls,
    primary key (shinobi_id, scroll_id)
);

create table organization_techniques
(
    organization_id bigint references organizations,
    technique_id    bigint references techniques,
    primary key (organization_id, technique_id)
);

create table creature_scrolls
(
    creature_id bigint references creatures,
    scroll_id   bigint references scrolls,
    primary key (creature_id, scroll_id)
);

create table technical_seals
(
    technique_id bigint references techniques,
    seal_id      bigint references hand_seals,
    cast_order   integer not null,
    check ( cast_order >= 0 ),
    primary key (technique_id, seal_id, cast_order)
);


create table scroll_techniques
(
    scroll_id    bigint references scrolls,
    technique_id bigint references techniques,
    primary key (scroll_id, technique_id)
);

alter table if exists fights
    add constraint fights_events_fk
        foreign key (event_id) references events;

alter table if exists creatures
    add constraint creatures_countries_fk
        foreign key (country_id) references countries;

alter table if exists shinobi
    add constraint shinobi_clans_fk
        foreign key (clan_id) references clans;

alter table if exists shinobi
    add constraint shinobi_team_fk
        foreign key (team_id) references teams;

alter table if exists shinobi
    add constraint shinobi_schools_fk
        foreign key (school_id) references schools;

alter table if exists shinobi
    add constraint shinobi_villages_fk
        foreign key (village_id) references villages;

alter table if exists shinobi
    add constraint shinobi_organizations_fk
        foreign key (organization_id) references organizations;

alter table if exists clans
    add constraint clans_leader_shinobi_fk
        foreign key (leader_id) references shinobi;

alter table if exists clans
    add constraint clans_villages_fk
        foreign key (village_id) references villages;

alter table if exists villages
    add constraint villages_countries_fk
        foreign key (country_id) references countries;

alter table if exists villages
    add constraint villages_kage_shinobi_fk
        foreign key (kage_id) references shinobi;

alter table if exists teams
    add constraint teams_leader_shinobi_fk
        foreign key (leader_id) references shinobi;

alter table if exists teams
    add constraint teams_villages_fk
        foreign key (village_id) references villages;

alter table if exists organizations
    add constraint organizations_leader_shinobi_fk
        foreign key (leader_id) references shinobi;

alter table if exists organizations
    add constraint organizations_villages_fk
        foreign key (village_id) references villages;

alter table if exists countries
    add constraint countries_daimyo_shinobi_fk
        foreign key (daimyo_id) references shinobi;