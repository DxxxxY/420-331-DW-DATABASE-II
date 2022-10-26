DROP TABLE SEASON CASCADE CONSTRAINTS;
DROP TABLE TERM CASCADE CONSTRAINTS;
DROP TABLE EDUCATION CASCADE CONSTRAINTS;
DROP TABLE COURSE CASCADE CONSTRAINTS;

DROP TYPE COURSE_TYPE;
DROP TYPE TERM_TYPE;
DROP TYPE EDUCATION_TYPE;
DROP TYPE SEASON_TYPE;

CREATE TABLE SEASON(
    season_id NUMBER(1) PRIMARY KEY,
    season_name VARCHAR2(20) NOT NULL
);

CREATE TABLE TERM(
    term_id NUMBER(1) PRIMARY KEY,
    season_id NUMBER(1) REFERENCES SEASON(season_id) NOT NULL
);

CREATE TABLE EDUCATION(
    education_id NUMBER(1) PRIMARY KEY,
    education_name VARCHAR2(20) NOT NULL
);

CREATE TABLE COURSE(
    id VARCHAR2(11) PRIMARY KEY,
    term_id NUMBER(1) REFERENCES TERM(term_id) NOT NULL,
    education_id NUMBER(1) REFERENCES EDUCATION(education_id) NOT NULL,
    name VARCHAR2(30) NOT NULL,
    description VARCHAR2(500) NOT NULL,
    class NUMBER(1) NOT NULL,
    lecture NUMBER(1) NOT NULL,
    homework NUMBER(1) NOT NULL
);

CREATE OR REPLACE TYPE COURSE_TYPE AS OBJECT (
    id VARCHAR2(11),
    term TERM_TYPE,
    education EDUCATION_TYPE,
    name VARCHAR2(30),
    description VARCHAR2(500),
    class NUMBER(1),
    lecture NUMBER(1),
    homework NUMBER(1)
);

CREATE OR REPLACE TYPE TERM_TYPE AS OBJECT (
    term_id NUMBER(1),
    season SEASON_TYPE
);

CREATE OR REPLACE TYPE EDUCATION_TYPE AS OBJECT (
    education_id NUMBER(1),
    education_name VARCHAR2(20)
);

CREATE OR REPLACE TYPE SEASON_TYPE AS OBJECT (
    season_id NUMBER(1),
    season_name VARCHAR2(20)
);

CREATE OR REPLACE PROCEDURE ADD_COURSE(COURSE_IN IN COURSE_TYPE) AS
BEGIN
    INSERT INTO COURSE VALUES(COURSE_IN.id, COURSE_IN.term.term_id, COURSE_IN.education.education_id, COURSE_IN.name, COURSE_IN.description, COURSE_IN.class, COURSE_IN.lecture, COURSE_IN.homework);
END;

CREATE OR REPLACE PROCEDURE ADD_TERM(TERM_IN IN TERM_TYPE) AS
BEGIN
    INSERT INTO TERM VALUES(TERM_IN.term_id, TERM_IN.season.season_id);
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        UPDATE TERM SET season_id = TERM_IN.season.season_id WHERE term_id = TERM_IN.term_id;
END;

CREATE OR REPLACE PROCEDURE ADD_EDUCATION(EDUCATION_IN IN EDUCATION_TYPE) AS
BEGIN
    INSERT INTO EDUCATION VALUES(EDUCATION_IN.education_id, EDUCATION_IN.education_name);
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        UPDATE EDUCATION SET education_name = EDUCATION_IN.education_name WHERE education_id = EDUCATION_IN.education_id;
END;

CREATE OR REPLACE PROCEDURE ADD_SEASON(SEASON_IN IN SEASON_TYPE) AS
BEGIN
    INSERT INTO SEASON VALUES(SEASON_IN.season_id, SEASON_IN.season_name);
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        UPDATE SEASON SET season_name = SEASON_IN.season_name WHERE season_id = SEASON_IN.season_id;
END;

COMMIT;