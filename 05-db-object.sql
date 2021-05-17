---------------------
--Db object
----------------

--system 계정 create view 권한 부여
grant create view to c##kangdw;
-- 사용자 계정으로 복귀

-- SimpleView
-- 단일 테이블, 함수나 연산식을 포함한 컬럼이 없는 단순 뷰
drop table emp123;
create table emp123
    as select * from hr.employees
        where department_id in (10, 20, 30);
select * from emp123;

--emp123 테이블을 기반으로 30 번 부서 사원들만 보여주는 view
create or replace view emp10
    as select employee_id, first_name, last_name, salary
        from emp123
        where department_id = 10;
        
desc emp10;

--view는 테이블처럼 select 할수있다.
-- 다만 실제데이터는 원본 테이블 내에 있는 데이터를 활용
-- view는 데이터를 갖고있지 않다.
select * from emp10;
select first_name || ' ' || last_name, salary from emp10;

--simple view는 제약 상황에 위배되지 않는다면 내용을 갱신할수있다
-- salary를 2배로 올려봅시다
select first_name, salary from emp10;

update emp10 set salary = salary *2; --view를 갱신 (emp123을 기반으로)
select first_name, salary from emp10;
select first_name, salary from emp123;
rollback;

--view는 가급적 조회용으로만 사용하도록하자
--read only 옵션을 부여해서 view를 생성
create or replace view emp10
    as select employee_id, first_name, last_name, salary
        from emp123
        where department_id = 10
    with read only;
    
select * from emp10;

update emp10 set salary = salary * 2; --일기전용 뷰에서는 dml작업 수행 불가

--복합 뷰 complex뷰
desc author;
desc book;
-- author와 book을 join 정보를 출력하는 복합뷰
create or replace view book_detail
    (book_id, title, author_name, pub_date)
    as (select book_id,
            title,
            author_name,
            pub_date
        from book b, author a
        where b.author_id = a.author_id);
        
desc book_detail;

select * from book_detail;

update book_detail set author_name='unknown';
--복합 뷰에서는 기본적으로 dml 수행항수 없다.

-- View 확인을 위한 dictionary
select * from user_views;
-- 특정 view의 정보 확인을 위해 where 절에 view_name을 지정하면 된다.
select view_name, text from user_views
where view_name = 'BOOK_DETAIL';

--user_objects 테이블을 이용한 확인
select * from USER_objects
where object_type = 'VIEW';

--view의 삭제
drop view book_detail;
select * from user_views;

--INDEX : 검색 속도 개선을 위한 데이터베이스 객체
--hr.employees의 테이블을 기반으로 s_emp 생성
create table s_emp
    as select * from hr.employees;
    
--s_emp 테이블의 employee_id 컬럼에 UNIQUE INDEx를 생성
select * from s_emp;
create unique index s_emp_id_pk
    on s_emp (employee_id); -- s_emp 테이블의 employee_id 컬럼에
                            --unique index를 부여

--사용자가 가지고있는 인덱스를 확인
select * from user_indexes;
--어느 컬럼에 인덱스가 걸려 있는지 확인
select * from user_ind_columns;
--두테이블 조인, 어느인덱스가 어느 컬럼에 걸려 있는지 확인
select 
    t.index_name,
    t.table_name,
    c.column_name,
    c.column_position
from user_indexes t, user_ind_columns c
where t.index_name = c.index_name and
    t.table_name = 'S_EMP';
    
--INDEX는
--where절, join절에서 빈번하게 사용되는 컬럼
-- 자주 업데이트되는 테이블의 경우, 인덱스 계속 갱신해야함
-- -> 인덱스가 DB성능을 저하시킬수있다.
-- 꼭필요한 컬럼에만 인덱스 부여 권장

--인덱스의 제거
drop index s_emp_id_pk;
select * from user_indexes;

--SEQUENCE
--author 테이블에 새 레코드 삽입
desc author;
select * from author;

--author.author_id max 확인
select max(author_id) from author;

-- 새로운 author 추가
insert into author(author_id, author_name)
    values( (select max(author_id) + 1 from author), 'unknown');
select * from author;

--유일한 pk를 확보해야 할 경우, 위 방법은 안전하지 않을수 있다.
-- sequence를 이용, 유일한 정수 값을 확보

rollback;

--시퀀스 생성
select max(author_id) + 1 from author;

create sequence seq_author_id
    start with 3
    increment by 1
    minvalue 1
    maxvalue 100000000
    nocache;
    
-- 시퀀스를 이용한 pk의 부여
insert into author (author_id, author_name)
values (seq_author_id.nextval, 'Steven King');

select * from author;
commit;

-- 새 시퀀스 하나 생성
create sequence my_seq
    start with 1
    increment by 1
    maxvalue 10
    nocache;

-- 새 시퀀스 생성
select my_seq.nextval from dual; -- 시퀀스 증가시키고 반환
select my_seq.currval from dual; -- 시퀀스의 현재값

--시퀀스 수정
alter sequence my_seq
    increment by 2
    maxvalue 10000000;
    
select my_seq.currval from dual;
select my_seq.nextval from dual;--값이 2씩 증가

--시퀀스를 위한 딕셔너리
select * from user_sequences;

select * from user_objects where object_type = 'SEQUENCE';

--book_id를 이용한 시퀀스도 추가해 봅시다
select max(book_id) from book;

create sequence seq_book_id
    start with 3
    minvalue 1
    increment by 1
    maxvalue 100000;
    
select * from user_sequences;




