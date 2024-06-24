-- 06/13 --
SHOW USER;

-- < 테이블 생성 >
CREATE TABLE EMPLOYEE(
    NAME VARCHAR2(20),
    T_CODE VARCHAR2(10),
    D_CODE VARCHAR2(10),
    AGE NUMBER
);
-- 1. 컬럼의 데이터 타입없이 테이블 생성 -> 오류 발생 >> 데이터 타입 작성
-- 2. 권한 없이 테이블 생성 -> 오류 발생 >> System_계정에서 RESOURCE 권한 부여해줌
-- 3. 접속 해제 후 재접속 >> 기존 워크시트에 접속됨
-- 4. 명령어 재실행 >> 정상 동작됨

-- 조회하기
SELECT * FROM EMPLOYEE;

-- < 데이터 추가 : INSERT INTO 테이블명() VALUES (데이터); >
INSERT INTO EMPLOYEE(NAME, T_CODE, D_CODE, AGE)
VALUES('일용자', 'T1', 'D1', 33);
INSERT INTO EMPLOYEE(NAME, T_CODE, D_CODE, AGE)
VALUES('이용자', 'T2', 'D2', 44);
INSERT INTO EMPLOYEE(NAME, T_CODE, D_CODE, AGE)
VALUES('삼용자', 'T1', 'D3', 32);

-- < 테이블 삭제 : DROP TABLE 데이터명 >
DROP TABLE EMPLOYEE;

-- < 테이블의 데이터 전체 삭제 : DELETE FROM 테이블명 >
DELETE FROM EMPLOYEE;

-- < 테이블의 데이터 중 선택해서 삭제 : DELETE FROM 테이블명 WHERE 데이터 ~ >
DELETE FROM EMPLOYEE WHERE NAME = '일용자';

-- < 테이블의 데이터 값 수정하기 : UPDATE 테이블명 SET 데이터 WHERE 데이터  >
-- 모든 데이터의 T_CODE가 'T3'로 변경됨
UPDATE EMPLOYEE SET T_CODE = 'T3';
-- NAME이 '일용자'인 T_CODE가 'T3'로 변경됨
UPDATE EMPLOYEE SET T_CODE = 'T3' WHERE NAME = '일용자';

SELECT NAME, T_CODE, D_CODE, AGE FROM EMPLOYEE WHERE NAME = '일용자';

SELECT * FROM EMPLOYEE;

------------------------------------------------------------------------------------------------------
-- 예제 1
-- 테이블명 : STUDENT_TBL
-- 이름, 나이, 학년, 주소 저장
-- 일용자 21, 1, 서울시 중구 저장
-- 일용자 -> 이용자
-- 데이터를 삭제하는 쿼리문 작성 후 삭제된 것 확인
-- 테이블을 삭제하는 쿼리문 작성 후 삭제된 것 확인

-- 테이블 생성
CREATE TABLE STUDENT_TBL(NAME VARCHAR2(20), AGE NUMBER, GRADE VARCHAR2(5), ADDRESS VARCHAR2(30));
-- 조회하기
SELECT * FROM STUDENT_TBL;
-- 데이터 추가
INSERT INTO STUDENT_TBL(NAME, AGE, GRADE, ADDRESS) VALUES('일용자', 21, 1, '서울시 중구');
-- 데이터 변경
UPDATE STUDENT_TBL SET NAME = '이용자' WHERE NAME = '일용자';
-- 데이터 삭제
DELETE FROM STUDENT_TBL;
-- 테이블 삭제
DROP TABLE STUDENT_TBL;









