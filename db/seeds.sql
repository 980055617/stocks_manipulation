drop table if exists users;
drop table if exists brand_list;
drop table if exists holdings;
drop table if exists stock_value_week;
drop table if exists stock_value_month;

create table users(
    username text,
    password text
);

create table brand_list(
    brand_name text
);

create table holdings(
    username text,
    order_no integer,
    brand_name text
);

create table stock_value_week(
    brand_name text,
    order_no integer,
    time text,
    high real,
    low real,
    open real,
    close real
);

create table stock_value_month(
    brand_name test,
    order_no integer,
    time text,
    high real,
    low real,
    open real,
    close real
);

insert into users values ('ryota', 'twins');
insert into brand_list values ('AAPL');
insert into holdings values('ryota', 1, 'AAPL');
