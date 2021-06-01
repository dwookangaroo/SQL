create user c##bituser identified by bituser;

create table PHONE_BOOK (
    id number(10),
    name varchar2(20) not null,
    hp varchar2(30) not null,
    tel varchar2(30) not null,
    primary key (id)
);

select * from phone_book;
insert into phone_book
values(1, '고길동', '010-10**-23**', '02-43**-90**');
insert into phone_book
values(2, '바보', '010-86**-91**', '031-9**-77**');
insert into phone_book
values(3, '거북이', '010-0002-1231', '02-123-1234');
insert into phone_book
values(4, '토끼', '010-0212-1331', '02-143-4434');
commit;

create sequence seq_phone_book_pk
    start with 1
    increment by 1
    minvalue 1
    maxvalue 100000000
    nocache;
grant select on phone_book to c##bituser;


grant create session to c##bituser;
grant connect, resource to c##bituser;
alter user c##bituser default tablespace users quota unlimited on users;

select * from phone_book;

