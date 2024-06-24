-- Object

-- 1. Veiw 
-- - 실제 테이블에 근거한 논리적인 가상의 테이블(사용자에게 하나의 테이블처럼 사용 가능하게 함)
-- - SELECT 쿼리의 실행 결과를 화면에 저장한 논리적인 가상의 테이블(실직적인 데이터를 저장하고 있지 않지만 하나의 테이블처럼 사용 가능)
-- - VIEW를 만들 때 권한이 필요, 권한명 : CREATE VIEW
GRANT CREATE VIEW TO KH;
-- 1) 종류 
-- * Stored View(저장O) : 이름을 붙여서 저장
CREATE VIEW EMP_VIEW
AS SELECT EMP_ID, DEPT_CODE, JOB_CODE, MANAGER_ID FROM EMPLOYEE;
-- View 결과
SELECT * FROM EMP_VIEW;

-- * InLine View(저장X) : FROM 절 뒤에 적는 서브쿼리 
SELECT * FROM (SELECT EMP_ID0 DEPT_CODE, JOB_CODE, MANAGER_ID FROM EMPLOYEE);

-- 2) 특징
-- - 테이블에 있는 데이터를 보여줄 뿐이며, 데이터 자체를 포함하고 있는 것은 아님
-- - 저장장치 내에 물리적으로 존재하지 않고 가상 테이블로 만들어짐.
-- - 물리적인 실제 테이블과의 링크 개념
-- 3) 목적
-- - 원본 데이블이 아닌 뷰를 통해 특정 데이터만 보이도록 함
-- - 특정 사용자가 원본 테이블에 접근하여 모든 데이터를 보게하는 것을 방지

-- ex) 연봉정보를 가지고 있는 VIEW를 생성하시오.(ANNUAL_SALARY_VIEW), 사번, 이름, 급여, 연봉
CREATE VIEW ANNUAL_SALARY_VIEW(사번, 이름, 급여, 연봉)
AS SELECT EMP_ID, EMP_NAME, SALARY, SALARY*12 FROM EMPLOYEE;

SELECT * FROM ANNUAL_SALARY_VIEW;

-- ex) 전체 직원의 사번, 이름, 직급명, 부서명, 지역명을 볼 수 있는 VIEW를 생성하시오(ALL_INFO_VIEW)
CREATE VIEW ALL_INFO_VIEW
AS SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME 
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE;

SELECT * FROM ALL_INFO_VIEW;

-- VIEW 수정하기
CREATE VIEW V_EMPLOYEE
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE;

SELECT * FROM V_EMPLOYEE;
-- ex) 선동일의 DEPT_CODE를 D8로 변경하는 DML을 작성하시오.
UPDATE V_EMPLOYEE
SET DEPT_CODE = 'D8'
WHERE EMP_ID = '200';

SELECT * FROM EMPLOYEE; -- 원본 EMPLOYEE로 변경됨
-- VEIW와 원본은 링크가 되어 있어서 VIEW 수정 시 원본도 수정됨

ROLLBACK;

-- < VEIW 옵션 >
CREATE VIEW V_EMPLOYEE
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, SALARY
FROM EMPLOYEE;
-- * OR REPLACE : 수정하기 
-- 기존 VEIW를 수정하고 싶을 경우
-- 방법1) 삭제 후 재생성 (SALARY 추가)
DROP VIEW V_EMPLOYEE;
SELECT * FROM V_EMPLOYEE;
-- 방법2) 'OR REPLACE' 옵션 명령어 입력하여 수정(SALARY 제거)
CREATE OR REPLACE VIEW V_EMPLOYEE
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE;

-- * FORCE/NOFORCE : 기본 테이블이 존재하지 않더라도 뷰를 생성
-- * WITH CHECK OPTION : WHERE 조건에 사용한 컴럼의 값을 수정하지 못하게 함
-- * WITH READ ONLY : VIEW에 대해 조회만 가능하며 DML 불가능하게 함
CREATE OR REPLACE VIEW V_EMPLOYEE
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE WITH READ ONLY;

UPDATE V_EMPLOYEE SET EMP_NAME = '선동열' WHERE EMP_ID = '200';
-- SQL 오류: ORA-42399: cannot perform a DML operation on a read-only view

-- 실습예제1)
-- KH계정 소유의 한 EMPLOYEE, JOB, DEPARTMENT 테이블의 일부 정보를 사용자에게 공개하려고 한다.
-- 사원아이디, 사원명, 직급명, 부서명, 관리자명, 입사일의 컬럼정보를 뷰(V_EMP_INFO)를 (읽기 전용으로) 생성하여라.

CREATE OR REPLACE VIEW V_EMP_INFO(사원아이디, 사원명, 직급명, 부서명, 관리자명, 입사일)
AS SELECT EMP_ID, EMP_NAME, JOB_NAME, NVL(DEPT_TITLE, '미정'), 
NVL((SELECT EMP_NAME FROM EMPLOYEE WHERE EMP_ID = E.MANAGER_ID), '없음'), HIRE_DATE
FROM EMPLOYEE E
LEFT OUTER JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
LEFT OUTER JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID WITH READ ONLY;
-- 부서명이 'null'인 경우도 출력되기 위해 LEFT OUTER 명령어 사용 & NVL(DEPT_TITLE, '미정')

SELECT * FROM V_EMP_INFO;

-- 관리자명 구하기 
SELECT * FROM EMPLOYEE WHERE EMP_NAME = '송종기';
SELECT EMP_NAME FROM EMPLOYEE WHERE EMP_ID = 200; -- EMP_ID = 송종기의 관리자사번

-- 2. DD(Data Dictionary)
-- - DBMS를 설치할 때 자동으로 만들어지며 자월을 효율적으로 관리하기 위해 다양한 정보를 저장한 시스템 테이블
-- - Data Dictionary는 사용자가 테이블을 생성하거나 사용자를 변경하는 등의 작업을 할 때 데이터베이스 서버(오라클)에 의해 자동으로 갱신되는 테이블
-- - 사용자는 Data Dictionary의 내용을 직접 수정하거나 삭제할 수 없음
-- - Data Dictionary 안에는 중요한 정보가 많이 있기 때문에 사용자는 이를 활용하기 위해서는 Data Dictionary 뷰를 사용하게 됨

-- < Data Dictionary 종류 >
-- * USER_XXX : 접속한 계정이 소유한 객체 등에 관한 정보를 조회함
SELECT * FROM USER_VIEWS;
SELECT * FROM USER_CONSTRAINTS;
SELECT * FROM USER_SYS_PRIVS;
SELECT * FROM USER_ROLE_PRIVS;
-- * ALL_XXX : 접속한 계정이 권한 부여 받은 것과 소유한 모든 것에 관한 정보를 조회
SELECT * FROM ALL_TABLES;
SELECT * FROM ALL_VIEWS;
-- * DBA_XXX : 데이터베이스 관리자만 접근이 가능한 객체 등의 정보 조회, System 계정으로만 실행 가능
SELECT * FROM DBA_TABLES;


-- Sequence 객체
SELECT * FROM USER_TCL;
-- USER_NO 컬럼에 저장되는 데이터는 1부터 시작하여 1씩 증가
-- 일용자 = 1, 이용자 = 2,...
-- USER_NO 컬럼에 들어가는 데이터는 누군가 기억하고 있어야 함
-- Sequence의 역할 : 마지막 번호가 몇번이었는지 몇씩 증가해서 들어가야하는지를 기억
-- 순차적으로 정수 값을 자동으로 생성하는 객체, 자동 번호 발생기(재번기)의 역할
-- 사용법 : GREATE SEQUENCE 시퀀스명; -> 기본값(1부터 1씩 증가)
-- < Sequence 옵션 >
-- * MINVALUE : 발생시킬 최소값 지정 
-- * MAXVALUE : 발생시킬 최대값 지정
-- * START WITH : 처음부터 발생시킬 시작값 지정, 기본값 1 
-- * INCREMENT BY : 다음 값에 대한 증가치, 기본값 1
-- * NOCYCLE : 시퀀스값이 최대값까지 증가를 완료하면 CYCLE은 START WITH로 다시 시작
-- * NOCACHE : 메모리 상에서 시퀀스값을 관리, 기본값 20, NOCACHE를 안하면 갑자기 시퀀스값이 증가하게 됨
-- 생성
CREATE SEQUENCE SEQ_KH_USER_NO
MINVALUE 1
MAXVALUE 100000
START WITH 1
INCREMENT BY 1
NOCYCLE
NOCACHE;

-- 삭제
DROP SEQUENCE SEQ_KH_USER_NO;

-- 조회
SELECT * FROM USER_SEQUENCES;

-- < 시퀀스 사용방법 >
-- * 문법
-- CREATE SEQUENCE 시퀀스명
-- MINVALUE 1
-- MAXVALUE 100000
-- START WITH 1
-- INCREMENT BY 1
-- NOCYCLE
-- NOCACHE;
-- * 사용법
-- 시퀀스명.NEXTVAL 또는 시퀀스명.CURRVAL을 SELECT 뒤 또는 INSERT INTO VALUES의 전달값으로 작성
SELECT SEQ_KH_USER_NO.NEXTVAL FROM DUAL; -- 첫 NEXTVAL은 시퀀스를 개시. 필수조건
-- 실행할 때마다 설정한 INCREMENT BY 값만큼 증가함
SELECT SEQ_KH_USER_NO.CURRVAL FROM DUAL; -- NEXTVAL를 실행한 후 현재 시퀀스값 조회

SELECT * FROM USER_TCL;
DELETE FROM USER_TCL;
COMMIT;

INSERT INTO USER_TCL
VALUES(SEQ_KH_USER_NO.NEXTVAL, 'khuser01', '일용자');
INSERT INTO USER_TCL
VALUES(SEQ_KH_USER_NO.NEXTVAL, 'khuser02', '이용자');
INSERT INTO USER_TCL
VALUES(SEQ_KH_USER_NO.NEXTVAL, 'khuser03', '삼용자');

-- 실습문제1)
-- 고객이 상품주문시 사용할 테이블 ORDER_TBL을 만들고, 다음과 같이 컬럼을 구성하세요.
-- ORDER_NO(주문NO) : NUMBER, PK
-- USER_ID(고객아이디) : VARCHAR2(40)
-- PRODUCT_ID(주문상품 아이디) : VARCHAR2(40)
-- PRODUCT_CNT(주문갯수) : NUMBER
-- ORDER_DATE : DATE, DEFAULT SYSDATE

CREATE TABLE ORDER_TBL
(
    ORDER_NO NUMBER PRIMARY KEY,
    USER_ID VARCHAR2(40),
    PRODUCT_ID VARCHAR2(40),
    PRODUCT_CNT NUMBER,
    ORDER_DATE DATE DEFAULT SYSDATE
);

COMMENT ON COLUMN ORDER_TBL.ORDER_NO IS '주문NO';
COMMENT ON COLUMN ORDER_TBL.USER_ID IS '고객아이디';
COMMENT ON COLUMN ORDER_TBL.PRODUCT_ID IS '주문상품 아이디';
COMMENT ON COLUMN ORDER_TBL.PRODUCT_CNT IS '주문갯수';

-- SEQ_ORDER_NO 시퀀스를 생성하여 다음의 데이터를 추가하세요.
-- * kang님이 saewookkang상품을 5개 주문하셨습니다.
-- * gam님이 gamjakkang상품을 30개 주문하셨습니다.
-- * ring님이 onionring상품을 50개 주문하셨습니다.

CREATE SEQUENCE SEQ_ORDER_NO
MINVALUE 1
MAXVALUE 100000
START WITH 1
INCREMENT BY 1
NOCYCLE
NOCACHE
;

INSERT INTO ORDER_TBL (ORDER_NO, USER_ID, PRODUCT_ID, PRODUCT_CNT, ORDER_DATE)
VALUES (SEQ_ORDER_NO.NEXTVAL,'kang', 'saewookkang', 5, SYSDATE);
INSERT INTO ORDER_TBL (ORDER_NO, USER_ID, PRODUCT_ID, PRODUCT_CNT, ORDER_DATE)
VALUES (SEQ_ORDER_NO.NEXTVAL, 'kam', 'gamjakkang', 30, SYSDATE);
INSERT INTO ORDER_TBL (ORDER_NO, USER_ID, PRODUCT_ID, PRODUCT_CNT, ORDER_DATE)
VALUES (SEQ_ORDER_NO.NEXTVAL, 'ring', 'onionring', 50, SYSDATE);

/*
INSERT INTO ORDER_TBL
VALUES(SEQ_ORDER_NO.NEXTVAL, 'kang', 'saewookkang', 5, SYSDATE);
INSERT INTO ORDER_TBL
VALUES(SEQ_ORDER_NO.NEXTVAL, 'kam', 'gamjakkang', 50, SYSDATE);
INSERT INTO ORDER_TBL
VALUES(SEQ_ORDER_NO.NEXTVAL, 'ring', 'onionring', 50, SYSDATE);
*/

SELECT * FROM ORDER_TBL;

COMMIT;

-- 실습문제2)
-- KH_MEMBER 테이블을 생성하세요
-- 컬럼 : MEMBER_ID, MEMBER_NAME, MEMBER_AGE, MEMBER_JOIN_COM
-- 자료형 : NUMBER, VARCHAR2(20), NUMBER, NUMBER
-- 1. ID값은 500번부터 시작하여 10씩 증가하여 저장
-- 2. JOIN_COM값은 1번부터 시작하여 1씩 증가하여 저장
-- MEMBER_ID    MEMBER_NAME     MEMBER_AGE      MEMBER_JOIN_COM
--  500             홍길동         20                  1
--  510             청길동         30                  2
--  520             외길동         40                  3
--  530             고길동         50                  4

CREATE TABLE KH_MEMBER
(
    MEMBER_ID NUMBER,
    MEMBER_NAME VARCHAR2(20),
    MEMBER_AGE NUMBER,
    MEMBER_JOIN_COM NUMBER
);

CREATE SEQUENCE SEQ_MEMBER_ID
MINVALUE 500
START WITH 500
INCREMENT BY 10
NOCYCLE
NOCACHE
;

CREATE SEQUENCE SEQ_MEMBER_JOIN_COM
--MINVALUE 1
--START WITH 1
--INCREMENT BY 1
NOCYCLE
NOCACHE
;

INSERT INTO KH_MEMBER
VALUES (SEQ_MEMBER_ID.NEXTVAL, '홍길동', 20, SEQ_MEMBER_JOIN_COM.NEXTVAL);
INSERT INTO KH_MEMBER
VALUES (SEQ_MEMBER_ID.NEXTVAL, '청길동', 30, SEQ_MEMBER_JOIN_COM.NEXTVAL);
INSERT INTO KH_MEMBER
VALUES (SEQ_MEMBER_ID.NEXTVAL, '외길동', 40, SEQ_MEMBER_JOIN_COM.NEXTVAL);
INSERT INTO KH_MEMBER
VALUES (SEQ_MEMBER_ID.NEXTVAL, '고길동', 20, SEQ_MEMBER_JOIN_COM.NEXTVAL);

SELECT * FROM KH_MEMBER;

-- < 시퀀스 수정 >
-- ALTER를 이용해서 옵션들을 수정하면 됨
ALTER SEQUENCE SEQ_MEMBER_ID
-- START WITH 변경 불가 -> 삭제 후 다시 생성
INCREMENT BY 1
MAXVALUE 100000;

SELECT * FROM USER_SEQUENCES;
























