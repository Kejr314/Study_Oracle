-- 06/18
-- 오라클 함수
-- 1. 단일행 함수 : 결과값 여러개
-- 2. 다중행 함수 : 결과값 1개(그룹 함수)

SELECT FLOOR(SYSDATE-HIRE_DATE) FROM EMPLOYEE;

-- < 단일행 함수의 종류 >
-- * 숫자 처리 함수 : ABS, MOD, TRUNC, FLOOR, ROUND, CEIL
-- * 문자 처리 함수
--   - LENGTH, LENGTHB : 길이
--   - INSTR, INSTRB : 위치
--   - RPAD(값, 문자 길이, 채울문자) : 지정한 길이만큼 오른쪽부터 특정 문자로 채우기
--   - LPAD(값, 문자 길이, 채울문자) : 지정한 길이만큼 왼쪽부터 특정 문자로 채우기
--   - LTRIM : 왼쪽(좌측) 공백 제거, 문자 왼쪽 반복적인 문자를 제거
--   - RTRIM : 오른쪽(우측) 공백 제거, 문자 왼쪽 반복적인 문자를 제거
--   - TRIM : 문자열의 양쪽 공백을 제거 
--   - SUBSTR(문자열, 시작 위치, 길이) : 문자열 자르기 
--   - CONCAT(값1, 값2, ...) : 문자열 합치기, 값1값2...
--   - REPLACE : 문자열 교체
-- * 날짜 처리 함수 : ADD_MONTHS, MONTHS_BETWEEN, LAST_DAY, EXTRACT, SYSDATE

-- 실습 문제 - 날짜 처리 함수
-- 문제1)
-- 오늘부로 일용자씨가 군대에 끌려갑니다.
-- 군복무 기간이 1년 6개월을 한다라고 가정하면
-- 첫번째, 제대일자는 언제인지 구하고
-- 두번째, 제대일짜까지 먹어야 할 짬밤의 그릇수를 구하시오. (단, 1일 3끼를 먹는다고 한다.)
SELECT SYSDATE "입대날짜", ADD_MONTHS(SYSDATE, 18) "제대일자",  (ADD_MONTHS(SYSDATE, 18)-SYSDATE)*3 "그릇수" FROM DUAL;

-- 실습 문제
-- 문제1)
-- 직원명과 이메일 , 이메일 길이를 출력하시오
--       이름	    이메일		이메일길이
-- ex)  홍길동 , hong@kh.or.kr   	  13
SELECT EMP_NAME "이름", EMAIL "이메일", LENGTH(EMAIL) "이메일길이" FROM EMPLOYEE;

-- 문제2)
-- 직원의 이름과 이메일 주소중 아이디 부분만 출력하시오
-- ex) 노옹철	no_hc
-- ex) 정중하	jung_jh
SELECT EMP_NAME "이름", SUBSTR(EMAIL, 1, INSTR(EMAIL, '@')-1) "아이디" FROM EMPLOYEE;

-- 문제3)
-- 60년대에 태어난 직원명과 년생, 보너스 값을 출력하시오. 그때 보너스 값이 null인 경우에는 0 이라고 출력 되게 만드시오
--	    직원명    년생      보너스
--	ex) 선동일	    1962	    0.3
--	ex) 송은희	    1963  	    0
SELECT EMP_NAME "직원명", CONCAT('19', SUBSTR(EMP_NO, 1, 2)) "년생", NVL(BONUS, 0) "보너스" 
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 1, 2) BETWEEN 60 AND 69; 

-- 문제4)
-- '010' 핸드폰 번호를 쓰지 않는 사람의 전체 정보를 출력하시오.
SELECT * FROM EMPLOYEE WHERE PHONE NOT LIKE '010%';

-- 문제5)
-- 직원명과 입사년월을 출력하시오(단, 아래와 같이 출력되도록 만들어 보시오)
--	    직원명		입사년월
--	ex) 전형돈		2012년 12월
--	ex) 전지연		1997년 3월
SELECT EMP_NAME "직원명", 
EXTRACT(YEAR FROM HIRE_DATE)||'년 '||EXTRACT(MONTH FROM HIRE_DATE)||'월' "입사년월" 
FROM EMPLOYEE;

-- 문제6)
-- 직원명과 주민번호를 조회하시오 (단, 주민번호 9번째 자리부터 끝까지는 '*' 문자로 채워서 출력하시오)
-- ex) 홍길동 771120-1******
SELECT EMP_NAME "직원명", RPAD(SUBSTR(EMP_NO,1,8), 14, '*') "주민번호" FROM EMPLOYEE;

-- 문제7)
-- 부서코드가 D5, D9인 직원들 중에서 2004년도에 입사한 직원중에 조회함.
-- 사번 사원명 부서코드 입사일
SELECT EMP_ID "사번", EMP_NAME "사원명", DEPT_CODE "부서코드", HIRE_DATE "입사일" 
FROM EMPLOYEE 
WHERE DEPT_CODE IN ('D5', 'D9') AND EXTRACT(YEAR FROM HIRE_DATE) = '2004';

-- 문제8)
-- 직원명, 입사일, 오늘까지의 근무일수 조회 (주말도 포함 , 소수점 아래는 버림)
SELECT EMP_NAME "직원명", HIRE_DATE "입사일", FLOOR(SYSDATE-HIRE_DATE) "근무일수" FROM EMPLOYEE;

-- 문제9)
-- 직원명, 부서코드, 생년월일, 나이(만) 조회
-- 단, 생년월일은 주민번호에서 추출해서, ㅇㅇㅇㅇ년 ㅇㅇ월 ㅇㅇ일로 출력되게 함.
-- 나이는 주민번호에서 추출해서 날짜데이터로 변환한 다음 계산
SELECT EMP_NAME "직원명", DEPT_CODE "부서코드", 
'19'||SUBSTR(EMP_NO, 1, 2)||'년 '||SUBSTR(EMP_NO, 3, 2)||'월 '||SUBSTR(EMP_NO, 5, 2)||'일' "생년월일",
EXTRACT(YEAR FROM SYSDATE)-CONCAT('19',SUBSTR(EMP_NO, 1, 2)) "나이(만)"
FROM EMPLOYEE;

-- 문제10)
-- 직원명, 직급코드, 연봉(원) 조회
-- 단, 연봉은 57,000,000으로 표시되게 함 
-- 연봉은 보너스 포인트가 적용된 1년치 급여
SELECT EMP_NAME "직원명", JOB_CODE "직급코드", CHR(92)||(SALARY*12 + SALARY*NVL(BONUS, 0)) "연봉(원)" FROM EMPLOYEE;

-- 문제11)
-- 사원명, 부서명 출력
-- 부서코드가 D5면 총무부, D6이면 기획부, D9이면 영업부로 처리 (CASE) 사용
-- 단, 부서코드가 D5, D6, D9인 직원의 정보만 조회하고 부서코드 기준으로 오름차순으로 정렬
SELECT EMP_NAME "사원명",
CASE 
    WHEN DEPT_CODE = 'D5' THEN '총무부'
    WHEN DEPT_CODE = 'D6' THEN '기획부'
    WHEN DEPT_CODE = 'D9' THEN '영업부'
    END "부서명"
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D6', 'D9')
ORDER BY DEPT_CODE ASC;


-- < 형변환 함수 >
-- * TO_CHAR()
-- * TO_DATE() 
-- * TO_NUMBER()

-- 예제
-- EMPLOYEE테이블에서 입사일이 00/01/01 ~ 10/01/01 사이인 직원의 정보를 출력하시오.
SELECT * FROM EMPLOYEE WHERE HIRE_DATE BETWEEN TO_DATE('00/01/01') AND TO_DATE('10/01/01');

SELECT 500 + 300 FROM DUAL;
SELECT TO_NUMBER('500') + 300 FROM DUAL;

SELECT '1,000,000' - '5OO,OO' FROM DUAL; -- 자동 형 변환이 안 되는 경우
SELECT TO_NUMBER('1,000,000', '9,999,999') - TO_NUMBER('500,000', '999,999') "계산결과" FROM DUAL; -- 자동 형 변환됨

SELECT
HIRE_DATE "HIRE_DATE 입사날짜",
EXTRACT(YEAR FROM HIRE_DATE)||'년 '||EXTRACT(MONTH FROM HIRE_DATE)||'월 '||EXTRACT(DAY FROM HIRE_DATE)||'일' "EXTRACT 사용 입사날짜",
TO_CHAR(HIRE_DATE, 'YYYY"년 "MM"월 "DD"일"') "TO_CHAR 사용 입사날짜" FROM EMPLOYEE;

/* =================== TO_CHAR 형식 문자(숫자) ========================
Format		 예시			설명
,(comma)    9,999		콤마 형식으로 변환
.(period)	99.99		소수점 형식으로 변환
9           99999       해당자리의 숫자를 의미함. 값이 없을 경우 소수점이상은 공백, 소수점이하는 0으로 표시.
0		    09999		해당자리의 숫자를 의미함. 값이 없을 경우 0으로 표시. 숫자의 길이를 고정적으로 표시할 경우.
$		    $9999		$ 통화로 표시
L		    L9999		Local 통화로 표시(한국의 경우 \)
XXXX		XXXX		16진수로 표시
FM         FM1234.56    포맷9로부터 치환된 공백(앞) 및 소수점이하0을 제거
*/

/*  =================== TO_DATE 형식 문자(날짜) =======================
YYYY	    년도표현(4자리)
YY	        년도 표현 (2자리)
RR          년도 표현 (2자리), 50이상 1900, 50미만 2000
MONTH       월을 LOCALE설정에 맞게 출력(FULL)
MM	        월을숫자로표현  
MON	        월을 알파벳으로 표현(월요일아님)
DDD         365일 형태로 표현
DD	        31일 형태로 표현	
D           요일을 숫자로 표현(1:일요일...) 
DAY	        요일 표현	  
DY	        요일을 약어로 표현	
HH HH12     시각
HH          시각(24시간)
MI
SS
AM PM A.M. P.M. 오전오후표기
FM          월, 일, 시,분, 초앞의 0을 제거함.
*/

-- < 기타 함수 >
-- * NVL 함수 : 값이 NULL인 경우 지정값을 출력하고, NULL이 아니면 원래 값을 그대로 출력. NVL("값", "지정값") 
SELECT NVL(BONUS, '0')*SALARY FROM EMPLOYEE; -- 0 -> 자동 형 변환됨, BUNUS는 NUMBER 형식이기 때문에 '없음'으로 지정값 입력 시 오류 발생
-- * DECODE(IF문) : DECODE(컬럼, 조건1, 결과1, 조건2, 결과2, 모두 아닐 경우). if(조건1 == 결과1) else if(조건2 == 결과2) else return 모두 아닐 경우
SELECT EMP_NAME "이름", DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여', '3', '남', '4', '여', '무') "성별" FROM EMPLOYEE;
-- * CASE(SWITCH문) : CASE WHE(조건1) THEN 결과1 WHEN 조건2 THEN 결과2 ELSE default_result END (AS) 원하는 컬럼명
SELECT EMP_NAME "이름", 
CASE 
    WHEN SUBSTR(EMP_NO, 8, 1) = '1' THEN '남'
    WHEN SUBSTR(EMP_NO, 8, 1) = '2' THEN '여'
    WHEN SUBSTR(EMP_NO, 8, 1) = '3' THEN '남'
    WHEN SUBSTR(EMP_NO, 8, 1) = '4' THEN '여'
END "성별"
FROM EMPLOYEE;

-- < 다중형 함수의 종류 >
-- * SUM : 합
SELECT SUM(SALARY) FROM EMPLOYEE;
-- * AVG : 평균
SELECT AVG(SALARY) FROM EMPLOYEE;
-- * COUNT : 갯수
SELECT COUNT(*) FROM EMPLOYEE;
-- * MAX : 최댓값, MIN : 최솟값
SELECT MAX(SALARY), MIN(SALARY) FROM EMPLOYEE;
-- < GROUP BY & HAVING >
-- 기준값에 따라 각각의 결과값을 출력
SELECT DEPT_CODE, SUM(SALARY) FROM EMPLOYEE GROUP BY DEPT_CODE ORDER BY 1 ASC;

-- 실습문제1)
-- EMPLOYEE 테이블에서 부서코드, 그룹별 급여의 합계, 그룹별 급여의 평균(정수처리), 인원수를 조회하고, 부서코드 순으로 정렬하세요
SELECT DEPT_CODE, SUM(SALARY), FLOOR(AVG(SALARY)), COUNT(SALARY) FROM EMPLOYEE GROUP BY DEPT_CODE ORDER BY 1 ASC;

-- 실습문제2)
-- EMPLOYEE 테이블에서 부서코드, 보너스를 지급받는 사원 수를 조회하고 부서코드 순으로 정렬하세요
-- BONUS 컬럼의 값이 존재한다면 그 행을 1로 카운팅, 보너스를 지급받은 사원이 없는 부서도 있음을 확인
SELECT DEPT_CODE, COUNT(BONUS) FROM EMPLOYEE WHERE BONUS IS NOT NULL GROUP BY DEPT_CODE ORDER BY DEPT_CODE ASC;

-- 실습문제3)
-- EMPLOYEE 테이블에서 직급이 J1인 사람들을 제외하고 직급별 사원수 및 평균급여를 출력하세요.
SELECT JOB_CODE, COUNT(*) "사원수", FLOOR(AVG(SALARY)) "평균 급여" FROM EMPLOYEE
WHERE JOB_CODE NOT IN 'J1' -- 또는 JOB_CODE != 'J1' 또는 JOB_CODE <> 'J1'
GROUP BY JOB_CODE;

-- 실습문제4)
-- EMPLOYEE 테이블에서 직급이 J1인 사람들을 제외하고 입사년도별 인원수를 조회해서, 입사년도 기준으로 오름차순으로 정렬하세요.
SELECT EXTRACT(YEAR FROM HIRE_DATE) "입사년도", COUNT(*) "인원수" FROM EMPLOYEE 
WHERE JOB_CODE NOT IN 'J1' 
GROUP BY EXTRACT(YEAR FROM HIRE_DATE) -- 또는 TO_DATE(HIRE_DATE, 'YYYY')
ORDER BY 1 ASC; -- 1 : 첫번째 행 또는 EXTRACT(YEAR FROM HIRE_DATE) 써도 됨

-- 실습문제5)
-- EMPLOYEE 테이블에서 EMP_NO의 8번째 자리가 1, 3이면 '남', 2, 4이면 '여'로 결과를 조회하고, 성별별 급여의 평균(정수처리), 급여의 합계, 인원수를 조회한 뒤 인원수로 내림차순을 정렬하시오.
SELECT DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여', '3', '남', '4', '여', '무') "성별",
FLOOR(AVG(SALARY)), SUM(SALARY), COUNT(SALARY) 
FROM EMPLOYEE
GROUP BY DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여', '3', '남', '4', '여', '무')
ORDER BY 3 DESC;

-- 실습문제6)
-- 부서내 직급별 급여의 합계를 구하시오
SELECT DEPT_CODE, JOB_CODE SUN(SALARY) FROM EMPLOYEE GROUP BY DEPT_CODE, JOB_CODE;

-- 실습문제7)
-- 부서내 성별 인원수를 구하시오
SELECT DEPT_CODE, DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여', '3', '남', '4', '여', '무') "성별", COUNT(SALARY) FROM EMPLOYEE
GROUP BY DEPT_CODE, DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여', '3', '남', '4', '여', '무')
ORDER BY 1 ASC;

-- SELECT문에서 조건을 걸 때 WHERE 사용하지만 GROUP BY의 결과값에 조건을 걸 때는 HAVING을 사용
SELECT DEPT_CODE, JOB_CODE SUN(SALARY) FROM EMPLOYEE 
GROUP BY DEPT_CODE, JOB_CODE
HAVING SUM(SALARY) >= 5000000
ORDER BY 1 ASC;

-- 부서별 인원수가 5명 미만/초과인 레코드를 출력하세요.
SELECT DEPT_CODE, COUNT(*) FROM EMPLOYEE 
GROUP BY DEPT_CODE
HAVING COUNT(*) < 5;

-- 실습문제8)
-- 부서별 인원이 5명보다 많은 부서와 인원수를 출력하세요.
SELECT DEPT_CODE, COUNT(*) FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(*) > 5;

-- 실습문제9)
-- 부서내 직급별 인원수가 3명이상인 직급의 부서코드, 직급코드, 인원수를 출력하세요.
SELECT DEPT_CODE, JOB_CODE, COUNT(*) FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
HAVING COUNT(*) >= 3;

-- 실습문제10)
-- 매니저가 관리하는 사원이 2명 이상인 매니저아이디와 관리하는 사원수를 출력하세요.
SELECT EMP_ID, EMP_NAME, MANAGER_ID FROM EMPLOYEE;

SELECT MANAGER_ID, COUNT(*) FROM EMPLOYEE
GROUP BY MANAGER_ID
HAVING COUNT(*) >= 2;

-- ROLLUP과 CUBE
-- ROLLUP : 맨 처음 명시한 컬럼에 대해서만 소그룹 합계
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY) FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY 1 ASC;

SELECT DEPT_CODE, JOB_CODE, SUM(SALARY) FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1 ASC;










