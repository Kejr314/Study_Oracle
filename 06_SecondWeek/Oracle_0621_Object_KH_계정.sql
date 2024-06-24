-- 06/21
-- 오라클 객체
-- DB를 효율적으로 관리 또는 동작하게 하는 요소
-- 오라클 객체의 종류
-- 사용자(USER), 테이블(TABLE), 뷰(VIEW), 시퀀스(SEQUENCE), 역할(ROLE), 인덱스(INDEX)
-- 프로시저(PROCEDUAL), 함수(FUNCTION), 트리거(TRIGER), 동의어(SYSNONYM), 커서(CURSOR), 패키지(PACKGE)...

-- 3. ROLE
-- 사용자에게 여러 개의 원한을 한번에 부여할 수 있는 데이터베이스 객체
-- 사용자에게 권한을 부여할 때 한개씩 부여하게 된다면 권한 부여 및 회수의 관리가 불편하므로 사용하는 객체
SELECT * FROM DBA_SYS_PRIVS ORDER BY 2 ASC; -- system계정으로 

-- < DCL(Data Control Language) : GRANT / REVOKE
-- 권한 부여 및 회수는 관리자 세션에서 사용 가능
-- 관리자 계정
-- * system : 일반 관리자, 대부분의 권한을 가지고 있음
-- * sys : DB 생성/삭제 권한이 있음. 로그인 옵션으로 as sysdba  를 적어줘야 함
GRANT CONNECT, RESOURCE TO KH;
-- CONNECT, RESOURCE는 권한이 모여있는 ROLE
-- ROLE에 부여된 시스템 권환 확인

SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'CONNECT'; -- 관리자 계정에서 사용
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'RESOURCE'; -- 관리자 계정에서 사용
-- CREATE VIEW 권한이 RESOURCE ROLE에 없었기 때문에 따로 권한부여를 해줌
-- GRANT CREATE VIEW TO KH;

SELECT * FROM ROLE_SYS_PRIVS WHERE ROLE = 'CONNECT'; -- KH계정에서 사용
-- ROLE에 부여된 테이블 권한
SELECT * FROM ROLE_TAB_PRIVS;
-- 계정에 부여된 롤과 권한 확인
SELECT * FROM USER_ROLE_PRIVS;
SELECT * FROM USER_SYS_PRIVS;
 
-- 4. INDEX
-- SQL 명령문의 처리 속도를 향샤ㅏㅇ시키기 위해서 컬럼에 대해서 생성하는 오라클 객체
-- KEY와 VALUE 형태로 생성이 되며 KEY에는 인덱스로 만들 컬럼값, VALUE에는 행이 저장됨
-- 장점 : 검색 속도가 빨라지고 시스템에 걸리는 부하를 감소시켜서 시스템 전체 성능을 향상시킬 수 있음
-- 단점 : 인덱스를 위한 추가 저장 공간이 필요하고 인덱스를 생성하는데 시간이 걸림
-- 데이터의 변경 작업이 자주 일어나는 테이블에 INDEX 생성 시 오히려 성능 저하가 발생할 수 있음
-- 데이터값이 중복된 것이 없는 고유한 데이터값을 가지는 컬럼에 만드는 것이 좋음
-- 자주 사용되는 컬럼에 만들면 좋음
-- * 효율적인 인덱스 사용 예
-- 1. WHERE절에 자주 사용되는 컬럼에 인덱스 생성
-- : 전체 데이터 중에 10 ~ 15% 이내의 데이터를 검색하는 경우, 중복이 많지 않은 컬럼이어야 함.
-- 2. 두 개 이상의 컬럼 WHERE절이나 조인(JOIN)조건으로 자주 사용되는 경우
-- 3. 한번 입력된 데이터의 변경이 자주 일어나지 않는 경우
-- 4. 한 테이블에 저장된 데이터 용량이 상당히 클 경우 

SELECT * FROM EMPLOYEE;

-- 인덱스 생성
CREATE INDEX IND_EMP_ENAME ON EMPLOYEE(EMP_NAME);
-- 인덱스 확인
SELECT * FROM USER_INDEXES;
SELECT * FROM USER_IND_COLUMNS;
-- 인덱스 삭제
DROP INDEX IND_EMP_ENAME;

CREATE INDEX IND_EMP_INFO ON EMPLOYEE(EMP_ID, EMP_NO, SALARY);

-- 튜닝 시 사용되는 명령어
-- #1
EXPLAIN PLAN FOR SELECT EMP_ID, EMP_NO, SALARY FROM EMPLOYEE
WHERE EMP_ID LIKE '2%';
-- 설명되었습니다.
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- #2
SET TIMING ON;
SELECT EMP_ID, EMP_NO, SALARY FROM EMPLOYEE
WHERE EMP_ID LIKE '2%';
SET TIMING OFF;
-- F10으로 실행하여 오라클 PLAN 확인 가능, 튜닝 시 사용







































