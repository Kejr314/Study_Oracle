-- 06/21, PL/SQL
-- Oracle's Procedural Language Extension to SQL의 약자
-- 오라클 자체에 내장되어 있는 절차적 언어로써, SQL의 단점을 보완하여 SQL 문장내에서 변수의 정의, 조건 처리, 반복 처리 등을 지원
-- < 구조 >
-- * 블록 문법
-- 1. 선언부 (선택) : DECLARE
-- 2. 실행부 (필수) : BEGIN
-- 3. 예외처리부 (선택) : EXCPTION
-- 4. END; (필수) : END;
-- 5. / (필수) : /

BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello PL/SQL');
END;
/

SET SERVEROUTPUT ON; -- 먼저 실행해줘야 Hello PL 출력됨

-- PL/SQL에서 변수쓰는 방법
DECLARE
    VID NUMBER;
BEGIN
    -- VID:= 1023;
    SELECT SALARY 
    INTO VID -- VID에 값 넣어짐 
    FROM EMPLOYEE WHERE EMP_NAME = '선동일'; -- VID = '선동일'의 SALARY
    DBMS_OUTPUT.PUT_LINE('ID : ' || VID);
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No DATA~'); -- 예외 처리, 데이터가 없을 경우 'No DATA~'가 출력됨
END;
/

-- < PL/SQL 변수 >
DECLARE
--    VEMPNO CHAR(14);
--    VENAME VARCHAR2(20);
--    VSAL NUMBER;
--    VHDATE DATE;
    VEMPNO EMPLOYEE.EMP_NO %TYPE;
    VEMPNAME EMPLOYEE.EMP_NAME %TYPE;
    VSAL EMPLOYEE.SALARY %TYPE;
    VHDATE EMPLOYEE.HIRE_DATE %TYPE;
BEGIN
    SELECT EMP_NO, EMP_NAME, SALARY, HIRE_DATE 
    INTO VEMPNO, VEMPNAME, VSAL, VHDATE
    FROM EMPLOYEE
    WHERE EMP_ID = '200';
    DBMS_OUTPUT.PUT_LINE(VEMPNO || ' : ' || VEMPNAME || ' : ' || VSAL || ' : ' || VHDATE);
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No DATA~');
END;
/

-- 실습문제1)
-- 사번, 사원명, 직급명을 담을 수 있는 참조변수(%TYPE)를 통해서 송종기 사원의 사번, 사원명, 직급명을 익명블럭을 통해 출력하세요.
DECLARE
    VEMPNO EMPLOYEE.EMP_NO %TYPE;
    VEMPNAME EMPLOYEE.EMP_NAME %TYPE;
    VJOBNAME JOB.JOB_NAME %TYPE;
BEGIN
    SELECT EMP_NO, EMP_NAME, JOB_NAME
    INTO VEMPNO, VEMPNAME, VJOBNAME
    FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE)
    WHERE EMP_NAME = '송종기';
    DBMS_OUTPUT.PUT_LINE(VEMPNO || ' : ' || VEMPNAME || ' : ' || VJOBNAME);
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No DATA~');
END;
/

-- PL/SQL 입력 받기
DECLARE
    VEMP EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO VEMP
    FROM EMPLOYEE
    WHERE EMP_ID = &EMP_ID;
    DBMS_OUTPUT.PUT_LINE('사번 : ' || VEMP.EMP_ID || ', 이름 : ' || VEMP.EMP_NAME);
END;
/

-- 실습문제2)
-- 사원번호를 입력받아서 해당 사원의 사원번호, 이름, 부서코드, 부서명을 출력하세요.
DECLARE
    VEMPID EMPLOYEE.EMP_ID%TYPE;
    VENAME EMPLOYEE.EMP_NAME%TYPE;
    VDCODE EMPLOYEE.DEPT_CODE%TYPE;
    VDTITLE DEPARTMENT.DEPT_TITLE%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
    INTO VEMPID, VENAME, VDCODE, VDTITLE
    FROM EMPLOYEE
    LEFT OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    WHERE EMP_ID = &EMP_ID;
    DBMS_OUTPUT.PUT_LINE('사번 : ' || VEMPID || ', 이름 : ' || VENAME || ', 부서코드 : ' || VDCODE || ', 부서명 : '|| VDTITLE);
END;
/

-- @실습문제3
-- EMPLOYEE 테이블에서 사번의 마지막 번호를 구한뒤 +1한 사번에 
-- 사용자로부터 입력받은 이름, 주민번호, 전화번호, 직급코드, 급여등급을 등록하는 PL/SQL을 작성하시오
DECLARE
    LAST_NUM EMPLOYEE.EMP_ID%TYPE;
    -- 마지막 번호 구하는 쿼리문
BEGIN
    SELECT MAX(EMP_ID)
    -- 마지막 번호 변수에 저장해서 레코드 등록 시 사용
    INTO LAST_NUM
    FROM EMPLOYEE;
    -- 이름, 주민번호, 전화번호, 직급코드, 급여등급 받아서 EMPLOYEE 테이블에 INSERT1
    INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, PHONE, JOB_CODE, SAL_LEVEL)
    VALUES (LAST_NUM+1, '&NAME', '&EMPNO' , '&PHONE', '&JOBCODE', '&SALLEVEL');
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('완료되었습니다.');
END;
/

SELECT * FROM EMPLOYEE ORDER BY EMP_ID DESC;
ROLLBACK;

-- < PL/SQL의 조건문 >
-- 1. IF (조건식) THEN 실행문 END IF;

-- 실습문제1)
-- 사원번호를 입력받아서 사원의 사번, 이름, 급여, 보너스율을 출력하시오
-- 단, 직급코드가 J1인 경우 '저희 회사 대표님입니다.'를 출력하시오.
-- 사번 : 222
-- 이름 : 이태림
-- 급여 : 2460000
-- 보너스율 : 0.35
-- 저희 회사 대표님입니다.
DECLARE
    EMP_INFO EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO EMP_INFO
    FROM EMPLOYEE
    WHERE EMP_ID = '&EMP_ID';
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EMP_INFO.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || EMP_INFO.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || EMP_INFO.SALARY);
    DBMS_OUTPUT.PUT_LINE('보너스율 : ' || EMP_INFO.BONUS*100 || '%');
    
    IF (EMP_INFO.JOB_CODE = 'J1')
    THEN DBMS_OUTPUT.PUT_LINE('저희 회사 대표님입니다.');
    END IF;
END;
/

-- 2. IF (조건식) THEN 실행문 ELSE 실행문 END IF;

-- 실습문제2)
-- 사원번호를 입력받아서 사원의 사번, 이름, 부서명, 직급명을 출력하시오.
-- 단, 직급코드가 J1인 경우 '대표', 그 외에는 '일반직원'으로 출력하시오.
-- 사번 : 201
-- 이름 : 송종기
-- 부서명 : 총무부
-- 직급명 : 부사장
-- 소속 : 일반직원
DECLARE
    V_EMPID EMPLOYEE.EMP_ID%TYPE;
    V_EMPNAM EMPLOYEE.EMP_NAME%TYPE;
    V_DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    V_JNAME JOB.JOB_NAME%TYPE;
    V_JCODE JOB.JOB_CODE%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, JOB_CODE
    INTO V_EMPID, V_EMPNAM, V_DTITLE, V_JNAME, V_JCODE 
    FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    JOIN JOB USING(JOB_CODE)
    WHERE EMP_ID = '&EMP_ID';
    DBMS_OUTPUT.PUT_LINE('사번 : ' || V_EMPID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || V_EMPNAM);
    DBMS_OUTPUT.PUT_LINE('부서명 : ' || V_DTITLE);
    DBMS_OUTPUT.PUT_LINE('직급명 : ' || V_JNAME);
    
    IF (V_JCODE = 'J1')
    THEN DBMS_OUTPUT.PUT_LINE('소속 : 대표');
    ELSE DBMS_OUTPUT.PUT_LINE('소속 : 일반직원');
    END IF;
END;
/

-- 3. IF (조건식) THEN 실행문 ELSIF (조건식) THEN 실행문 ELSIF (조건식) THEN 실행문 ELSE 실행문 END IF;

-- 실습문제3)
-- 사번을 입력 받은 후 급여에 따라 등급을 나누어 출력하도록 하시오.
-- 그때 출력 값은 사번, 이름, 급여, 급여등급을 출력하시오.
-- 500만원 이상(그외) : A
-- 400만원 ~ 499만원 : B
-- 300만원 ~ 399만원 : C
-- 200만원 ~ 299만원 : D
-- 100만원 ~ 199만원 : E
-- 0만원 ~ 99만원 : F
DECLARE
    EMPID EMPLOYEE.EMP_ID%TYPE;
    EMPNAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    SLV EMPLOYEE.SAL_LEVEL%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, SAL_LEVEL
    INTO EMPID, EMPNAME, SAL, SLV
    FROM EMPLOYEE
    WHERE EMP_ID = '&EMP_ID';
    
    -- 데이터가 많은 순서로 IF문을 작성하는 것이 효율적임 -> ELSIF 동작 횟수를 줄일 수 있음
    SAL := SAL/10000;
    IF (SAL >= 500)
--    THEN DBMS_OUTPUT.PUT_LINE('급여등급 : A');
    THEN SLV := 'A';
    ELSIF (SAL BETWEEN 400 AND 499)
--    THEN DBMS_OUTPUT.PUT_LINE('급여등급 : B');
    THEN SLV := 'B';
    ELSIF (SAL >= 300)
--    THEN DBMS_OUTPUT.PUT_LINE('급여등급 : C');
    THEN SLV := 'C';
    ELSIF (SAL BETWEEN 200 AND 299)
--    THEN DBMS_OUTPUT.PUT_LINE('급여등급 : D');
    THEN SLV := 'D';
    ELSIF (SAL >= 100)
--    THEN DBMS_OUTPUT.PUT_LINE('급여등급 : E');
    THEN SLV := 'E';
    ELSE 
--    DBMS_OUTPUT.PUT_LINE('급여등급 : F');
    SLV := 'F';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EMPID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || EMPNAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SAL);
    DBMS_OUTPUT.PUT_LINE('급여등급 : ' || SLV);
    
END;
/

SELECT * FROM EMPLOYEE;
-- ELSIF와 대응되는 CASE문
-- CASE 변수
--  WHEN 값1 THEN 실행문1
--  WHEN 값2 THEN 실행문2
--  WHEN 값3 THEN 실행문3
--  WHEN 값4 THEN 실행문4
--  ELSE 실행문
-- END CASE;

SAL := FLOOR(SAL/1000000); -- 앞자리 정수
CASE SAL
    WHEN 0 THEN SLV := 'F';
    WHEN 1 THEN SVL := 'E';
    WHEN 2 THEN SVL := 'D';
    WHEN 3 THEN SVL := 'C';
    WHEN 4 THEN SVL := 'B';
    ELSE SLV := 'A';
END CASE;


-- < PL/SQL의 반복문 >
-- 


















