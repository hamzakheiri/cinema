drop table if exists sessions cascade;
drop table if exists authentication_logs cascade;
drop table if exists images_info cascade;
drop table if exists users cascade;
drop table if exists films cascade;
drop table if exists halls cascade;

create table if not exists users(
    id bigserial primary key,
    first_name varchar(255) not null,
    last_name varchar(255) not null,
    phone_number varchar(255) not null,
    email varchar(255) not null unique,
    password varchar(255) not null,
    role varchar(50) not null default 'ADMIN'
);

create table if not exists authentication_logs(
    id bigserial primary key,
    user_id bigint not null,
    login_time timestamp not null default current_timestamp,
    ip_addr varchar(255) not null,
    constraint fk_auth_logs_user foreign key (user_id) references users(id) on delete cascade
);

create table if not exists films(
    id bigserial primary key,
    title varchar(255) not null unique,
    year integer not null,
    age_restrictions integer not null,
    description text not null,
    poster_url varchar(500)
);

create table if not exists halls(
    id bigserial primary key,
    serial_number varchar(255) not null unique,
    seats integer not null
);

create table if not exists sessions(
    id bigserial primary key,
    ticket_cost numeric(10,2) not null,
    session_time timestamp not null,
    film_id bigint not null,
    hall_id bigint not null,
    constraint fk_sessions_film foreign key (film_id) references films(id) on delete cascade,
    constraint fk_sessions_hall foreign key (hall_id) references halls(id) on delete cascade
);

create table if not exists images_info(
    id bigserial primary key,
    user_id bigint,
    image_name varchar(255),
    image_size integer,
    mime_type varchar(255),
    constraint fk_images_user foreign key (user_id) references users(id) on delete cascade
);