-- < 오라클 인덱스 실습 >
-- 1. 100만개의 데이터를 넣을 테이블 생성
-- 2. 100만개 데이터 삽입(PL/SQL 반복문)
-- 3. 인덱스 설정 전 테스트
-- 4. 인덱스 설정
-- 5. 인덱스 설정 후 테스트

-- #1
-- 아이디, 비번, 이름, 전번, 주소, 등록일, 수정일
-- KH_CUSTOMER_TBL
CREATE TABLE KH_CUSTOMER_TBL
(
    USER_ID VARCHAR2(20),
    USER_PW VARCHAR2(30),
    USER_NAME VARCHAR2(30),
    USER_PHONE VARCHAR2(30),
    USER_ADDR VARCHAR2(500),
    REG_DATE TIMESTAMP DEFAULT SYSTIMESTAMP,
    FIX_DATE TIMESTAMP DEFAULT SYSTIMESTAMP
);
-- Tabel KH_CUSTOMER_TBL 생성됨

CREATE SEQUENCE SEQ_CUSTOMER_USERID
MINVALUE 1
MAXVALUE 999999999
START WITH 1
INCREMENT BY 1
NOCYCLE
NOCACHE;
-- Sequence SEQ_CUSTOMER_USERID 생성됨

-- #2
DECLARE
    V_USERID VARCHAR2(200);
BEGIN
    FOR N IN 10..1000000
    LOOP
        V_USERID := '1'||LPAD(SEQ_CUSTOMER_USERID.NEXTVAL, 9, 0);
        INSERT INTO KH_CUSTOMER_TBL
        VALUES(V_USERID, '0000', N || '용자', '010-0000-0000', '서울시 중구 남대문로' || N, DEFAULT, DEFAULT);
    END LOOP;
END;
/

SELECT COUNT(*) FROM KH_CUSTOMER_TBL; -- 1000001

-- #3
-- 인덱스 걸기 전 실행시간 체크
EXPLAIN PLAN FOR
SELECT * FROM KH_CUSTOMER_TBL WHERE USER_NAME LIKE '22%융자';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
-- Operation : TABLE ACCESS FULL, Cost (%CPU) : 4049, Time : 00:00:49

-- #4
-- 인덱스 생성하기
CREATE INDEX IDX_CUSTOMER_USERNAME ON KH_CUSTOMER_TBL(USER_NAME);
/*
| Id  | Operation                   | Name                  | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |                       |   164 | 55924 |  1852   (0)| 00:00:23 |
|   1 |  TABLE ACCESS BY INDEX ROWID| KH_CUSTOMER_TBL       |   164 | 55924 |  1852   (0)| 00:00:23 |
|*  2 |   INDEX RANGE SCAN          | IDX_CUSTOMER_USERNAME |  7857 |       |    33   (0)| 00:00:01 |
*/


















