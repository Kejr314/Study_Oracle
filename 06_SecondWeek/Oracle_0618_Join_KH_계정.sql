-- JOIN
-- 따로 분류하여 새로운 가상의 테이블을 만듦
-- 여러 테이블의 레코드를 조합하여 하나의 레코드로 만듦
-- 컬럼명이 동일할 때 어떤 테이블의 컬럼인지 "테이블명.컬럼명"으로 입력해주어야 함

SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_ID, DEPT_TITLE 
FROM EMPLOYEE
JOIN DEPARTMENT
ON DEPT_CODE = DEPT_ID;

-- ANSI 표준 구문
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB.JOB_CODE, JOB_NAME 
FROM EMPLOYEE
JOIN JOB
ON EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

-- 테이블 별칭 부여
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, J.JOB_CODE, JOB_NAME 
FROM EMPLOYEE E
JOIN JOB J
ON E.JOB_CODE = J.JOB_CODE;

-- 조인하는 컬럼 같을 때 USING 구문
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME 
FROM EMPLOYEE E
JOIN JOB J
USING(JOB_CODE);

-- Oracle 전용 구문
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB.JOB_CODE, JOB_NAME 
FROM EMPLOYEE
,JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;



-- 실습문제1)
-- 부서명과 지역명을 출력하세요.
SELECT DEPT_TITLE "부서명", LOCAL_NAME "지역명"
FROM DEPARTMENT
JOIN LOCATION
ON LOCATION_ID = LOCAL_CODE;

-- 실습문제2)
-- 사원명과 직급명을 출력하세요.
SELECT EMP_NAME "사원명", JOB_NAME "직급명"
FROM EMPLOYEE E
JOIN JOB J
ON E.JOB_CODE = J.JOB_CODE;

-- 실습문제3)
-- 지역명과 국가명을 출력하세요
SELECT LOCAL_NAME "지역명", NATIONAL_NAME "국가명"
FROM LOCATION
JOIN NATIONAL
USING(NATIONAL_CODE);


-- [종합실습문제]

-- 문제1)
-- 주민번호가 1970년대 생이면서 성별이 여자이고, 성이 전씨인 직원들의 사원명, 주민번호, 부서명, 직급명을 조회하시오.
SELECT EMP_NAME "사원명", EMP_NO "주민번호", DEPT_TITLE "부서명", JOB_NAME "직급명"
FROM EMPLOYEE E
JOIN DEPARTMENT D ON DEPT_CODE = DEPT_ID
JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
WHERE 
SUBSTR(EMP_NO, 1, 2) BETWEEN '70' AND '79'
AND SUBSTR(EMP_NAME, 1, 1) = '전'
AND SUBSTR(EMP_NO, 8, 1) IN ('2', '4');

SELECT EMP_NAME "사원명", EMP_NO "주민번호", DEPT_TITLE "부서명", JOB_NAME "직급명"
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN JOB USING(JOB_CODE)
WHERE EMP_NO LIKE '7%-2%' AND EMP_NAME LIKE '전%';

-- 문제2)
-- 이름에 '형'자가 들어가는 직원들의 사번, 사원명, 부서명을 조회하시오.
SELECT EMP_ID "사번", EMP_NAME "사원명", DEPT_TITLE "부서명"
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE EMP_NAME LIKE '%형%';
 
-- 문제3)
-- 해외영업부에 근무하는 사원명, 직급명, 부서코드, 부서명을 조회하시오.
SELECT EMP_NAME "사원명", JOB_NAME "직급명", DEPT_CODE "부서코드", DEPT_TITLE "부서명"
FROM EMPLOYEE
JOIN JOB J USING(JOB_CODE)
JOIN DEPARTMENT D ON DEPT_CODE = DEPT_ID
WHERE D.DEPT_ID = 'D5';

-- 문제4)
-- 보너스포인트를 받는 직원들의 사원명, 보너스포인트, 부서명, 근무지역명을 조회하시오.
SELECT EMP_NAME "사원명", SALARY*NVL(BONUS, '0') "보너스포인트", DEPT_TITLE "부서명", LOCAL_NAME "근무지역명"
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
JOIN LOCATION L ON D.LOCATION_ID = L.LOCAL_CODE
WHERE BONUS IS NOT NULL;

-- 문제5)
-- 부서코드가 D2인 직원들의 사원명, 직급명, 부서명, 근무지역명을 조회하시오
SELECT EMP_NAME "사원명", JOB_NAME "직급명", DEPT_TITLE "부서명", LOCAL_NAME "근무지역명"
FROM EMPLOYEE E
JOIN JOB J USING(JOB_CODE)
JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
JOIN LOCATION L ON D.LOCATION_ID = L.LOCAL_CODE
WHERE E.DEPT_CODE = 'D2';

-- 문제6)
-- 급여등급테이블의 최대급여(MAX_SAL)보다 많이 받는 직원들의 사원명, 직급명, 급여, 연봉을 조회하시오.
-- 단, 사원테이블과 급여등급테이블을 SAL_LEVEL컬럼기준으로 조인할 것, 데이터 없음
SELECT EMP_NAME "사원명", JOB_NAME "직급명", SALARY "급여", SALARY*12 "연봉"
FROM EMPLOYEE E
JOIN SAL_GRADE S ON E.SAL_LEVEL = S.SAL_LEVEL
JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
WHERE E.SALARY > S.MAX_SAL;

-- 문제7)
-- 한국(KO)과 일본(JP)에 근무하는 직원들의 사원명, 부서명, 지역명, 국가명을 조회하시오.
SELECT EMP_NAME "사원명", DEPT_TITLE "부서명", LOCAL_NAME "지역명", NATIONAL_NAME "국가명"
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
JOIN LOCATION L ON D.LOCATION_ID = L.LOCAL_CODE
JOIN NATIONAL N ON L.NATIONAL_CODE = N.NATIONAL_CODE
WHERE L.NATIONAL_CODE IN ('KO', 'JP');
 
-- 문제8)
-- 보너스포인트가 없는 직원들 중에서 직급이 차장과 사원인 직원들의 사원명, 직급명, 급여를 조회하시오. (단, JOIN과 IN 사용할 것)
SELECT EMP_NAME "사원명", JOB_NAME "직급명", SALARY "급여"
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_CODE IN ('J4', 'J7') AND BONUS IS NULL;

-- 문제9)
-- 재직중인 직원과 퇴사한 직원의 수를 조회하시오. (JOIN 미사용)
SELECT DECODE(ENT_YN, 'N', '재직', '퇴직') "상태", COUNT(*) "인원수"
FROM EMPLOYEE
GROUP BY ENT_YN;

-- 문제10)
-- 직원명, 직급코드, 연봉(원) 조회 (단, 연봉은 ￦57,000,000 으로 표시되게 함)
-- 연봉은 보너스포인트가 적용된 1년치 급여임
SELECT EMP_NAME "직원명", JOB_CODE "직급코드", TO_CHAR(SALARY*12 + SALARY*NVL(BONUS, 0), 'L999,999,999') "연봉(원)"
FROM EMPLOYEE;

-- 문제11)
-- 사원명과, 부서명을 출력하세요.
-- 부서코드가 D5이면 총무부, D6이면 기획부, D9이면 영업부로 처리하시오.(case 사용)
-- 단, 부서코드가 D5, D6, D9 인 직원의 정보만 조회하고, 부서코드 기준으로 오름차순 정렬함.
-- CASE 사용
SELECT EMP_NAME "사원명",
    CASE
        WHEN DEPT_CODE = 'D5' THEN '총무부'
        WHEN DEPT_CODE = 'D6' THEN '기획부'
        WHEN DEPT_CODE = 'D9' THEN '영업부'
    END "부서명"
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D6', 'D9')
ORDER BY DEPT_CODE ASC;
-- JOIN 사용
SELECT EMP_NAME "사원명", DEPT_TITLE "부서명"
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE DEPT_CODE IN ('D5', 'D6', 'D9');















