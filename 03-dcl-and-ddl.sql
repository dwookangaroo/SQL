------------
--사용자 관련
-------------
--system 계정으로 수행
-- create (생성), alter(수정), drop(삭제) 키워드

--사용자 생성
create user C##KANGDW identified by 1234;
-- 비밀번호 변경
alter user C##KANGDW identified by test;
--사용자 삭제
drop user C##KANGDW;
--경우에 따라 내부에 테이블 등 데이터베이스 객체가 생성된 사용자
drop user C##KANGDW cascade; -- 폭포수

-- 다시 사용자 만들자
create user C##KANGDW identified by 1234;
--SQLPlus로 접속 시도

-- 사용자 생성, 권한 부여되지 않으면 아무 일도 할수없다

-- 사용자 정보의 확인
--user_users : 현재 사용자 관련정보
--all_users : 전체 사용자 정보
--dba_users : 모든 사용자의 상세 정보(DBA전용)
desc user_users;
select * from user_users;

desc all_users;
select * from all_users;

desc dba_users;
select * from dba_users;

--사용자 계정에게 접속 권한 부여
grant create session to C##KANGDW;
--일반적으로 데이터베이스 접속, 테이블 만들어 사용하려면
--connect, resource 롤을 부여 (system 권한 or 역할)

grant connect, resource to C##KANGDW;
-- oracle 12이상에서는 사용자 테이블 스페이스에 공간 부여 필요
alter user C##KANGDW default tablespace users quota unlimited on users;

--system 권한의 부여
-- grant 권한(역할)명 to 사용자
--시스템 권한의 박탈
--revoke 권한(역할)명 from 사용자

-- 스키마 객체에 대한 권한의 부여
--grant 권한 on 객체 to 사용자
--스키마 객체 권한의 박탈
--revoke 권한 on 객체 from 사용자
grant select on hr.employees to c##kangdw;
grant select on hr.departments to c##kangdw;

-- 이하, 사용자 계정으로 수행
select * from hr.employees;
select * from hr.departments;

--system 계정으로 hr.departments의 select 권한 회수
revoke select on hr.departments from c##kangdw;

--다시 사용자 계정으로
select * from hr.departments;

-----------------------------
--DDL
---------------------------
create table book ( -- 괄호속에 컬럼의 정의
    book_id number(5), -- 5자리 정수타입 -> pk로 변경할 예정
    title varchar2(50), -- 50자리 가변 문자열
    author varchar2(10), -- 10자리의 가변 문자열
    pub_date date default sysdate -- 날짜 타입(기본값은 현재날짜와시간)
);
desc book;

--서브 쿼리를 이용한 새 테이블 생성
--hr.employees 테이블에서 일부 데이터를 추출, 새 테이블 생성
select * from hr.employees where job_id like 'IT_%'; -- 서브쿼리 결과로 새테이블 생성

create table it_emp as(
    select * from hr.employees 
    where job_id like 'IT_%'
);

desc it_emp;
select * from it_emp;

-- 내가 가진 테이블의 목록
select * from tab;

--테이블 삭제
drop table it_emp;
select * from tab;
-- 휴지통 비우기
PURGE recyclebin;
select * from tab;

desc book;

--테이블 추가
create table author(
    author_id number(10),
    author_name varchar2(100) not null, --컬럼 제약조건 not null 부여
    author_desc varchar2(500),
    primary key (author_id) -- 테이블 제약조건    
);
desc book;
desc author;

-- book 테이블의 author 컬럼을 삭제(양도햇으니)
-- 나중에 author 테이블과 연결
alter table book drop column author; --author 컬럼 삭제
desc book;

--author.author_id를 참조하기 위한 author_id 컬럼을 book테이블에 추가
alter table book add (author_id number(10));
desc book;

--book.book_id number(10)으로 바꿔 봅니다
alter table book modify(book_id number(10));
desc book;

-- book.author_id -> author.author_id를 참조하도록 변경(fk)
alter table book
add constraint 
    fk_author_id foreign key(author_id)
                    references author(author_id);
-- book 테이블의 author_id 컬럼에
--      author테이블의 author_id(pk)를 참조하는 외래 키(fk) 추가
desc book;


--------------------------
--data dictionary
-------------------------
--오라클이 관리하는 데이터베이스 관련 정보들을 모아둔 특별한 용도의 테이블
--user_ : 현재 로그인한 사용자 레발의 객체들
--all_ : 사용자 전체 대상의 정보
--dba_ : 데이터베이스 전체에 관련된 정보들(관리자 전용)

--모든 딕셔너리 확인
select * from dictionary;

-- 사용자 스키마 객체 확인: user_objects
select * from user_objects;
select object_name, object_type from user_objects;

-- 내가 가진 제약 조건: user_constraints
select * from user_constraints;

-- book 테이블에 걸려 있는 제약조건 확인
select constraint_name,
    constraint_type,
    search_condition
from user_constraints
where table_name = 'BOOK';








