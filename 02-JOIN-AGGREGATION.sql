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

--join 문제
--문제 1
select department_name,
    employee_id
from employees emp join departments dept
                    on emp.department_id = dept.department_id
order by department_name asc,
        employee_id desc;
        
--문제 2 ??
select employee_id,
    first_name,
    salary,
    department_name,
    job_title
from employees emp,
    departments dept,
    jobs j
where emp.employee_id = dept.manager_id
    and emp.job_id = j.job_id;

--문제 2-1

--문제3
select lc.location_id,
    city,
    department_name,
    department_id
from locations lc,
    departments dept
where lc.location_id = dept.location_id
order by city;

--문제3-1
select lc.location_id,
    city,
    department_name,
    department_id
from locations lc,
    departments dept
where lc.location_id = dept.location_id(+)
order by city;

--문제4
select region_name,
    country_name
from countries co,
    regions rg
where co.region_id = rg.region_id
order by region_name, country_name desc;

--문제5 ??
select emp.employee_id,
    emp.first_name,
    emp.hire_date,
    man.first_name,
    man.hire_date
from employees emp join employees man
                    on emp.manager_id = man.employee_id
where man.hire_date < emp.hire_date;

--문제6 ??
select country_name,
    co.country_id,
    city,
    lc.location_id,
    department_name,
    department_id
from countries co,
    locations lc,
    departments dept
where co.country_id = lc.country_id and
    lc.location_id = dept_location_id;
--문제 7
select emp.employee_id,
    first_name || ' ' || last_name as name,
    jh.job_id,
    start_date,
    end_date
from job_history jh,
    employees emp
where emp.employee_id = jh.employee_id and
    jh.job_id = 'AC_ACCOUNT';
    
--문제 8
select dept.department_id,
    department_name,
    first_name,
    city,
    country_name,
    region_name
from employees emp,
    departments dept,
    locations lc,
    countries co,
    regions rg
where dept.manager_id = emp.employee_id and
    dept.location_id = lc.location_id and
    lc.country_id = co.country_id and
    co.region_id = rg.region_id;
    
--문제 9 ??
select emp.employee_id,
    emp.first_name as empname,
    department_name,
    man.first_name as manname
from employees emp,
    employees man,
    departments dept
where emp.manager_id = man.employee_id
    and emp.employee_id = dept.manager_id;
    
----------------------------
--AGGREGATION
----------------------------
-- 여러 행을 입력으로 데이터를 집계하여 하나의 행으로 반환
-- count : 갯수 세기
--employees 테이블에 몇개의 레코드가 있나?(몇명의 직원이있나)
select count(*) from employees; --107명

-- *로 카운트 -> 모든 레코드의 수
-- 컬럼 명시 -> null값은 집계에서 제외함
select count(commission_pct) from employees;--35

-- 아래 쿼리와 동일
select count(*) from employees--35
where commission_pct is not null;

-- 합계: sum
-- 사원들 급여의 총합
select sum(salary) from employees;

-- 평균:AVG
select avg(salary) from employees;-- null제외

-- 집계함수는 null을 집계에서 제외
-- 사원들이 받는 commission비율의 평균치는?

select avg(commission_pct) from employees;--22%

--null을 0으로 치환하고 통계다시집계
select avg(nvl(commission_pct,0)) from employees; -- 7%
--집계함수 수행시 null 값을 처리할 방식을 정책으로 결정하고 수행

--사원들이 받는 급여의 최솟값,최댓값,평균,중앙값
select max(salary), min(salary), avg(salary), median(salary)
from employees;

-- 흔히 범하는 오류
-- 부서별 평균 급여 산정
select department_id, avg(salary)
from employees; -- department_id는 단일 레코드로 집계X ->오류

select department_id, salary
from employees
order by department_id;
-- 수정
-- 그룹별 집계를 위해서는 group by절을 이용
select department_id, round(avg(salary),2) "Average Salary"
from employees
group by department_id
order by department_id;

-- 집계함수를 사용한 쿼리문의 select 컬럼 목록에는
-- 그룹핑에 참여한 필드 or 집계 함수만 올수있다

-- Having 절
-- 평균 급여가 7000 이상인 부서만
--오류
select department_id, avg(salary)
from employees
where avg(salary) >= 7000 -- where절은 group by 집계가 일어나기 이전에 조건 체크
group by department_id;

-- 집계 함수 실행 이전에 where 절의 조건을 검사
-- 집계 함수 컬럼은 where 절에서 사용할수 없다.
-- 집계 이후에 조건 검사는 having절로 수행

-- 수정된 쿼리
select department_id, avg(salary)
from employees
group by department_id
having avg(salary) >= 7000
order by department_id;
    
 ----------------
 --분석 함수
 
 -- rollup
 -- group by 절과 함꼐 사용
 -- 그룹핑된 결과에 대한 좀더 상세한 요약을 제공
 -- 일종의 item total 기능 수행
 select department_id, job_id, sum(salary)
 from employees
 group by department_id, job_id
 order by department_id, job_id;
 
 -- rollup을 item total도 출력
 select department_id, job_id, sum(salary)
  from employees
 group by rollup (department_id, job_id)
 order by department_id;
 
 --cube
 -- cross tab에 의한 summary 함꼐 추출
 --rollup 함수의해 제공되는 item total과 함꼐
 -- column total 값을 함께 제공
 select department_id, job_id, sum(salary)
 from employees
 group by cube(department_id, job_id)
 order by department_id;
 
 ---------------------
 --SUBQUERY
 ----------------------
 -- 하나의 sql 내부에서 다른 sql를 포함하는 형태
 -- 임시로 테이블 구성, 임시결과를 바탕으로 최종 쿼리를 수행
 
 --사원들의 급여 중앙값보다 많은 급여를 받은 직원들
 -- 급여의 중간값?
 -- 중앙값보다 많이받는 직원 추출 쿼리
 
 -- 급여의 중간값?
 select median(salary)
 from employees; --6200
 
 -- 이 결과보다 많은 급여를 받는 직원 추출 쿼리
 select first_name, salary
 from employees
 where salary > 6200
 order by salary desc;
 
 -- 두 쿼리를 합쳐봅시다
 select first_name, salary
 from employees
 where salary > (select median(salary) from employees)
 order by salary desc;
 
 select first_name, hire_date from employees;
 
 --사원중에서 susan 보다 늦게 입사한 사원의 명단
 --쿼리 1. 이름이 susan인 사원의 입사일 추출
 select hire_date from employees
 where first_name = 'Susan';
 
 --쿼리 2. 입사일이 특정 일자보다 나중일 사원을 뽑는 쿼리
select first_name, hire_date
from employees
where hire_date > '02/06/07';

-- 두쿼리 합치기
select first_name, hire_date
from employees
where hire_date > 
(select hire_date from employees where first_name ='Susan');

-- 단일행 서브쿼리
-- 서브쿼리의 결과 단일행인 경우
-- 단일행 연산자 : =,>,>=,<,<=,<>

--급여를 가장 적게 받는 사원의 이름, 급여, 사원번호
select first_name, salary, employee_id
from employees
where salary = (select min(salary) from employees);

--평균 급여보다 적게 받는 사원의 이름, 급여
select first_name, salary, employee_id
from employees
where salary < (select avg(salary) from employees);

-- 다중행 서브쿼리
-- 서브쿼리 결과 레코드가 둘 이상인것 -> 단순 비교 연산자 수행 불가
-- 집합 연산에 관련된 in, any, all, exist 등을 이용

-- 서브 쿼리로 사용할 쿼리
select salary from employees where department_id = 110;

select first_name, salary
from employees
where salary in ( select salary from employees 
                    where department_id = 110);
-- in ( 12008, 8300) -> salary = 12008 or salary = 8300

select first_name, salary
from employees
where salary > all ( select salary from employees 
                    where department_id = 110);
-- all (12008, 8300) -> salary > 12008 and salary > 8300

select first_name, salary
from employees
where salary > any ( select salary from employees 
                    where department_id = 110);
--any (12008, 8300) -> salary > 12008 or salary > 8300

--correlated query
-- 바깥쪽 쿼리(주쿼리)와 안쪽 쿼리(서브쿼리)가 서로 연관된 쿼리
select first_name, salary, department_id
from employees outer
where salary > (select avg(salary) from employees
                    where department_id = outer.department_id);
--의미
-- 사원목록을 뽑아 오는데
-- 자기 자신으 속한 부서의 평균 급여보다 많이 받는 직원을 뽑아오자

--서브 쿼리 연습문제
-- 각 부서별로 최고 급여를 받는 사원의 목록 출력 (조건절 이용)
-- 쿼리 1번: 각부서의 최고급여 테이블을 뽑아보자
select department_id,max(salary) 
from employees
group by department_id; 

-- 쿼리 2번: 위 쿼리에서 나온 department_id와 max(salary) 값을 비교
select department_id, employee_id, first_name, salary
from employees
where(department_id, salary) in 
    (select department_id, max(salary)
        from employees
        group by department_id)
order by department_id;

--각 부서별로 최고 급여를 받는 사원의 목록 출력 ( 테이블 조인)
select emp.department_id,
    emp.employee_id,
    first_name,
    emp.salary
from employees emp, (select department_id, max(salary) salary
                    from employees
                    group by department_id) sal
where emp.department_id = sal.department_id and
    emp.salary = sal.salary
order by emp.department_id;

---------
--top-k query
-------
--rownum :쿼리 질의 수행결과에 의한 가상의 컬럼 -> 쿼리 결과의 순서 반환


--2007년 입사사중, 연봉 순위 5위까지 추출
select rownum, first_name, salary
from(select * from employees
    where hire_date like '07%'
    order by salary desc)
where rownum <= 5;

------------
--집합연산
-----------

select first_name, salary, hire_date
from employees
where hire_date < '05/01/01'; -- 2005년 1월 1일 이전 입사자 (24)

select first_name, salary, hire_date
from employees
where salary > 12000; --12000초과한 급여받는 사원 (8)

--입사일이 '05/01/01' 이전이고 급여가 12000이상 -> 교집합
select first_name, salary, hire_date
from employees
where hire_date < '05/01/01' -- 2005년 1월 1일 이전 입사자 (24)
intersect -- 교집합 연산
select first_name, salary, hire_date
from employees
where salary > 12000; --12000초과한 급여받는 사원 (8)

-- 입사일이 '05/01/01'이전 이거나 (or) 급여 >12000 합집합
select first_name, salary, hire_date
from employees
where hire_date < '05/01/01' -- 2005년 1월 1일 이전 입사자 (24)
union -- 합집합 연산 (쭝복제거)
select first_name, salary, hire_date
from employees
where salary > 12000; --12000초과한 급여받는 사원 (8)

select first_name, salary, hire_date
from employees
where hire_date < '05/01/01' -- 2005년 1월 1일 이전 입사자 (24)
union all-- 합집합 연산 (중복 제거하지않음)
select first_name, salary, hire_date
from employees
where salary > 12000 --12000초과한 급여받는 사원 (8)
order by first_name;

--입사일 '05/01/01'이전인 사원 중
-- 급여 > 12000 사원은 제거 -> 차집합
select first_name, salary, hire_date
from employees
where hire_date < '05/01/01' -- 2005년 1월 1일 이전 입사자 (24)
minus-- 차집합
select first_name, salary, hire_date
from employees
where salary > 12000 --12000초과한 급여받는 사원 (8)
order by salary desc;

-------------------
--rank 관련
------------------
select first_name, salary,
    rank() over (order by salary desc) as rank,
    dense_rank() over (order by salary desc) as "DENSE RANK",
    row_number() over (order by salary desc) as "ROW NUMBER"
from employees;

----------
--계층형 쿼리
---------
--oracle
--질의 결과를 tree 형태의 구조로 출력
--현재 employees 테이블을 이용, 조직도를 뽑아봅시다
select employee_id, first_name, manager_id
from employees;

select level, employee_id, first_name, manager_id
from employees
start with manager_id is null -- root 노드의 조건
connect by prior employee_id = manager_id
order by level;

--join을 이용해서 manager 이름까지 확인
select level, emp.employee_id, emp.first_name || ' ' || emp.last_name,
        emp.manager_id, man.employee_id, man.first_name || ' ' || man.last_name
from employees emp left outer join employees man
                    on emp.manager_id = man.employee_id
start with emp.manager_id is null
connect by prior emp.employee_id = emp.manager_id
order by level;


select count(first_name)
from employees
where first_name is not null;













