DROP TABLE Login;

create table Login( 
    username varchar(10), 
    password number(10) 
); 

insert into Login values('raju',12345); 
insert into Login values('esha',54321); 

------------------------------- LOG IN --------------------------------------- 


PROMPT You need to login first.. 
PROMPT Enter your userid and password.. 

SET SERVEROUTPUT ON 
DECLARE 
    row NUMBER(2); 
   u Login.username%TYPE; 
   p Login.password%TYPE; 

BEGIN 
    u := '&username'; 
    p := &password; 

    select count(*) into row from Login 
    where Login.username=u and Login.password=p; 
    if row = 1 then 
      dbms_output.put_line ('Log in successful'); 
    else 
      dbms_output.put_line ('Username or password did not match'); 
    end if; 
    EXCEPTION 
      WHEN others THEN 
        NULL; 
END; 
/ 

 
/*--------------------------Drop all the tables--------------------------------*/
DROP TABLE Teacher_Student CASCADE CONSTRAINTS;
DROP TABLE TEACHER CASCADE CONSTRAINTS;
DROP TABLE RESULT CASCADE CONSTRAINTS;
DROP TABLE SUBJECT_NUMBER CASCADE CONSTRAINTS;
DROP TABLE STUDENT CASCADE CONSTRAINTS;

/*-------------------------Create all the tables-------------------------------*/

CREATE TABLE student (
	Student_id    Number(4) NOT NULL,
	Student_name  varchar(30),
	Address	      varchar(30),
	Father_Name   varchar(30),
	Gender        varchar(8),
	Class         varchar(5),
	PRIMARY KEY(Student_id)
);

create table SUBJECT_NUMBER(
    Registration_id    Number(4) NOT NULL,
    Phy number(4,2)  CHECK(Phy>0 AND Phy <100),
    Chem number(4,2),
    Math number(4,2),
    Eng number(4,2),
    Ban number(4,2),
	PRIMARY KEY ( Registration_id),
    FOREIGN KEY (Registration_id) REFERENCES student(Student_id) ON DELETE CASCADE
);

create table RESULT (
    Exam_id    Number(4) NOT NULL,
    GPA        Number(3,2),
	GPA_LETTER char(15),
	PRIMARY KEY (Exam_id),
    FOREIGN KEY (Exam_id ) REFERENCES SUBJECT_NUMBER(Registration_id) ON DELETE CASCADE
);

create table TEACHER (
   Teacher_id    Number(4) NOT NULL,
   Teacher_name  varchar(30),
   Address	     varchar(30),
   Subject       varchar(20),
   Class         varchar(5),
  PRIMARY KEY (Teacher_id)
);

create table Teacher_Student(
   Teacher_id    Number(4) NOT NULL,
   Student_id    Number(4) NOT NULL
);



/*---------------------------------FOREIGN KEY  OUTSIDE TABLE---------------------------------------*/
ALTER TABLE Teacher_Student ADD CONSTRAINT FK_Teacher_ID FOREIGN KEY(Teacher_id) REFERENCES TEACHER(Teacher_id) ON DELETE CASCADE;
ALTER TABLE Teacher_Student ADD CONSTRAINT FK_Student_ID FOREIGN KEY(Student_id) REFERENCES student(Student_id) ON DELETE CASCADE;
/*--------------------------------------------------------------------------------------------------*/


/*---------------------------------DROP CONSTRAINT-----------------------------------*/
ALTER TABLE Teacher_Student DROP CONSTRAINT FK_Teacher_ID;
ALTER TABLE Teacher_Student ADD CONSTRAINT FK_Teacher_ID FOREIGN KEY(Teacher_id) REFERENCES TEACHER(Teacher_id) ON DELETE CASCADE;
/*----------------------------------------------------------------------------------*/




/*---------------------------------DESCRIBE TABLES-----------------------------------*/
DESCRIBE STUDENT;
DESCRIBE SUBJECT_NUMBER ;
DESCRIBE RESULT;
DESCRIBE TEACHER;
DESCRIBE Teacher_Student;
/*------------------------------------------------------------------------------------*/


/*---------------------------------ADD column AND Modify-----------------------------------*/
 ALTER TABLE Student
	ADD AGE NUMBER(2) CHECK (AGE > 0 AND AGE < 100);
	
ALTER TABLE Student
	MODIFY AGE NUMBER(3);
/*------------------------------------------------------------------------------------*/



/*---------------------------------Rename----------------------------------*/	
ALTER TABLE Student
	RENAME COLUMN AGE to USER_AGE;
DESCRIBE Student;
/*------------------------------------------------------------------------------------*/



/*--------------------------------------------------------PL/SQL----------------------------------------------------*/


/*---------------------------Function For Sub_GPA--------------------------------*/


CREATE OR REPLACE FUNCTION Sub_GPA(s NUMBER) RETURN NUMBER IS
    ss NUMBER;
 BEGIN
  if s>=80 then
    ss:=5.00;
  ELSIF s<80 AND s>=70 then
    ss:=4.00;
  ELSIF s<70 AND s>=60 then
    ss:=3.50;
  ELSIF s<60 AND s>=50 then
    ss:=3.25;
  ELSIF s<50 AND s>=40 then
    ss:=3.00;
  ELSE 
   ss:=0.00; 
  END IF;
   RETURN ss;
END Sub_GPA;
/



/*---------------------------Function For Sub_GPA_Letter--------------------------------*/
CREATE OR REPLACE FUNCTION Sub_GPA_Letter(s NUMBER) RETURN char IS
    ss char(15);
 BEGIN
  if s>=5.00 then
    ss:='A+';
  ELSIF s>=4.00 then
    ss:='A';
  ELSIF s>=3.50 then
    ss:='A-';
  ELSIF s>=3.25 then
    ss:='B';
  ELSIF s>=3.00 then
    ss:='C';
  ELSE 
   ss:='F'; 
  END IF;
   RETURN ss;
END Sub_GPA_Letter;
/




/*---------------------------Function For GPA_calculate--------------------------------*/

CREATE OR REPLACE FUNCTION GPA_calculate(s1 number,s2 number,s3 number,s4 number,s5 number)RETURN number IS
   GPA number;
 BEGIN
  
    GPA:=((NVL(s1,0)+NVL(s2,0)+NVL(s3,0)+NVL(s4,0)+NVL(s5,0))/5);
 RETURN GPA;
 
END GPA_calculate;
/

/*--------------------------------------------------------END Of FUNCTION----------------------------------------------------*/



/*--------------------------- Procedure  --------------------------------*/

/*--------------------------- Procedure to Show Total Student  --------------------------------*/
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE getNoOfStudent IS  
  total number(3) := 0; 
BEGIN
  
    SELECT count(*) into total 
    FROM STUDENT; 
	DBMS_OUTPUT.PUT_LINE('-----------------------------');
    DBMS_OUTPUT.PUT_LINE('No fo student is : '||total);
END;
/	

/*--------------------------- Procedure to Show Teacher Details  --------------------------------*/
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE print_teacher(t_id TEACHER.Teacher_id%TYPE) IS 
   t_name TEACHER.Teacher_name%type;
   t_A TEACHER.Address%type;
   t_s TEACHER.Subject%type;
   t_c TEACHER.Class%type;
BEGIN
    SELECT Teacher_name, Address, Subject,class INTO t_name,t_A,t_s,t_c
    FROM TEACHER
    WHERE Teacher_id =t_id;
	
    DBMS_OUTPUT.PUT_LINE( t_id||' '||' '||t_name||' '||t_A||' '||' '|| t_s ||' '||' '||' '||' '|| t_c);
END;
/
SHOW ERRORS;


/*--------------------------- Procedure for Update Subject  --------------------------------*/
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE Update_sub IS 
BEGIN

 UPDATE SUBJECT_NUMBER set Phy=Sub_GPA(Phy),Chem=Sub_GPA(Chem),Math=Sub_GPA(Math),Ban=Sub_GPA(Ban),Eng=Sub_GPA(Eng);

END;
/
SHOW ERRORS;

/*--------------------------------------------------------END Of Procedure ----------------------------------------------------*/



/*---------------insert teacher table--------------------*/

insert into TEACHER(Teacher_id, Teacher_name,Address,Subject,Class)
	values(101, 'Md Aziz','Chittagong','Math','10');
insert into TEACHER(Teacher_id, Teacher_name,Address,Subject,Class)
	values(102, 'Md Liton','Chittagong','Bangla','10');
insert into TEACHER(Teacher_id, Teacher_name,Address,Subject,Class)
	values(103, 'Md Shahin','Dhaka','English','9');
insert into TEACHER(Teacher_id, Teacher_name,Address,Subject,Class)
	values(104, 'Md Pronov','Chittagong','Physis','10');	
insert into TEACHER(Teacher_id, Teacher_name,Address,Subject,Class)
	values(105, 'Md Nazim','Khulna','Chemistry','9');

/*-------------------------------------End --------------------------------------------------*/


/*-----------------------insert student table------------------------------------*/

insert into student(Student_id,Student_name,Address,Father_Name,Gender,Class,USER_AGE)
	values(101, 'Taslim Uddin','Chittagong','Md shahjahan','Male','10','16');
insert into student(Student_id,Student_name,Address,Father_Name,Gender,Class,USER_AGE)
	values(102, 'Dilruba khanam','Chittagong','Md Selim','Female','10','16');
insert into student(Student_id,Student_name,Address,Father_Name,Gender,Class,USER_AGE)
	values(103, 'Tanvir Uddin','Dhaka','Md shahjahan','Male','10','17');
insert into student(Student_id,Student_name,Address,Father_Name,Gender,Class,USER_AGE)
	values(104, 'Taskina Jahan','Khulna','Md Manik','Female','10','15');
insert into student(Student_id,Student_name,Address,Father_Name,Gender,Class,USER_AGE)
	values(105, 'Tanzim Uddin','Chittagong','Md shahjahan','Male','10','16');	
/*-------------------------------------End --------------------------------------------------*/



/*-----Show all Student (General SELECT)---------*/
  SELECT * from student;


/*------------------Show all student (WHERE CONDITION)-------- */
SELECT s.Student_name,s.Father_Name,s.class from student s where address='Chittagong';

  


/*------------------------------------------------CURSOR----------------------------------*/
/*-------------------- use cursor to show studebt details----------------------------*/
SET SERVEROUTPUT ON;
DECLARE
     CURSOR student_cur IS SELECT Student_name,Father_Name,Address,Gender FROM student;
     student_row student_cur%ROWTYPE;
	 NO_OF_student NUMBER;
BEGIN
SELECT COUNT(student_id) INTO  NO_OF_student FROM student;
DBMS_OUTPUT.PUT_LINE('    S_name      S_Father_N     Address    Gender ');
DBMS_OUTPUT.PUT_LINE('--------------------------------------------------');
OPEN student_cur;
      LOOP
        FETCH student_cur INTO student_row;
	DBMS_OUTPUT.PUT_LINE(student_row.Student_name ||' '||' '||student_row.Father_Name||' '||' '||' '|| student_row.Address||' '||' '||' '||student_row.Gender);
        EXIT WHEN student_cur%ROWCOUNT > NO_OF_student-1;
      END LOOP;
CLOSE student_cur;  

END;
/
 

/*-------------------------------------end cursor------------------------------------------*/




/*----------------------------------------Loop------------------------------------------*/

/*------------------------------call procedure to show table details by using loop-----------------*/
     /*--------------while loop-----------------*/
SET SERVEROUTPUT ON
DECLARE
   counter  NUMBER(3) := 101; 
BEGIN
DBMS_OUTPUT.PUT_LINE('id Teacher name Address  take subject Class');
DBMS_OUTPUT.PUT_LINE('--------------------------------------------');
   WHILE counter <=105
   LOOP
     print_teacher(counter);
      counter := counter + 1 ;

   END LOOP;

   EXCEPTION
      WHEN others THEN
         DBMS_OUTPUT.PUT_LINE (SQLERRM);
END;
/
  /*-------end---------*/


		
/*-------------------------------------------------------TRIGGER--------------------------------------------------------*/

CREATE OR REPLACE TRIGGER TR_gpa BEFORE INSERT OR UPDATE ON Result
FOR EACH ROW
DECLARE 
s1 number;
s2 number;
s3 number;
s4 number;
s5 number;
TEMP_Registration_id SUBJECT_NUMBER.Registration_id%TYPE;
G_GPA number;
BEGIN
 
 SELECT Registration_id, Phy,Chem,Math,Eng,Ban INTO TEMP_Registration_id,s1,s2,s3,s4,s5 FROM SUBJECT_NUMBER where Registration_id=:new.Exam_id;

   s1:=Sub_GPA(s1);
   s2:=Sub_GPA(s2);
   s3:=Sub_GPA(s3);
   s4:=Sub_GPA(s4);
   s5:=Sub_GPA(s5);
   G_GPA:=GPA_calculate(s1,s2,s3,s4,s5);
   :New.GPA:=G_GPA;
   :New.GPA_LETTER:=Sub_GPA_Letter(G_GPA);
  
END TR_gpa;
/

/*----------------------------delete operation-----------------------------------------*/
  
  DELETE FROM subject_number;

/*--------------------------------insert SUBJECT_NUMBER ----------------------------*/
insert into SUBJECT_NUMBER(Registration_id,Phy,Chem,Math,Ban,Eng) 
     values(101,80,90,85,95,83);
insert into SUBJECT_NUMBER(Registration_id,Phy,Chem,Math,Ban,Eng) 
     values(102,70,90,85,65,83);
insert into SUBJECT_NUMBER(Registration_id,Phy,Chem,Math,Ban,Eng) 
     values(103,70,90,90,65,83);
insert into SUBJECT_NUMBER(Registration_id,Phy,Chem,Math,Ban,Eng) 
     values(104,70,90,85,80,83);
insert into SUBJECT_NUMBER(Registration_id,Phy,Chem,Math,Ban,Eng) 
     values(105,70,90,85,70,83);	 
	 
/*---------------------------------end-------------------------------------------*/	

/*----------------------------delete operation-----------------------------------------*/
  
  DELETE FROM result;
  
/*--------------------------------insert SUBJECT_NUMBER ----------------------------*/

insert into RESULT(Exam_id,GPA,GPA_LETTER) 
    values(101,null,null);
insert into RESULT(Exam_id,GPA,GPA_LETTER) 
    values(102,null,null);
insert into RESULT(Exam_id,GPA,GPA_LETTER) 
    values(103,null,null);
insert into RESULT(Exam_id,GPA,GPA_LETTER) 
    values(104,null,null);
insert into RESULT(Exam_id,GPA,GPA_LETTER) 
    values(105,null,null);	
	
/*------------------call Update Procedure ---------------------------------*/

BEGIN
  Update_sub;
END;
/

/*------------------call  Procedure T0 show number of student---------------------------------*/
BEGIN
 getNoOfStudent;
END;
/


/*------------------join operation-----------------------------------------*/

Select St.student_id,S.Phy,S.chem,S.Math,S.Ban,S.Eng,R.GPA,R.GPA_LETTER from 
Student St join SUBJECT_NUMBER S on St.student_id=S.Registration_id 
join RESULT R on R.Exam_id=S.Registration_id order by GPA desc;


/*----------------------ROllBack-------------------------------------*/
 delete from student;
 select * from student;
 
 /*------ROLLBACK-----*/
 ROLLBACK;
 select * from  student;