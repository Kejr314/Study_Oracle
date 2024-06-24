-- Function
-- Oracle 함수의 종류
-- 1. 단일행 함수 : 결과값 여러개
-- 2. 다중행 함수 : 결과값 1개(그룹 함수)
SELECT SUM(SALARY) FROM EMPLOYEE;

-- 1) 숫자 처리 함수
-- ABS(절대값), MOD(나머지), TRUNC(지정한 소숫점 아래 버림), FLOOR(버림), FOUND(반올림), CEIL(올림)
SELECT TRUNC(SYSDATE-HIRE_DATE, 2) FROM EMPLOYEE; -- TRUNC(값 , 소숫점 위치)
-- DUAL : 함수의 결과를 테스트해볼 수 있게 ?주는 가상의 테이블
SELECT MOD(35, 3) FROM DUAL;
SELECT SYSDATE FROM DUAL;
SELECT ABS(-1) FROM DUAL;

-- 2) 문자 처리 함수

-- 3) 날짜 처리 함수
-- ADD_MONTHS(), MONTHS_BETWEEN(), LAST_DAY(), EXTRACT, SYSDATE
SELECT ADD_MONTHS(SYSDATE, 2) FROM DUAL; -- 2개월 뒤 출력. ADD_MONTHS(날짜, 숫자) : n개월 뒤
SELECT MONTHS_BETWEEN(SYSDATE, '24/05/07') FROM DUAL; -- 1.3개월 정도 지남
-- LAST_DAY() : 마지막 날짜
SELECT LAST_DAY(SYSDATE)+1 FROM DUAL; -- +1 을 쓰는 이유 : 다음 달의 첫째 날
SELECT LAST_DATY('24/02/23')+1 FROM DUAL;
-- EXTRACT : 년도, 월, 일을 DATE에서 추출
SELECT EXTRACT(YEAR FROM SYSDATE) FROM DUAL; -- 년
SELECT EXTRACT(MONTH FROM SYSDATE) FROM DUAL; -- 월
SELECT EXTRACT(DAY FROM SYSDATE) FROM DUAL; -- 일


-- 예제

-- ex1) EMPLOYEE 테이블에서 사원의 이름, 입사일, 입사 후 3개월이 된 날짜를 조회하시오.
SELECT EMP_NAME "이름", HIRE_DATE "입사일", ADD_MONTHS(HIRE_DATE, 3) "입사 후 3개월"
FROM EMPLOYEE;

-- ex2) EMPLOYEE 테이블에서 사원의 이름, 입사일, 근무 개월수를 조회하시오.
-- (SYSDATE-HIRE_DATE)/30과 MONTHS_BETWEEN(SYSDATE, HIRE_DATE) 결과 오차가 있음 > 달마다 일 수가 다르기 때문
SELECT EMP_NAME "이름", HIRE_DATE "입사일", FLOOR((SYSDATE-HIRE_DATE)/30) "근무 개월 : /30", FLOOR(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) "근무 개월 : MONTHS_BETWEEN"
FROM EMPLOYEE;

-- ex3) EMPLOYEE 테이블에서 사원이름, 입사일, 입사월의 마지막날을 조회하세요.
SELECT EMP_NAME "이름", HIRE_DATE "입사일", LAST_DAY(HIRE_DATE) "입사월의 마지막날" FROM EMPLOYEE;

-- ex4) EMPLOYEE 테이블에서 사원이름, 입사 년도, 입사 월, 입사 일을 조회하시오.
SELECT EMP_NAME "이름", EXTRACT(YEAR FROM HIRE_DATE)||'년' "입사 년도", EXTRACT(MONTH FROM HIRE_DATE)||'월' "입사 월", EXTRACT(DAY FROM HIRE_DATE)||'일' "입사 일" FROM EMPLOYEE;












