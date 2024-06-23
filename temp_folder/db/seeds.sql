drop table if exists users;
drop table if exists brand_list;
drop table if exists holdings;
drop table if exists stock_value_week;
drop table if exists stock_value_month;

create table users(
    id text,
    username text,
    password text
);

create table brand_list(
    brand_name text
);

create table holdings(
    id text,
    brand_name text
);

create table stock_value_week(
    brand_name text,
    order integer,
    value real
);

create table stock_value_month(
    brand_name test,
    order integer,
    value real
);

insert into users values ('test', 'ryota', 'twins');
insert into brand_list values ('AAPL');
insert into holdings values('test', 'AAPL');
