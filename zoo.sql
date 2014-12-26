/**********
 * tables * 
 **********/
     
CREATE TABLE shift
    ( shift_id      NUMBER(8)
    , shift_name    VARCHAR2(50)
        CONSTRAINT    shift_shift_name_nn NOT NULL
    , CONSTRAINT    shift_shift_id_pk
                      PRIMARY KEY (shift_id)
    );

CREATE TABLE zone
    ( zone_id       NUMBER(8)
    , zone_name     VARCHAR2(50)
        CONSTRAINT    zone_zone_name_nn NOT NULL
    , CONSTRAINT    zone_zone_id_pk
                      PRIMARY KEY (zone_id)
    );

CREATE TABLE resp_type
    ( resp_type_id       NUMBER(2)
    , resp_type_name     VARCHAR2(50)
        CONSTRAINT    resp_type_resp_type_name_nn NOT NULL
    , CONSTRAINT    resp_type_resp_type_id_pk 
                      PRIMARY KEY (resp_type_id)
    );

CREATE TABLE employee
    ( emp_id        NUMBER(8)
    , first_name    VARCHAR2(50)
        CONSTRAINT    emp_first_name_nn NOT NULL
    , last_name     VARCHAR2(50)
        CONSTRAINT    emp_last_name_nn NOT NULL
    , emp_type      NUMBER(2)
        CONSTRAINT    emp_emp_type_nn NOT NULL
    , manager_id    NUMBER(8)
    , CONSTRAINT    emp_emp_id_pk 
                      PRIMARY KEY (emp_id)
    , CONSTRAINT    emp_emp_type_fk
                      FOREIGN KEY (emp_type)
                      REFERENCES resp_type(resp_type_id)
    , CONSTRAINT    emp_manager_id_fk
                      FOREIGN KEY (manager_id)
                      REFERENCES employee(emp_id)
    );

CREATE TABLE emp_phone
    ( emp_id        NUMBER(8)
    , phone_no      VARCHAR2(16)
    , CONSTRAINT    emp_phone_pk 
                      PRIMARY KEY (emp_id, phone_no)
    , CONSTRAINT    emp_phone_emp_id_fk
                      FOREIGN KEY (emp_id)
                      REFERENCES employee(emp_id)
    );

CREATE TABLE supply
    ( sup_id        NUMBER(8)
    , sup_name      VARCHAR2(50)
        CONSTRAINT    sup_sup_name_nn NOT NULL
    , sup_unit      VARCHAR2(10)
        CONSTRAINT    sup_sup_unit_nn NOT NULL
    , total_amount  NUMBER(15,2)
        CONSTRAINT    sup_total_amount_nn NOT NULL
    , sup_type      NUMBER(8)
        CONSTRAINT    sup_sup_type_nn NOT NULL
    , admin_route   VARCHAR2(2)
    , CONSTRAINT    sup_sup_unit_chk
                      CHECK (sup_unit IN('lb','mg','kg','ml'))
    , CONSTRAINT    sup_sup_total_amount_min
                      CHECK (total_amount >= 0)
    , CONSTRAINT    sup_admin_route_chk
                      CHECK (admin_route IN('iv','o'))
    , CONSTRAINT    sup_sup_id_pk
                      PRIMARY KEY (sup_id)
    , CONSTRAINT    sup_sup_type_fk
                      FOREIGN KEY (sup_type)
                      REFERENCES resp_type(resp_type_id)
    );

CREATE TABLE anim_category
    ( cat_id        NUMBER(8)
    , cat_name      VARCHAR2(50)
        CONSTRAINT    anim_cat_cat_name_nn NOT NULL
    , zone_id       NUMBER(8)
        CONSTRAINT    anim_cat_zone_id_nn NOT NULL
    , CONSTRAINT    anim_cat_cat_id_pk
                      PRIMARY KEY (cat_id)
    , CONSTRAINT    anim_cat_zone_id_fk 
                      FOREIGN KEY (zone_id)
                      REFERENCES zone(zone_id)
    );

CREATE TABLE animal
    ( anim_id       NUMBER(8)
    , anim_name     VARCHAR2(50)
        CONSTRAINT   anim_anim_name_nn NOT NULL
    , cat_id        NUMBER(8)
        CONSTRAINT   anim_cat_id_nn NOT NULL
    , gender        CHAR(1)
    , anim_dob      DATE
        CONSTRAINT   anim_dob_nn NOT NULL
    , CONSTRAINT    anim_gender_chk
                      CHECK (gender IN('f','m'))
    , CONSTRAINT    anim_anim_id_pk
                      PRIMARY KEY (anim_id)
    , CONSTRAINT    anim_cat_id_fk 
                      FOREIGN KEY (cat_id)
                      REFERENCES anim_category(cat_id)  
    );

CREATE TABLE anim_need
    ( need_id       NUMBER(8)
    , anim_id       NUMBER(8)
        CONSTRAINT    anim_need_anim_id_nn NOT NULL
    , sup_id        NUMBER(8)
        CONSTRAINT    anim_need_sup_id_nn NOT NULL
    , sup_amount    NUMBER(15,2)
        CONSTRAINT    anim_need_sup_amount_nn NOT NULL
    , shift_id      NUMBER(8)
        CONSTRAINT   anim_need_shift_id_nn NOT NULL
    , anim_need_note VARCHAR2(4000)
    , CONSTRAINT    anim_need_sup_amount_min
                      CHECK (sup_amount > 0)
    , CONSTRAINT    anim_need_need_id_pk
                      PRIMARY KEY (need_id)
    , CONSTRAINT    anim_need_sup_id_fk 
                      FOREIGN KEY (sup_id)
                      REFERENCES supply(sup_id)
    , CONSTRAINT    anim_need_anim_id_fk 
                      FOREIGN KEY (anim_id) 
                      REFERENCES animal(anim_id)
    , CONSTRAINT    anim_need_shift_id_fk 
                      FOREIGN KEY (shift_id) 
                      REFERENCES shift(shift_id)
    );

CREATE TABLE medical_ticket
    ( med_tick_id    NUMBER(8)
    , anim_id        NUMBER(8)
        CONSTRAINT     med_tick_anim_id_nn NOT NULL
    , open_emp       NUMBER(8)
        CONSTRAINT     med_tick_open_emp_nn NOT NULL
    , close_emp      NUMBER(8)
    , open_date      DATE
        CONSTRAINT     med_tick_open_date_nn NOT NULL
    , close_date     DATE
    , open_note      VARCHAR2(4000)
    , close_note     VARCHAR2(4000)
    , CONSTRAINT     med_tick_close_date_min
                       CHECK (close_date > open_date)
    , CONSTRAINT     med_tick_med_tick_id_pk
                       PRIMARY KEY (med_tick_id)
    , CONSTRAINT     med_tick_anim_id_fk
                       FOREIGN KEY (anim_id)
                       REFERENCES animal(anim_id)
    , CONSTRAINT     med_tick_open_emp_fk
                       FOREIGN KEY (open_emp)
                       REFERENCES employee(emp_id)
    , CONSTRAINT     med_tick_close_emp_fk
                       FOREIGN KEY (close_emp)
                       REFERENCES employee(emp_id)
    );
   
CREATE TABLE responsibility
    ( resp_id       NUMBER(8)
    , emp_id        NUMBER(8)
        CONSTRAINT    resp_emp_id_nn NOT NULL
    , shift_id      NUMBER(8)
        CONSTRAINT    resp_shift_id_nn NOT NULL
    , zone_id       NUMBER(8)
        CONSTRAINT    resp_zone_id_nn NOT NULL
    , resp_type     NUMBER(8)
       CONSTRAINT     resp_resp_type_nn NOT NULL
    , CONSTRAINT    resp_resp_id_pk
                      PRIMARY KEY (resp_id)
    , CONSTRAINT    resp_emp_id_fk
                      FOREIGN KEY (emp_id)
                      REFERENCES employee(emp_id)
    , CONSTRAINT    resp_shift_id_fk
                      FOREIGN KEY (shift_id)
                      REFERENCES shift(shift_id)
    , CONSTRAINT    resp_zone_id_fk
                      FOREIGN KEY (zone_id)
                      REFERENCES zone(zone_id)
    , CONSTRAINT    resp_resp_type_fk
                      FOREIGN KEY (resp_type)
                      REFERENCES resp_type(resp_type_id)
    , CONSTRAINT    resp_shift_zone_type_uk
                      UNIQUE (shift_id, zone_id, resp_type)
    );
    
 /*************
  * sequences * 
  *************/
     
CREATE SEQUENCE shift_seq
START WITH 1
INCREMENT BY 1
NOMAXVALUE;

CREATE SEQUENCE zone_seq
START WITH 1
INCREMENT BY 1
NOMAXVALUE;

CREATE SEQUENCE resp_type_seq
START WITH 1
INCREMENT BY 1
NOMAXVALUE;

CREATE SEQUENCE emp_seq
START WITH 1
INCREMENT BY 1
NOMAXVALUE;

CREATE SEQUENCE sup_seq
START WITH 1
INCREMENT BY 1
NOMAXVALUE;


CREATE SEQUENCE anim_cat_seq
START WITH 1
INCREMENT BY 1
NOMAXVALUE;

CREATE SEQUENCE anim_seq
START WITH 1
INCREMENT BY 1
NOMAXVALUE;

CREATE SEQUENCE anim_need_seq
START WITH 1
INCREMENT BY 1
NOMAXVALUE;

CREATE SEQUENCE med_tick_seq
START WITH 1
INCREMENT BY 1
NOMAXVALUE;

CREATE SEQUENCE resp_seq
START WITH 1
INCREMENT BY 1
NOMAXVALUE;

 /************
  * triggers * 
  ************/
  
CREATE OR REPLACE TRIGGER shift_before_insert
    BEFORE INSERT 
        ON shift
        FOR EACH ROW
    BEGIN
        :NEW.shift_id := shift_seq.nextval;
    END;
/

CREATE OR REPLACE TRIGGER zone_before_insert
    BEFORE INSERT 
        ON zone
        FOR EACH ROW
    BEGIN  
        :NEW.zone_id := zone_seq.nextval;       
    END;
/

CREATE OR REPLACE TRIGGER resp_type_before_insert
    BEFORE INSERT 
        ON resp_type
        FOR EACH ROW
    BEGIN  
        :NEW.resp_type_id := resp_type_seq.nextval; 
    END;
/

CREATE OR REPLACE TRIGGER emp_before_insert
    BEFORE INSERT 
        ON employee
        FOR EACH ROW
    BEGIN
        :NEW.emp_id := emp_seq.nextval;
    END;
/

CREATE OR REPLACE TRIGGER sup_before_insert
    BEFORE INSERT 
        ON supply
        FOR EACH ROW
    BEGIN
        :NEW.sup_id := sup_seq.nextval;
    END;
/

CREATE OR REPLACE TRIGGER anim_cat_before_insert
    BEFORE INSERT 
        ON anim_category
        FOR EACH ROW
    BEGIN
        :NEW.cat_id := anim_cat_seq.nextval;
    END;
/

CREATE OR REPLACE TRIGGER anim_before_insert
    BEFORE INSERT 
        ON animal
        FOR EACH ROW
    BEGIN
        :NEW.anim_id := anim_seq.nextval;
    END;
/

CREATE OR REPLACE TRIGGER anim_need_before_insert
    BEFORE INSERT 
        ON anim_need
        FOR EACH ROW
    BEGIN  
        :NEW.need_id := anim_need_seq.nextval;      
    END;
/

CREATE OR REPLACE TRIGGER med_tick_before_insert
    BEFORE INSERT 
        ON medical_ticket
        FOR EACH ROW
    BEGIN
        :NEW.med_tick_id := med_tick_seq.nextval;
    END;
/

CREATE OR REPLACE TRIGGER resp_before_insert
    BEFORE INSERT 
        ON responsibility
        FOR EACH ROW
    BEGIN 
        :NEW.resp_id := resp_seq.nextval;
    END;
/

-- Add feeding needs when an animal is added based on animal category
CREATE OR REPLACE TRIGGER anim_after_insert
    AFTER INSERT
        ON animal
        FOR EACH ROW

    BEGIN
        CASE :NEW.cat_id
-- lion
            WHEN 1 THEN
                INSERT INTO anim_need (anim_id, sup_id, sup_amount, shift_id)
                VALUES (:NEW.anim_id, 1, 10, 1);

                INSERT INTO anim_need (anim_id, sup_id, sup_amount, shift_id)
                VALUES (:NEW.anim_id, 1, 10, 3);
-- tiger
            WHEN 2 THEN
                INSERT INTO anim_need (anim_id, sup_id, sup_amount, shift_id)
                VALUES (:NEW.anim_id, 1, 10, 1);
            
                INSERT INTO anim_need (anim_id, sup_id, sup_amount, shift_id)
                VALUES (:NEW.anim_id, 1, 10, 3);  
-- bear 
            WHEN 3 THEN
                INSERT INTO anim_need (anim_id, sup_id, sup_amount, shift_id)
                VALUES (:NEW.anim_id, 1, 15, 1);
            
                INSERT INTO anim_need (anim_id, sup_id, sup_amount, shift_id)
                VALUES (:NEW.anim_id, 1, 15, 2);
            
                INSERT INTO anim_need (anim_id, sup_id, sup_amount, shift_id)
                VALUES (:NEW.anim_id, 1, 15, 3); 
-- monkey 
            WHEN 4 THEN
                INSERT INTO anim_need (anim_id, sup_id, sup_amount, shift_id)
                VALUES (:NEW.anim_id, 2, 3, 1);
            
                INSERT INTO anim_need (anim_id, sup_id, sup_amount, shift_id)
                VALUES (:NEW.anim_id, 2, 3, 2);
            
                INSERT INTO anim_need (anim_id, sup_id, sup_amount, shift_id)
                VALUES (:NEW.anim_id, 2, 3, 3);
-- zebra 
            WHEN 5 THEN
                INSERT INTO anim_need (anim_id, sup_id, sup_amount, shift_id)
                VALUES (:NEW.anim_id, 2, 6, 1);
            
                INSERT INTO anim_need (anim_id, sup_id, sup_amount, shift_id)
                VALUES (:NEW.anim_id, 2, 6, 2);
            
                INSERT INTO anim_need (anim_id, sup_id, sup_amount, shift_id)
                VALUES (:NEW.anim_id, 2, 6, 3);   
-- elephant
            WHEN 6 THEN
                INSERT INTO anim_need (anim_id, sup_id, sup_amount, shift_id)
                VALUES (:NEW.anim_id, 2, 10, 1);

                INSERT INTO anim_need (anim_id, sup_id, sup_amount, shift_id) 
                VALUES (:NEW.anim_id, 1, 25, 1);
            
                INSERT INTO anim_need (anim_id, sup_id, sup_amount, shift_id)               
                VALUES (:NEW.anim_id, 2, 10, 3);

                INSERT INTO anim_need (anim_id, sup_id, sup_amount, shift_id) 
                VALUES (:NEW.anim_id, 1, 25, 3);
-- gorilla
            WHEN 7 THEN
                INSERT INTO anim_need (anim_id, sup_id, sup_amount, shift_id) 
                VALUES (:NEW.anim_id, 2, 10, 1);

                INSERT INTO anim_need (anim_id, sup_id, sup_amount, shift_id) 
                VALUES (:NEW.anim_id, 2, 10, 2);

                INSERT INTO anim_need (anim_id, sup_id, sup_amount, shift_id)
                VALUES (:NEW.anim_id, 2, 10, 3);            
        END CASE;
    END;
/

-- Prevent a medical ticket from being closed by a non-medical employee
CREATE OR REPLACE TRIGGER med_tick_after_insert 
    AFTER INSERT OR UPDATE OF close_emp
        ON medical_ticket
        FOR EACH ROW
    DECLARE 
      emp_type_check employee.emp_type%TYPE;
    BEGIN
        IF :NEW.close_emp IS NOT NULL THEN
            SELECT emp_type 
            INTO emp_type_check 
            FROM employee 
            WHERE emp_id = :NEW.close_emp; 
    
            IF emp_type_check <> 2 THEN
                RAISE_APPLICATION_ERROR(-20001, 'must be medical employee');
            END IF;
        END IF;
    END;
/

-- Prevent non-medical employees from having medical responsibilities
CREATE OR REPLACE TRIGGER resp_after_insert 
    AFTER INSERT OR UPDATE OF resp_type
        ON responsibility
        FOR EACH ROW
    DECLARE 
        emp_type_check employee.emp_type%TYPE;
    BEGIN
        IF :NEW.resp_type = 2 THEN
            SELECT emp_type 
            INTO emp_type_check 
            FROM employee 
            WHERE emp_id = :NEW.emp_id; 
    
            IF emp_type_check <> 2 THEN
                RAISE_APPLICATION_ERROR(-20001, 'must be medical employee');
            END IF;
        END IF;
    END;
/
 /*********
  * views * 
  *********/
     
-- List employee phone numbers
CREATE VIEW emp_phone_v
AS
    SELECT E.last_name
         , E.first_name
         , P.phone_no
    FROM emp_phone P 
    INNER JOIN employee E
    ON P.emp_id = E.emp_id
    ORDER BY E.last_name, E.first_name;

-- List employee information
CREATE VIEW emp_v
AS
    SELECT E.last_name
         , E.first_name
         , RT.resp_type_name AS emp_type
         , M.last_name AS m_last_name
         , M.first_name AS m_first_name
    FROM employee M 
    RIGHT OUTER JOIN employee E
    ON M.emp_id = E.manager_id
    INNER JOIN resp_type RT
    ON E.emp_type = RT.resp_type_id
    ORDER BY E.last_name, E.first_name;

-- List animal information
CREATE VIEW anim_v
AS
    SELECT A.anim_name
         , A.gender
         , C.cat_name
         , Z.zone_name
         , FLOOR(MONTHS_BETWEEN(TRUNC(SYSDATE), A.anim_dob)/12) AS age
    FROM anim_category C 
    INNER JOIN animal A
    ON C.cat_id = A.cat_id
    INNER JOIN zone Z
    ON C.zone_id = Z.zone_id;

-- List medical tickets
CREATE VIEW med_tick_v
AS
    SELECT T.med_tick_id
         , A.anim_name
         , C.cat_name
         , OE.last_name AS open_by_last_name
         , OE.first_name AS open_by_first_name
         , TO_CHAR(T.open_date, 'MM/DD/YYYY') AS open_date
         , T.open_note
         , CE.last_name AS close_by_last_name
         , CE.first_name AS close_by_first_name
         , TO_CHAR(T.close_date, 'MM/DD/YYYY') AS close_date
         , T.close_note
    FROM medical_ticket T
    INNER JOIN animal A
    ON T.anim_id = A.anim_id
    INNER JOIN anim_category C
    ON A.cat_id = C.cat_id
    INNER JOIN employee OE
    ON T.open_emp = OE.emp_id
    LEFT OUTER JOIN employee CE
    ON T.close_emp = CE.emp_id;

-- List employee responsibilities
CREATE VIEW resp_v
AS
    SELECT S.shift_id
         , Z.zone_id
         , S.shift_name
         , Z.zone_name
         , RT.resp_type_name AS resp_type
         , E.last_name
         , E.first_name
    FROM responsibility R
    INNER JOIN shift S
    ON R.shift_id = S.shift_id
    INNER JOIN zone Z
    ON R.zone_id = Z.zone_id
    INNER JOIN resp_type RT
    ON R.resp_type = RT.resp_type_id
    INNER JOIN employee E
    ON R.emp_id = E.emp_id
    ORDER BY S.shift_id, Z.zone_id, R.resp_type;

-- List animal needs including the employee responsible for each
CREATE VIEW anim_need_v
AS
    SELECT SH.shift_id
         , Z.zone_id
         , Sh.shift_name
         , Z.zone_name   
         , RT.resp_type_name
         , A.anim_name
         , C.cat_name
         , SU.sup_name
         , N.sup_amount
         , SU.sup_unit
         , N.anim_need_note
         , E.last_name
         , E.first_name
    FROM anim_need N
    INNER JOIN animal A
    ON N.anim_id = A.anim_id
    INNER JOIN anim_category C
    ON A.cat_id = C.cat_id
    INNER JOIN supply SU
    ON N.sup_id = SU.sup_id
    INNER JOIN resp_type RT
    ON SU.sup_type = RT.resp_type_id
    INNER JOIN shift SH
    ON N.shift_id = SH.shift_id
    INNER JOIN zone Z
    ON C.zone_id = Z.zone_id
    LEFT OUTER JOIN responsibility R
    ON N.shift_id = R.shift_id
    AND C.zone_id = R.zone_id
    AND SU.sup_type = R.resp_type
    LEFT OUTER JOIN employee E
    ON R.emp_id = E.emp_id
    ORDER BY SH.shift_id, Z.zone_id, SU.sup_type;

-- List animal amounts by category
CREATE VIEW anim_amount_v
AS
    SELECT C.cat_name As animal_category
         , COUNT (A.Anim_ID) As amount
    FROM anim_category C 
    INNER JOIN animal A
    ON C.cat_id = A.cat_id
    GROUP BY C.cat_name
    ORDER BY C.cat_name;

-- List total daily supplies required
CREATE VIEW daily_sup_req_v
AS
    SELECT S.sup_id
         , S.sup_name AS supply
         , SUM(N.sup_amount) AS amount_required
         , S.sup_unit AS unit
    FROM supply S 
    INNER JOIN anim_need N
    ON S.sup_id = n.sup_id
    GROUP BY S.sup_name, S.sup_id, S.sup_unit
    ORDER BY S.Sup_name;

-- List daily supply needs exceeding current stock
CREATE VIEW daily_sup_exc_v
AS
    SELECT S.sup_name AS supply
        , SUM(N.sup_amount) AS amount_required
        , S.sup_unit AS unit
        , S.total_amount AS amount_in_stock
    FROM supply S 
    INNER JOIN anim_need N
    ON S.sup_id = N.sup_id
    GROUP BY S.sup_name, S.sup_unit, S.total_amount
    HAVING SUM(N.sup_amount) > S.total_amount
    ORDER BY S.sup_name;

 /***************
  * insert rows * 
  ***************/
     
INSERT INTO shift (shift_name)
VALUES ('Morning Shift');

INSERT INTO shift (shift_name)
VALUES ('Afternoon Shift');
       
INSERT INTO shift (shift_name)
VALUES ('Night Shift');

INSERT INTO zone (zone_name)
VALUES ('North Zone');
       
INSERT INTO zone (zone_name)
VALUES ('South Zone');
       
INSERT INTO zone (zone_name)
VALUES ('East Zone');

INSERT INTO zone (zone_name)
VALUES ('West Zone');

INSERT INTO resp_type (resp_type_name)
VALUES ('non-medical');

INSERT INTO resp_type (resp_type_name)
VALUES ('medical');

INSERT INTO employee (first_name, last_name, emp_type)
VALUES ('Alicia', 'Mavis', 2); 

INSERT INTO employee (first_name, last_name, emp_type)
VALUES ('Jack', 'Sutherford', 1);

INSERT INTO employee (first_name, last_name, emp_type, manager_id)
VALUES ('Erica', 'Fairlane', 2, 1);

INSERT INTO employee (first_name, last_name, emp_type, manager_id)
VALUES ('John', 'Richardson', 2, 1);

INSERT INTO employee (first_name, last_name, emp_type, manager_id)
VALUES ('Michael', 'Dawson', 1, 2);
       
INSERT INTO employee (first_name, last_name, emp_type, manager_id)
VALUES ('George', 'Abrams', 1, 2);
       
INSERT INTO employee (first_name, last_name, emp_type, manager_id)
VALUES ('Bill', 'Jenkins', 1, 2);
       
INSERT INTO employee (first_name, last_name, emp_type, manager_id)
VALUES ('Brian', 'Smith', 1, 2);
       
INSERT INTO employee (first_name, last_name, emp_type, manager_id)
VALUES ('Carlo', 'Rodriguez', 1, 2);

INSERT INTO employee (first_name, last_name, emp_type, manager_id)
VALUES ('Trisha', 'Martens', 1, 2);
       
INSERT INTO emp_phone (emp_id, phone_no)
VALUES (1, '4435940392');

INSERT INTO emp_phone (emp_id, phone_no)
VALUES (1, '4109583944');

INSERT INTO emp_phone (emp_id, phone_no)
VALUES (2, '4103827382');

INSERT INTO emp_phone (emp_id, phone_no)
VALUES (2, '4436596328');

INSERT INTO emp_phone (emp_id, phone_no)
VALUES (2, '4436842166');
       
INSERT INTO emp_phone (emp_id, phone_no)
VALUES (3, '4106425688');
       
INSERT INTO emp_phone (emp_id, phone_no)
VALUES (4, '4432689645');
       
INSERT INTO emp_phone (emp_id, phone_no)
VALUES (5, '4436595421');

INSERT INTO emp_phone (emp_id, phone_no)
VALUES (6, '4106532994');
       
INSERT INTO emp_phone (emp_id, phone_no)
VALUES (7, '4436712659');
       
INSERT INTO emp_phone (emp_id, phone_no)
VALUES (8, '4103946236');

INSERT INTO emp_phone (emp_id, phone_no)
VALUES (9, '4109582033');

INSERT INTO emp_phone (emp_id, phone_no)
VALUES (10, '4435930200');
       
INSERT INTO supply (sup_name, sup_unit, total_amount, sup_type) 
VALUES ('Raw Beef', 'lb', 600, 1);

INSERT INTO supply (sup_name, sup_unit, total_amount, sup_type)
VALUES ('Vegetable Food Mix', 'lb', 400, 1);

INSERT INTO supply (sup_name, sup_unit, total_amount, sup_type, admin_route)
VALUES ('Anti-Biotics', 'mg', 3000, 2, 'o');

INSERT INTO supply (sup_name, sup_unit, total_amount, sup_type, admin_route)
VALUES ('Benzodiazepine', 'mg', 90, 2, 'o');
 
INSERT INTO anim_category (cat_name, zone_id)
VALUES ('Lion', 1);

INSERT INTO anim_category (cat_name, zone_id)
VALUES ('Tiger', 1);

INSERT INTO anim_category (cat_name, zone_id)
VALUES ('Bear', 1);

INSERT INTO anim_category (cat_name, zone_id)
VALUES ('Monkey', 2);

INSERT INTO anim_category (cat_name, zone_id)
VALUES ('Zebra', 3);

INSERT INTO anim_category (cat_name, zone_id)
VALUES ('Elephant', 4);

INSERT INTO anim_category (cat_name, zone_id)
VALUES ('Gorilla', 2); 
      
INSERT INTO animal (anim_name, cat_id, gender, anim_dob)
VALUES ('Oscar', 1, 'm', DATE '1991-12-01');

INSERT INTO animal (anim_name, cat_id, gender, anim_dob)
VALUES ('Raffi', 1, 'm', DATE '1993-02-11');

INSERT INTO animal (anim_name, cat_id, gender, anim_dob)
VALUES ('Simon', 1, 'm', DATE '1995-03-14');

INSERT INTO animal (anim_name, cat_id, gender, anim_dob)
VALUES ('Jakey', 2 , 'm', DATE '1995-07-02');

INSERT INTO animal (anim_name, cat_id, gender, anim_dob)
VALUES ('Sheila', 2, 'f', DATE '1993-02-10');

INSERT INTO animal (anim_name, cat_id, gender, anim_dob)
VALUES ('Mikey', 2, 'm', DATE '2005-04-23');

INSERT INTO animal (anim_name, cat_id, gender, anim_dob)
VALUES ('Mimi', 3, 'f', DATE '1999-02-22');

INSERT INTO animal (anim_name, cat_id, gender, anim_dob)
VALUES ('Agnes', 3, 'f', DATE '1990-02-14');

INSERT INTO animal (anim_name, cat_id, gender, anim_dob)
VALUES ('Charlie', 3, 'm', DATE '1994-01-12');

INSERT INTO animal (anim_name, cat_id, gender, anim_dob)
VALUES ('Morris', 4, 'm', DATE '1998-04-19');

INSERT INTO animal (anim_name, cat_id, gender, anim_dob)
VALUES ('Phoebe', 4, 'f', DATE '2004-04-17');

INSERT INTO animal (anim_name, cat_id, gender, anim_dob)
VALUES ('Jackson', 4, 'm', DATE '1999-06-05');

INSERT INTO animal (anim_name, cat_id, gender, anim_dob)
VALUES ('Lydia', 5, 'f', DATE '1995-02-04');

INSERT INTO animal (anim_name, cat_id, gender, anim_dob)
VALUES ('Sarah', 5, 'f', DATE '1992-04-06');

INSERT INTO animal (anim_name, cat_id, gender, anim_dob)
VALUES ('George', 5, 'm', DATE '2005-02-03');

INSERT INTO animal (anim_name, cat_id, gender, anim_dob)
VALUES ('Sally', 5, 'f', DATE '2002-04-03');

INSERT INTO animal (anim_name, cat_id, gender, anim_dob)
VALUES ('Marshall', 6, 'm', DATE '2001-02-18');


INSERT INTO anim_need (anim_id, sup_id, sup_amount, shift_id, anim_need_note)
VALUES (5, 3, 20, 2, 'To be given up until 2/17/14.');
                   
INSERT INTO anim_need (anim_id, sup_id, sup_amount, shift_id, anim_need_note)
VALUES (7, 4, 10, 1, 'Must be given at around 6:00.');
        
INSERT INTO anim_need (anim_id, sup_id, sup_amount, shift_id, anim_need_note)
VALUES (7, 4, 10, 1, 'Must be given at around 10:00.');
        
INSERT INTO anim_need (anim_id, sup_id, sup_amount, shift_id, anim_need_note)
VALUES (3, 4, 2, 3, 'Must be given at around 11:00.');

INSERT INTO medical_ticket (anim_id, open_emp, close_emp, open_date, 
                             close_date, open_note, close_note)
VALUES (5, 6, 3, DATE '2013-01-25', DATE '2013-01-26',
'Sheila seems to have a stomache ache and isn''t eating very much.',
'She''s doing much better today and all her signs are normal plus she''s
 happily eating.');

INSERT INTO medical_ticket (anim_id, open_emp, close_emp, open_date, 
                             close_date, open_note, close_note)
VALUES (5, 7, 3, DATE '2013-05-14', DATE '2013-05-16',
'Sheila hurt her foot when running and it is now swollen.',
'Applied bandages, Sheila needs some rest but she should be back to herself
 in a couple of days.');

INSERT INTO medical_ticket (anim_id, open_emp, close_emp, open_date, 
                             close_date, open_note, close_note)
VALUES (5, 5, 4, DATE '2014-02-15', DATE '2014-02-17',
'Sheila has been acting lethargic and not eating.',
'Sheila had a fever, prescribing anti-biotics once daily until 2/17/14.');

INSERT INTO medical_ticket (anim_id, open_emp, close_emp, open_date, 
                             close_date, open_note, close_note)
VALUES (7, 7, 4, DATE '2014-01-15', DATE '2014-01-17',
'Mimi is acting extremely hyper and irate.',
'After a thorough evaluation, I prescribed her medicine to make her more
 relaxed. She needs to take it twice in the morning as prescribed.');

INSERT INTO medical_ticket (anim_id, open_emp, close_emp, open_date, 
                             close_date, open_note, close_note)
VALUES (3, 8, 4, DATE '2014-01-15', DATE '2014-01-17',
'Simon is having trouble falling asleep.',
'After a thorough evaluation, I prescribed him medicine to help him sleep.');

INSERT INTO medical_ticket (anim_id, open_emp, open_date, open_note)
VALUES (4, 6, DATE '2014-02-15', 'Jakey has been sitting in the corner of his
 play area all day, I''m concerned he may be ill or depressed.');

INSERT INTO medical_ticket (anim_id, open_emp, open_date, open_note)
VALUES (1, 7, DATE '2014-02-16', 'Appearantly Oscar got into a fight with the
 other lions and his ear may be injured. Requires medical evaluation.');

INSERT INTO medical_ticket (anim_id, open_emp, open_date, open_note)
VALUES (11, 5, DATE '2014-02-17', 'Phoebe hasn''t been eating her vegetables and
 has instead been throwing them at the staff.
 I am requesting a medical evaluation to make sure that she is alright.');

INSERT INTO responsibility (emp_id, shift_id, zone_id, resp_type)
VALUES (5, 1, 1, 1);

INSERT INTO responsibility (emp_id, shift_id, zone_id, resp_type)
VALUES (5, 1, 2, 1);

INSERT INTO responsibility (emp_id, shift_id, zone_id, resp_type)
VALUES (6, 1, 3, 1);

INSERT INTO responsibility (emp_id, shift_id, zone_id, resp_type)
VALUES (6, 1, 4, 1);

INSERT INTO responsibility (emp_id, shift_id, zone_id, resp_type)
VALUES (7, 2, 1, 1);

INSERT INTO responsibility (emp_id, shift_id, zone_id, resp_type)
VALUES (7, 2, 2, 1);

INSERT INTO responsibility (emp_id, shift_id, zone_id, resp_type)
VALUES (8, 2, 3, 1);

INSERT INTO responsibility (emp_id, shift_id, zone_id, resp_type)
VALUES (8, 2, 4, 1);

INSERT INTO responsibility (emp_id, shift_id, zone_id, resp_type)
VALUES (9, 3, 1, 1);

INSERT INTO responsibility (emp_id, shift_id, zone_id, resp_type)
VALUES (9, 3, 2, 1);

INSERT INTO responsibility (emp_id, shift_id, zone_id, resp_type)
VALUES (10, 3, 3, 1);

INSERT INTO responsibility (emp_id, shift_id, zone_id, resp_type)
VALUES (10, 3, 4, 1);

INSERT INTO responsibility (emp_id, shift_id, zone_id, resp_type)
VALUES (3, 1, 1, 2);

INSERT INTO responsibility (emp_id, shift_id, zone_id, resp_type)
VALUES (3, 1, 2, 2);

INSERT INTO responsibility (emp_id, shift_id, zone_id, resp_type)
VALUES (3, 1, 3, 2);

INSERT INTO responsibility (emp_id, shift_id, zone_id, resp_type)
VALUES (3, 1, 4, 2);

INSERT INTO responsibility (emp_id, shift_id, zone_id, resp_type)
VALUES (3, 2, 1 , 2);

INSERT INTO responsibility (emp_id, shift_id, zone_id, resp_type)
VALUES (3, 2, 2, 2);

INSERT INTO responsibility (emp_id, shift_id, zone_id, resp_type)
VALUES (3, 2, 3, 2);

INSERT INTO responsibility (emp_id, shift_id, zone_id, resp_type)
VALUES (3, 2, 4, 2);

INSERT INTO responsibility (emp_id, shift_id, zone_id, resp_type)
VALUES (4, 3, 1, 2);

INSERT INTO responsibility (emp_id, shift_id, zone_id, resp_type)
VALUES (4, 3, 2, 2);

INSERT INTO responsibility (emp_id, shift_id, zone_id, resp_type)
VALUES (4, 3, 3, 2);

INSERT INTO responsibility (emp_id, shift_id, zone_id, resp_type)
VALUES (4, 3, 4, 2);


 /*********************
  * stored procedures * 
  *********************/

/* Update supplies by subtracting total daily needs from current inventory
   Raises an exception if daily needs exceed current stock for any item
*/
CREATE OR REPLACE PROCEDURE update_sup 
IS
    insuffic_stock EXCEPTION;
    sup_exceed_count PLS_INTEGER;
        
    BEGIN
        SELECT COUNT(*) INTO sup_exceed_count FROM daily_sup_exc_v;

        IF sup_exceed_count > 0 THEN
            RAISE insuffic_stock;
        END IF;  
    
        FOR daily_sup_row IN (SELECT sup_id
                                   , amount_required
                              FROM daily_sup_req_v)
        LOOP
            UPDATE supply
            SET total_amount = total_amount - daily_sup_row.amount_required
            WHERE sup_id = daily_sup_row.sup_id;
        END LOOP;
    
    EXCEPTION
        WHEN insuffic_stock THEN
            RAISE_APPLICATION_ERROR(-20002, 'insufficient stock');
    END;
/
