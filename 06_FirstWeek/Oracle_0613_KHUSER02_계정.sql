-- 예제 2
-- ID : KHUSER02, PW : KHUSER02 계정 생성 >> System_계정에서 생성하기
-- 테이블 생성 >> 권한 부여해줘야 생성 가능함

SHOW USER;

-- 권한 부여는 "System_계정"에 접속 상태여야 함
-- GRANT : 권한 부여
-- CONNECT : DB 연결 권한
GRANT CONNECT TO KHUSER02;
-- RESOURCE : 개체 생성, 변경, 제거 권한
GRANT RESOURCE TO KHUSER02;

-- 테이블 생성할 때는 "KHUSER02_계정"에 접속 상태여야 함
CREATE TABLE STUDENT_TBL(NAME VARCHAR2(20), AGE NUMBER, GRADE NUMBER, ADDRESS VARCHAR2(200));
INSERT INTO STUDENT_TBL(NAME, AGE, GRADE, ADDRESS) VALUES('일용자', 21, 1, '서울시 중구');

-- 최종 저장
-- F11 또는 commit 아이콘 또는 COMMIT; 실행
COMMIT;

-- 롤백
-- F12 또는 rollback 아이콘 또는 ROLLBACK; 실행
-- 저장 전에 ROLLBACK을 하면 추가한 내용 없어짐
-- COMMINT한 시점으로 되돌아감
ROLLBACK;