drop table if exists users;
create table if not exists users(
    id serial primary key,
    first_name varchar(255),
    last_name varchar(255),
    phone_number varchar(255),
    email varchar(255),
    password varchar(255)
);

drop table if exists authentication_logs;
create table if not exists authentication_logs(
    id serial primary key,
    user_id integer,
    login_time timestamp default current_timestamp,
    ip_addr varchar(255)
);

drop table if exists images_info;
create table if not exists images_info(
    id serial primary key,
    user_id integer,
    image_name varchar(255),
    image_size integer,
    mime_type varchar(255)
);