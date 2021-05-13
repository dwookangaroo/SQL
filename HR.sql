-- HR 계정
-- 계정 내의 테이블 확인
-- SQL은 대소문자 구분하지 않음
SELECT * FROM tab; 
-- 테이블의 구조 확인
DESC employees;

--------
--SELECT ~ FROM
--------

--가장 기본적인 SELECT : 전체 데이터 조회
SELECT * FROM employees;
SELECT * FROM departments;

-- 테이블 내에 정의된 컬럼의 순서대로 출력됨
-- 특정 컬럼만 선별적으로 projectionㄴ
--모든 사원의 first_name, 입사일, 급여 출력해보자
SELECT first_name, hire_date, salary
FROM employees;

--기본적 산술연산을 수행
-- 산술식 자체가 틀정 테이블에 소속된 것이 아닐때 "dual"
SELECT 10 + 20 FROM dual;
-- 특정 컬럼 값을 수치로 산술계산을 할수있다.
-- 직원들의 연봉 salary * 12
SELECT first_name,
    salary,
    salary * 12
from employees;

-- 
select first_name, job_id * 12 from employees; --error
desc employees; -- job_id는 문자열이기때문에 산술연산 불가

--연습
--employees 테이블, first_name, phone_number, 
-- hire_date, salary를 출력
select first_name,
    phone_number,
    hire_date,
    salary
from employees;

--사원의 first_name, last_name, salary, 
-- phone_number, hire_ date
-- 직접해보기
select first_name, last_name, salary,
    phone_number, hire_date
from employees;

-- 문자열의 연결 ||
-- first_name last_name을 연결 출력
select first_name || ' ' || last_name
from employees;

select first_name, salary, commission_pct
from employees;

-- 커미션 포함, 실질 급여를 출력해 봅시다
select 
    first_name,
    salary,
    commission_pct,
    salary + salary * commission_pct
from employees;
    
-- 산술 연산식에 null이 포함되어 있으면 결과 항상 null

-- nvl(expr1, expr2) : expr1이 null이면 expr2 선택
select
    first_name,
    salary,
    commission_pct,
    salary + salary * nvl(commission_pct, 0)
from employees;

-- Alias (별칭)
select
    first_name 이름,
    last_name as 성,
    first_name || ' ' || last_name "Full Name" 
    -- 별칭내에 공백, 특수문자가 포함될 경우 "로 묶는다
from employees;

-- 필드 표시명은 일반적으로 한글 등은 쓰지 말자

----------------
--where
----------------
-- 조건을 기준으로 레코드를 선택(selection)한다

-- 급여가 15000이상인 사원의 이름과 연봉
select first_name, salary * 12 "Annual Salary"
from employees
where salary >= 15000;

-- 07/01/01 이후 입사한 사원의 이름과 입사일
select first_name, hire_date
from employees
where hire_date >= '07/01/01';

-- 이름이 Lex인 사원의 연봉, 입사일, 부서 id
select first_name, salary * 12 "Annual Salary",
    hire_date, department_id
from employees
where first_name = 'Lex';

-- 부서 id가 10인 사원의 명단
select * from employees
where department_id = 10;

--alias 연습
select first_name || ' ' || last_name 이름,
    hire_date 입사일, phone_number 전화번호,
    salary 급여, salary * 12 연봉
    from employees;
    
-- 논리조합
-- 급여가 14000이하 or 17000이상인 사원의 이름과 급여
select first_name, salary
from employees
where salary >= 17000 or
      salary <= 14000;

-- 여집합
select first_name, salary
from employees
where not (salary <= 14000 or salary >= 17000);

-- 부서 아이디 90 and 급여 >=20000
select * from employees
where department_id = 90 and
    salary >= 20000;
    
-- between 연산자    
-- 입사일이 07/01/01 ~ 07/12/31 구간의 모든 사원
select first_name, hire_date
from employees
where hire_date between '07/01/01' and '07/12/31';

-- in 연산자
select * from employees
where department_id in (10,20,40);

-- manager_id 가 100 120 147 인 사원의 명단
-- 비교연산자 + 논리 연산자
select first_name, manager_id
from employees
where manager_id = 100 or
    manager_id = 120 or
    manager_id = 147;
    
-- in 연산자 활용
select first_name, manager_id
from employees
where manager_id in (100,120,147);

--like 검색
-- %: 임의의 길이의 지정되지 않은 문자열
-- _: 한개의 임의의 문자

-- 이름에 am을 포함한 사원의 이름과 급여
select first_name, salary
from employees
where first_name like '%am%';

-- 이름의 두번쨰 글자가 a 인 사람의 이름과 급여
select first_name, salary
from employees
where first_name like '_a%';

-- 이름의 네번쨰 글자가 a 인 사원의 이름 급여
select first_name, salary
from employees
where first_name like '___a%';

-- 이름이 4글자인 사원중 끝에서 두번쨰 글자가 a인사원
select first_name, salary
from employees
where first_name like '__a_';

-- order by : 정렬
--  asc (오름차순, 기본)
-- desc (내림차순, 큰것 -> 작은것)

-- 부서번호 오름차순 정렬 -> 부서번호, 급여, 이름 출력
select department_id, salary, first_name
from employees
order by department_id; -- asc는 생략 가능

--급여가 10000 이상 직원의 이름 급여(내림차순)
select first_name, salary
from employees
where salary >= 10000
order by salary desc;

-- 부서번호, 급여, 이름 select, 부서번호 오름차순, 급여 내림차순
select department_id, salary, first_name
from employees
order by department_id, salary desc;

--문제 1
select first_name || ' ' || last_name as 이름,
        salary as 월급, phone_number as 전화번호,
        hire_date as 입사일
from employees
order by hire_date;

--문제 2




--문제 3




--
--문제 4
select job_title, max_salary
from employees
where max_salary >= 10000
order by max_salary desc;

--문제 5


--문제 7
select first_name, salary
from employees
where first_name like '%s%';

--------------------
-- 단일행 함수 : 레코드를 입력으로 받음
--------------------



-- 문자열 단일행 함수
select first_name, last_name,
    concat(first_name, concat(' ', last_name)), -- 결합
    initcap(first_name || ' ' || last_name),-- 첫글자를 대문자로
    lower(first_name),--모두소문자
    upper(first_name),-- 모두대문자
    lpad(first_name, 20, '*'), -- 20자리 확보, 왼쪽을 *로 채운다
    rpad(first_name, 20, '*') -- 20자리 확보, 오른쪽을 *로 채움
from employees;

select '            oracle            ',
    '********database***********'
from dual;

select ltrim('            oracle            '),
    rtrim('            oracle            '),
    trim('*' from '********database***********'),
    substr('oracle database', 8, 4),
    substr('oracle database', -8, -4)
from dual;

-- 수치형 단일행 함수
select abs(-3.14), -- 절대값
    ceil(3.14), -- 소숫점 올림(천장)
    floor(3.14), -- 소숫점 버림(바닥)
    mod(7, 3), -- 나머지
    power(2, 4), -- 제곱
    round(3.5), -- 반올림
    round(3.4567, 2), --소숫점 2째짜리까지 반올림으로 변환
    trunc(3.5), 
    trunc(3.4567, 2) -- 소숫점 2쨰자리까지 버림으로 표시
from dual;

---------------------------
--date format
-------------------------

--날짜 형식 확인
select * from nls_session_parameters
where parameter= 'nls_date_format';

--현재 날짜와 시간
select sysdate
from dual; -- dual 가상 테이블로부터 확인

select sysdate
from employees; -- 테이블로부터 받아오므로 테이블 내 행 갯수만큼을 반환

-- date관련 함수
select sysdate, -- 현재 날짜와 시간
    add_months(sysdate, 2), -- 2개월 후의 날짜
    months_between('99/12/31', sysdate), -- 1999년 12월 31일 ~현재 의 달수
    next_day(sysdate, 7), -- 현재 날짜 이후의 첫번째 7요일
    round('21/05/17', 'month'), -- month정보로 반올림
    trunc('21/05/17', 'month')
from dual;

--현재 날짜 기준, 입사한지 몇개월 지났는가?
select first_name, hire_date, round(months_between(sysdate, hire_date))
from employees; 

--------------
--변환 함수
---------------

--to_number(s, frm) : 문자열 -> 수치형
--to_date(s, frm) : 문자열 -> 날짜형
--to_char(o, fmt) : 숫자, 날짜 -> 문자형

--to_char 
select first_name, hire_date, to_char(hire_date, 'yyyy-mm-dd hh24:mi:ss')
from employees;

-- 현재 날짜의 포맷
select sysdate, to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss')
from dual;

select to_char(123456789.0123, '999,999,999.99') --나머지 표기하지않음
from dual;

-- 연봉 정보 문자열로 포매팅
select first_name, to_char(salary*12, '$999,999.99') sal
from employees;

-- to_number: 문자열 -> 숫자
select to_number('1,999', '999,999'), to_number('$1,350.99', '$999,999.99')
from dual;

--to_date : 문자열 -> 날짜
select to_date('2021-05-05 14: 30', 'yyyy-mm-dd hh24:mi')
from dual;

--date 연산
--date +,- number : 날짜에 일수를 더한다,뺸다 -> date
--date - date : 날짜에서 날짜를 뺀일수
--date  +,- number(일수) / 24 : 날짜에 시간을 더할때 시간을 24시간으로 나눈값을 더한다,뺀다

select to_char(sysdate, 'yy-mm-dd hh24:mi'),
    sysdate + 1, --1일후
    sysdate - 1, --1일전
    sysdate - to_date('2012-09-24', 'yyyy-mm-dd'), -- 두날짜 차이 일수
    to_char(sysdate + 13 / 24, 'yy/mm/dd hh24:mi') -- 13시간후 
from dual;

----------------
-- null 관련 함수
---------------

-- nvl 함수 
select first_name,
    salary,
    commission_pct,
    salary + (salary * nvl (commission_pct, 0)) -- commission_pct가 null이면 0으로 바꾸자
from employees;

--nvl2 함수
-- nvl2(표현식, null이 아닐떄의 식, null일 떄의 식)
select first_name,
    salary,
    commission_pct,
    salary + nvl2(commission_pct, salary * commission_pct, 0)--commission_pct가 널이면 0, 아니면 두번쨰꺼
from employees;


--case 함수
--보너스를 지급하기로 했습니다.
-- ad관련 직원에게는 20% sa관련 직원에게는 10% it관련 직원에게는 8%
-- 나머지는 5%의 보너스를 지급한다

select first_name, job_id, salary, substr(job_id, 1, 2),
    case substr(job_id, 1, 2) when 'AD' then salary * 0.2
                                when 'SA' then salary * 0.1
                                when 'IT' then salary * 0.08
                                else salary *0.05
    end as bonus
from employees;

--decode
select first_name, job_id, salary, substr(job_id, 1, 2),
    decode(substr(job_id, 1, 2),
            'AD', salary * 0.2,
            'SA', salary * 0.1,
            'IT', salary * 0.08,
            salary * 0.05) as bonus
from employees;

--연습문제
--department_id - 30이하이면 a그룹
-- 50이하이면 b그룹
-- 100이하이면 c그룹
-- 나머지는 remainder
select first_name, department_id,
    case when department_id <=30 then 'A-GROUP'
        when department_id <=50 then 'B-GROUP'
        when department_id <=100 then 'C-GROUP'
        else 'REAMINDER'
    end as team
from employees
order by team;



