-- 06/19
-- 서브쿼리(SubQuery)
-- 하나의 SQL문 안에 포함되어 있는 또 다른 SQL문
-- 메인 쿼리가 서브 쿼리를 포함하는 종속적인 관계
-- 서브쿼리는 반드시 소괄호로 묶어야 함
-- 서브쿼리 안에 ORDER BY 사용할 수 없음
-- EX) 전 직원의 평균 급여보다 많은 급여를 받고 있는 직원의 사번, 이름, 직급코드, 급여를 조회하세요.
SELECT AVG(SALARY) FROM EMPLOYEE;

-- 서브쿼리를 사용하지않은 경우
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3047663;

-- 서브쿼리를 사용한 경우
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE);

-- 예제1)
-- 전지연 직원의 관리자 이름을 출력하세요.
SELECT * FROM EMPLOYEE
WHERE EMP_NAME = '전지연';

SELECT EMP_NAME FROM EMPLOYEE
WHERE EMP_ID = 214;

SELECT EMP_NAME FROM EMPLOYEE
WHERE EMP_ID = (SELECT MANAGER_ID FROM EMPLOYEE WHERE EMP_NAME = '전지연');

-- < 서브쿼리의 종류 >
-- * 단일행 서브쿼리
-- * 다중행 서브쿼리
-- EX) 송종기나 박나라가 속한 부서에 속한 직원들의 전체 정보를 출력하세요.
SELECT * FROM EMPLOYEE
WHERE DEPT_CODE IN (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME IN ('송종기', '박나라'));
-- * 다중열 서브쿼리
-- * 다중행 서브쿼리
-- * 다중행 다중열 서브쿼리
-- * 상(호연)관 서브쿼리
-- * 스칼라 서브쿼리

-- 실습문제1)
-- 차태연, 전지연 사원의 급여등급과 같은 사원의 직급명, 사원명을 출력하세요.
SELECT JOB_NAME "직급명", EMP_NAME "사원명"
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE SAL_LEVEL IN (SELECT SAL_LEVEL FROM EMPLOYEE WHERE EMP_NAME IN ('차태연', '전지연'));

-- 실습문제2)
-- Asia1지역에 근무하는 직원의 정보(부서코드, 사원명)를 출력하세요.
SELECT DEPT_CODE, EMP_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
WHERE LOCAL_NAME = UPPER('Asia1');

-- 서브쿼리 사용
SELECT DEPT_CODE, EMP_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
WHERE LOCAL_NAME = UPPER('Asia1');

-- 서브쿼리 안에 서브쿼리 쓰는 경우
SELECT DEPT_CODE, EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE IN (SELECT DEPI_ID FROM DEPARTMENT 
    WHERE LOCATION_ID = (SELECT LOCAL_CODE FROM LOCATION WHERE LOCAL_NAME = UPPER('Asia1')));








-- 상(호연)관 서브쿼리
--     - 메인 쿼리의 값이 서브쿼리에 사용되는 것
--     - 메인 쿼리의 값을 서브 쿼리에 주고 서브쿼리를 수행한 다음 그 결과를 다시 메인 쿼리로 반환해서 수행하는 것
--     - 상호연관 관계를 가지고 실행하는 쿼리이다. 
-- SELECT 실행순서
-- FROM  -  WHERE    -    SELECT
--          GROUP BY -    HAVING
--                              ORDER BY
--------------------------------------------------------------------------------
SELECT * FROM EMPLOYEE WHERE EMP_ID='200';
SELECT * FROM EMPLOYEE WHERE EMP_ID='2000'; -- 거짓
-- WHERE 조건절의 값이 참이면 출력(EMP_ID = '200')
-- WHERE 조건절이 거짓이면 출력하지 않음.(EMP_ID = '2000')

SELECT * FROM EMPLOYEE WHERE 1 = 0;  -- 모든 행이 거짓이라 안나옴...
SELECT * FROM EMPLOYEE WHERE EXISTS (SELECT 1 FROM EMPLOYEE);
SELECT * FROM EMPLOYEE E WHERE EXISTS (SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = E.EMP_ID);
--------------------------------------------------------------------------------
-- 실습예제1
-- 부하직원이 한명이라도 있는 직원의 정보를 출력하시오.
-- (매니저 아이디에 자신의 사번이 하나라도 있는 사람..)
--------------------------------------------------------------------------------
-- EMP_ID가 200인 경우 부하직원이 있나?
SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = '200'; -- O
SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = '201'; -- O
SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = '202'; -- X
SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = '203'; -- X
SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = '204'; -- O
SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = '205'; -- X
SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = '206'; -- X
SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = '207'; -- O
SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = '208'; -- X
SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = '209'; -- X
SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = '210'; -- X
SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = '211'; -- O
SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = '212'; -- X
SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = '214'; -- O

SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = '100'; -- O

SELECT * FROM EMPLOYEE WHERE EMP_ID IN('200', '201', '204', '207', '211', '214', '100');

SELECT * FROM EMPLOYEE E WHERE EXISTS (SELECT 11 FROM EMPLOYEE J WHERE MANAGER_ID = E.EMP_ID);
SELECT * FROM EMPLOYEE E WHERE EXISTS (SELECT 1 FROM EMPLOYEE J WHERE MANAGER_ID = E.EMP_ID);
SELECT * FROM EMPLOYEE E WHERE EXISTS (SELECT MANAGER_ID FROM EMPLOYEE J WHERE MANAGER_ID = E.EMP_ID);

SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = EMP_ID;

--------------------------------------------------------------------------------
-- @실습문제1
-- 가장 많은 급여를 받는 직원을 출력하세요. 
--------------------------------------------------------------------------------
-- 셀프 검색해서 값 대입해서 찾은 것
SELECT MAX(SALARY) FROM EMPLOYEE; -- 8000000
SELECT * FROM EMPLOYEE WHERE SALARY = 8000000;
-- 단일행 서브쿼리
SELECT*FROM EMPLOYEE WHERE SALARY = (SELECT MAX(SALARY) FROM EMPLOYEE); 
-- 상관쿼리로는 어떻게???
SELECT 1 FROM EMPLOYEE WHERE SALARY > 8000000; -- 0
SELECT 1 FROM EMPLOYEE WHERE SALARY > 6000000; -- 1
SELECT 1 FROM EMPLOYEE WHERE SALARY > 3700000; -- 4
SELECT 1 FROM EMPLOYEE WHERE SALARY > 2800000; -- 9
--------------- ..........------------------

SELECT * FROM EMPLOYEE E WHERE EXISTS(SELECT 1 FROM EMPLOYEE WHERE SALARY > E.SALARY); -- 선동일빼고 모두 출력
SELECT * FROM EMPLOYEE E WHERE NOT EXISTS(SELECT 1 FROM EMPLOYEE WHERE SALARY > E.SALARY); -- 선동일(최대값)만 출력
--------------------------------------------------------------------------------
-- @실습문제2
-- 가장 적은 급여를 받는 직원을 출력하시오.
--------------------------------------------------------------------------------
SELECT * FROM EMPLOYEE WHERE SALARY = (SELECT MIN(SALARY) FROM EMPLOYEE);
SELECT * FROM EMPLOYEE E WHERE NOT EXISTS(SELECT 1 FROM EMPLOYEE WHERE SALARY < E.SALARY); 
--------------------------------------------------------------------------------
-- @실습문제3
-- 심봉선과 같은 부서의 사원의 부서코드, 사원명, 월평균급여를 조회하시오.
--------------------------------------------------------------------------------
-- 0. 메인 쿼리
SELECT DEPT_CODE, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

-- 1. 심봉선의 부서 조회
SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME = '심봉선';  --D5


-- 2. 심봉선 소속 부서의 평균 급여 조회
SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING DEPT_CODE = 'D5'; -- D5부서의 평균 급여

-- 3. 메인 쿼리의 'SALARY 부분을 월평균 급여를 구하는 쿼리로 변경
SELECT DEPT_CODE, EMP_NAME, (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING DEPT_CODE = 'D5') "월평균 급여"
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

-- 4. 심봉선과 같은 등급을 출력하는 부분을 모두 서브 쿼리로 변경
SELECT DEPT_CODE, EMP_NAME, (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING DEPT_CODE = (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME = '심봉선')) "월평균 급여"
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME = '심봉선');

SELECT AVG(SALARY) FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING DEPT_CODE = 'D5';

--------------------------------------------------------------------------------
-- 1. 심봉선과 같은 부서코드를 가진 행만 출력
-- - 검증쿼리
SELECT 1 FROM EMPLOYEE WHERE DEPT_CODE = 'D1' AND EMP_NAME = '심봉선';
SELECT 1 FROM EMPLOYEE WHERE DEPT_CODE = 'D2' AND EMP_NAME = '심봉선';
SELECT 1 FROM EMPLOYEE WHERE DEPT_CODE = 'D3' AND EMP_NAME = '심봉선';
SELECT 1 FROM EMPLOYEE WHERE DEPT_CODE = 'D4' AND EMP_NAME = '심봉선';
SELECT 1 FROM EMPLOYEE WHERE DEPT_CODE = 'D5' AND EMP_NAME = '심봉선';  -- O
SELECT 1 FROM EMPLOYEE WHERE DEPT_CODE = 'D6' AND EMP_NAME = '심봉선';
SELECT 1 FROM EMPLOYEE WHERE DEPT_CODE = 'D7' AND EMP_NAME = '심봉선';
SELECT 1 FROM EMPLOYEE WHERE DEPT_CODE = 'D8' AND EMP_NAME = '심봉선';
-- - 메인 쿼리
SELECT 
DEPT_CODE "부서코드",
EMP_NAME "사원명",
SALARY "월평균 급여"
FROM EMPLOYEE E WHERE EXISTS(SELECT 1 FROM EMPLOYEE 
WHERE DEPT_CODE = E.DEPT_CODE AND EMP_NAME = '심봉선');

-- 2. 월평균급여 출력
-- 
SELECT 
DEPT_CODE "부서코드",
EMP_NAME "사원명",
(SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE 
WHERE DEPT_CODE = (select dept_code from employee where emp_name = '심봉선')) "월평균 급여"
FROM EMPLOYEE E 
WHERE EXISTS(SELECT 1 FROM EMPLOYEE J
WHERE DEPT_CODE = E.DEPT_CODE AND EMP_NAME = '심봉선');



--------------------------------------------------------------------------------
-- @실습문제4
-- 직급이 J1, J2, J3이 아닌 사원중에서 자신의 부서별 평균급여보다 많은 급여를 받는
-- 직원의 부서코드, 사원명, 급여, (부서별 급여평균) 정보를 출력하시오.
--------------------------------------------------------------------------------


SELECT 
DEPT_CODE "부서코드",
EMP_NAME "사원명",
SALARY "월평균 급여"
FROM EMPLOYEE E
WHERE EXISTS(SELECT DEPT_CODE FROM EMPLOYEE S WHERE EMP_NAME = '심봉선');


















