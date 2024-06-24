-- 06/19
-- < JOIN의 종류 >
-- * INNER JOIN : 교집합, 일반적으로 사용
-- * OUTER JOIN : 합칩합, 모두 출력
-- 예제)
-- 사원명과 부서명을 출력하시오
SELECT ELCT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMEN ON DEPT_CODE = DEPT_ID; -- 총 21개 출력됨, 2개 부족 
-- DEPT_CODE = NULL인 데이터 출력X >> INNER JOIN

--------------------------------------------------------------------------------
SELECT COUNT(*) FROM EMPLOYEE; -- 23

-- LEFT OUTER JOIN은 왼쪽 테이블이 가지고 있는 모든 데이터를 출력
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
LEFT OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID; -- 총 23개 출력됨

-- RIGHT OUTHER JOIN은 오른쪽 테이블이 가지고 있는 모든 데이터를 출력
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
RIGHT OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID; -- 총 23개 출력됨

-- FULL OUTER JOIN은 양쪽 테이블이 가지고 있는 모든 데이터를 출력
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
FULL OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID; -- 총 23개 출력됨
--------------------------------------------------------------------------------
-- Oracle 전용 구문, JOIN 사용
-- INNER JOIN
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT WHERE DEPT_CODE = DEPT_ID;

-- LEFT OUTER JOIN
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT WHERE DEPT_CODE = DEPT_ID(+);

-- RIGHT OUTER JOIN
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT WHERE DEPT_CODE(+) = DEPT_ID;

-- FUL OUTER JOIN은 존재하지 않음
--------------------------------------------------------------------------------
-- 실습문제3)
-- 해외영업부에 근무하는 사원명, 직급명, 부서코드, 부서명을 조회하시오.
SELECT EMP_NAME "사원명", JOB_NAME "직급명", DEPT_CODE "부서코드", DEPT_TITLE "부서명"
FROM EMPLOYEE
JOIN JOB J USING(JOB_CODE)
JOIN DEPARTMENT D ON DEPT_CODE = DEPT_ID
WHERE D.DEPT_TITLE = '해외영업부';

-- 실습문제4)
-- 보너스포인트를 받는 직원들의 사원명, 보너스포인트, 부서명, 근무지역명을 조회하시오
SELECT EMP_NAME "사원명", SALARY*NVL(BONUS, '0') "보너스포인트", DEPT_TITLE "부서명", LOCAL_NAME "근무지역명"
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
JOIN LOCATION L ON D.LOCATION_ID = L.LOCAL_CODE
WHERE BUNUS IS NOT NULL;

-- 실습문제5) 
-- 부서코드가 D2인 직원들의 사원명, 직급명, 부서명, 근무지역명을 조회하시오SELECT EMP_NAME "사원명", JOB_NAME "직급명", DEPT_TITLE "부서명", LOCAL_NAME "근무지역명"
-- 테이블의 순서를 신경써야 함
SELECT EMP_NAME "사원명", JOB_NAME "직급명", DEPT_TITLE "부서명", LOCAL_NAME "근무지역명"
FROM EMPLOYEE E
JOIN JOB J USING(JOB_CODE)
JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
JOIN LOCATION L ON D.LOCATION_ID = L.LOCAL_CODE
WHERE E.DEPT_CODE = 'D2';
 
-- 실습문제6)
-- 급여등급테이블의 최대급여(MAX_SAL)보다 많이 받는 직원들의 사원명, 직급명, 급여, 연봉을 조회하시오.
-- (사원테이블과 급여등급테이블을 SAL_LEVEL컬럼기준으로 조인할 것)
-- 데이터 없음!
SELECT EMP_NAME "사원명", JOB_NAME "직급명", SALARY "급여", SALARY*12 "연봉", MAX_SAL
FROM EMPLOYEE 
JOIN JOB USING (JOB_CODE)
JOIN SAL_GRADE USING(SAL_LEVEL)
WHERE SALARY > MAX_SAL;

-- 실습문제7) 
-- 한국(KO)과 일본(JP)에 근무하는 직원들의 사원명, 부서명, 지역명, 국가명을 조회하시오.
SELECT EMP_NAME "사원명", DEPT_TITLE "부서명", LOCAL_NAME "지역명", NATIONAL_NAME "국가명"
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
JOIN NATIONAL USING(NATIONAL_CODE)
WHERE NATIONAL_CODE IN ('KO', 'JP');

-- 실습문제8)
-- 보너스포인트가 없는 직원들 중에서 직급이 차장과 사원인 직원들의 사원명, 직급명, 급여를 조회하시오. (단, JOIN과 IN 사용할 것)
SELECT EMP_NAME "사원명", JOB_NAME "직급명", SALARY "급여"
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_CODE IN ('J4', 'J7') AND BONUS IS NULL;

-- 실습문제12)
-- 재직중인 직원과 퇴사한 직원의 수를 조회하시오.(JOIN 미사용)
SELECT DECODE(ENT_YN, 'N', '재직', '퇴직') "상태", COUNT(*) "인원수"
FROM EMPLOYEE
GROUP BY ENT_YN;















