---------
--join
-----------

--employees와 departments 테이블 확인
desc employees;
desc departments;

select * from employees; -- 107개
select * from departments; -- 27개

select first_name, department_name
from employees, departments;
-- 두테이블의 조합가능한 모든 쌍이 출력된다
-- 카티전 프로젝트, cross join
-- 일반적으로는 이런결과를 원하지는 않을것

-- 두 테이블의 연결 조건을 where절에 부여한다 -> simple join
select * 
from employees, departments
where employees.department_id = departments.department_id; -- 106

--필드의 모호성을 해소하기 위해서 테이블명 혹은 alias를 부여한다
select first_name,
    emp.department_id,
    dept.department_id,
    department_name
from employees emp, departments dept
where emp.department_id = dept.department_id;

--inner join
select emp.first_name,dept.department_name
from employees emp join departments dept
                    using (department_id);
                    
select first_name, department_name
from employees emp join departments dept
                    on emp.department_id = dept.department_id;
                    -- on 은 join의 조건을 명시할떄 사용한다
                    
select first_name, department_name
from employees natural join departments; --natural join
--같은 이름을 가진 컬럼을 기준으로 join한다

--theta join
--특정 조건을 기준으로 join을 하되
--그 조건이 = 이 아닌경우
-- non-equi join이라고 한다
select * from jobs where job_id='FI_MGR';

select first_name, salary 
from employees emp, jobs j
where j.job_id = 'FI_MGR' and salary between j.min_salary and j.max_salary;

----------------
--outer join
---------------
--1.조건이 만족하는 짝이 없는 레코드도 null을 포함해서 결과를 출력
--2 모든 레코드를 출력할 테이블이 어느 위치에 있는가에 따라서 left, right, full
--3. oracle sql의 경우 null이 출력 될수있는 쪽 조건에 (+)을 붙여준다

--inner join
select first_name,
    emp.department_id,
    dept.department_id,
    department_name
from employees emp, departments dept
where emp.department_id = dept.department_id;--106

-- 전체사원수
select count(*) from employees;--107

-- 짝이없는(부서 id가 null인)직원
select first_name, department_id
from employees
where department_id is null;

--left outer join: 짝이없어도 왼쪽의 테이블 전체를 출력에 참여
--1.oracle sql
select first_name,
    emp.department_id,
    dept.department_id,
    department_name
from employees emp, departments dept
where emp.department_id = dept.department_id (+);

--2.ansi sql
--1,2 똑같음
select first_name,
    emp.department_id,
    dept.department_id,
    department_name
from employees emp left outer join departments dept
                    on emp.department_id = dept.department_id;
                    
--right outer join
--오른쪽 테이블의 모든 레코드를 출력에 참여 -> 왼쪽테이블에 매칭되는 짝이없는 경우
-- 왼쪽테이블 컬럼이 null로 표기된다

--oracle sql
select
    first_name,
    emp.department_id,
    dept.department_id,
    department_name
from employees emp, departments dept
where emp.department_id (+) = dept.department_id;

--ansi sql
select
    first_name,
    emp.department_id,
    dept.department_id,
    department_name
from employees emp right outer join departments dept
                    on emp.department_id = dept.department_id;

--full outer join
--양쪽 테이블 모두 짝이없어도 출력에 참여
--error
--select first_name,
--    emp.department_id,
--    dept.department_id,
--    department_name
--from employees emp, department dept
--where emp.department_id (+) = dept.department_id (+);

--ansi sql
select first_name,
    emp.department_id,
    dept.department_id,
    department_name
from employees emp full outer join departments dept
                    on emp.department_id = dept.department_id;

-- join 연습
-- 부서id,부서명,부서속한 도시명, 도시속한 국가명 출력
select department_id,
    department_name,
    city,
    country_name
from departments dept, locations loc join countries co
                                on loc.country_id = co.country_id
where dept.location_id = loc.location_id
order by dept.department_id asc;

--or

select department_id,
        department_name,
        city,
        country_name
from departments dept,
    locations loc,
    countries co
where dept.location_id = loc.location_id and
    loc.country_id = co.country_id
order by department_id asc;

-------------
--self join
--------------
--자기 자신과 join
--한개의 테이블을 두번이상 사용해야하기떄문에 반드시 alias 사용

select * from employees; --총 사원수 107명

--사원의 아이디, 이름, 매니저 아이디, 매니저 이름 출려
select emp.employee_id,
    emp.first_name, --사원의정보
    emp.manager_id,
    man.first_name
from employees emp join employees man
                    on emp.manager_id = man.employee_id; --106명

select emp.employee_id,
    emp.first_name,
    emp.manager_id,
    man.first_name
from employees emp, employees man
where emp.manager_id = man.employee_id; --106명

select * from employees
where manager_id is null; --이사람도 출력시켜줘야한다!
                            --join 사용
                        
-- manager가 없는 사람도 출력해보자
select emp.employee_id,
    emp.first_name,
    emp.manager_id,
    man.first_name
from employees emp, employees man
where emp.manager_id = man.employee_id (+);


