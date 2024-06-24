-- DCL, TCL

-- TCL(Transaction Control Language)
-- COMMIT, ROLLBACK, SAVEPOINT
-- 한꺼번에 수행되어야 할 최소의 작업 단위
-- ex1) ATM 출금 : 카드 투입 > 메뉴 선택 > 금액 입력 > 비밀번호 입력 > 출금 완료
-- ex2) 계좌 이체 : 송금 버튼 터치 > 계좌번호 입력 > 은행명 선택 > 금액 입력 > 비밀번호 > 이체 버튼 터치
-- Oracle 트랜젝션
-- INSERT 수행 or UPDATE 수행 or DELETE 수행이 되었다면 그 뒤에 추가 잡업이 있을 것으로 간주하고 처리 -> 트랜젝션이 걸림
DESC USER_GRADE;

-- COLUMN 2개만 있게 만드려고 실행함
ALTER TABLE USER_GRADE
DROP COLUMN GRADE_DATE;

INSERT INTO USER_GRADE
VALUES(10, '일반회원');
COMMIT;
ROLLBACK;

-- < TCL 명령어 >
-- COMMIT : 트랜젝션 작업이 정상 완료되어 변경 내용을 영구적으로 저장(모든 savepoint 삭제)
-- ROLLBACK : 트랜젝션 작업을 모두 취소하고 가장 최근에 COMMIT한 시점으로 이동
-- SAVEPOINT <savepoint명> : 현재 트랜젝션 작업 시점에 이름을 저장, 임시 저장이며 하나의 트랜젝션에서 구역을 나눌 수 있음
CREATE TABLE USER_TCL
(
    USER_NO NUMBER UNIQUE,
    USER_ID VARCHAR2(30) PRIMARY KEY,
    USER_NAME VARCHAR2(20) NOT NULL
);

DESC USER_TCL;

INSERT INTO USER_TCL
VALUES(1, 'khuser01', '일용자');
INSERT INTO USER_TCL
VALUES(2, 'khuser02', '이용자');
INSERT INTO USER_TCL
VALUES(3, 'khuser03', '삼용자');
COMMIT; -- INSERT한 데이터 영구 저장됨

INSERT INTO USER_TCL
VALUES(4, 'khuser04', '사용자');
SAVEPOINT UNITIL4; -- SAVEPOINT 생성

INSERT INTO USER_TCL
VALUES(5, 'khuser05', '오용자');

ROLLBACK TO UNITIL4; -- SAVEPOINT로 이동

ROLLBACK; -- 마지막 COMMIT 시점으로 이동, SAVEPOINT 삭제

-- DCL(Data Control Language)
-- DB에 대한 보안, 무결성, 복구 등 DBMS를 제어하기 위한 언어
-- GRANT, REVOKE, (COMMIT, ROLLBACK)
-- 권한부여 및 회수는 System_계정에서만 가능

-- KH_계정은 CHUN에 있는 TB_CLASS를 조회할 권한X
SELECT * FROM CHUN.TB_CLASS;
-- 권한을 부여함으로써 조회됨
GRANT SELECT ON CHUN.TB_CLASS TO KH;
-- 권한 회수하여 조회 차단
REVOKE SELECT ON CHUN.TB_CLASS FROM KH;

SELECT * FROM ROLE_SYS_PRIVS
WHERE ROLE = 'COMMENT';
SELECT * FROM USER_ROLE_PRIVS;
SELECT * FROM USER_SYS_PRIVS;














