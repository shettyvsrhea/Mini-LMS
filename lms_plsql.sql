SET DEFINE OFF;

CREATE SEQUENCE student_seq START WITH 100 INCREMENT BY 1;
CREATE SEQUENCE enrollment_seq START WITH 100 INCREMENT BY 1;
CREATE SEQUENCE submission_seq START WITH 100 INCREMENT BY 1;
CREATE SEQUENCE attendance_seq START WITH 100 INCREMENT BY 1;
CREATE SEQUENCE announcement_seq START WITH 100 INCREMENT BY 1;
CREATE SEQUENCE assignment_seq START WITH 100 INCREMENT BY 1;
CREATE SEQUENCE grade_audit_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE PROCEDURE add_student(
    p_reg_no IN VARCHAR2,
    p_name IN VARCHAR2,
    p_email IN VARCHAR2,
    p_gender IN CHAR,
    p_dob IN DATE,
    p_dept_id IN NUMBER,
    p_batch_year IN NUMBER
) IS
BEGIN
    INSERT INTO student VALUES (
        student_seq.NEXTVAL, p_reg_no, p_name, p_email,
        p_gender, p_dob, p_dept_id, p_batch_year
    );
    COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE add_enrollment(
    p_student_id IN NUMBER,
    p_offering_id IN NUMBER
) IS
    v_count NUMBER;
    v_max NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM enrollment
    WHERE offering_id = p_offering_id AND status = 'Enrolled';

    SELECT max_students INTO v_max
    FROM course_offering
    WHERE offering_id = p_offering_id;

    IF v_count >= v_max THEN
        RAISE_APPLICATION_ERROR(-20001, 'Offering is full. Cannot enroll.');
    END IF;

    INSERT INTO enrollment VALUES (
        enrollment_seq.NEXTVAL, p_student_id, p_offering_id,
        SYSDATE, 'Enrolled', NULL, NULL
    );
    COMMIT;
END;
/

CREATE OR REPLACE FUNCTION get_student_cgpa(p_student_id IN NUMBER)
RETURN NUMBER
IS
    v_cgpa NUMBER;
BEGIN
    SELECT ROUND(SUM(e.grade_points * c.credits) / NULLIF(SUM(c.credits), 0), 2)
    INTO v_cgpa
    FROM enrollment e
    JOIN course_offering co ON e.offering_id = co.offering_id
    JOIN course c ON co.course_id = c.course_id
    WHERE e.student_id = p_student_id
      AND e.status = 'Completed'
      AND e.grade_points IS NOT NULL;
    RETURN NVL(v_cgpa, 0);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;
/

CREATE OR REPLACE FUNCTION get_attendance_pct(
    p_student_id IN NUMBER,
    p_offering_id IN NUMBER
) RETURN NUMBER
IS
    v_total NUMBER;
    v_present NUMBER;
BEGIN
    SELECT COUNT(*), SUM(CASE WHEN a.status = 'P' THEN 1 ELSE 0 END)
    INTO v_total, v_present
    FROM attendance a
    JOIN enrollment e ON a.enrollment_id = e.enrollment_id
    WHERE e.student_id = p_student_id
      AND e.offering_id = p_offering_id;

    IF v_total = 0 THEN
        RETURN 0;
    END IF;
    RETURN ROUND((v_present * 100.0) / v_total, 2);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;
/

CREATE OR REPLACE TRIGGER trg_grade_audit
AFTER UPDATE OF final_grade ON enrollment
FOR EACH ROW
BEGIN
    INSERT INTO grade_audit VALUES (
        grade_audit_seq.NEXTVAL,
        :OLD.enrollment_id,
        :OLD.final_grade,
        :NEW.final_grade,
        NULL,
        SYSDATE,
        'Grade changed from ' || NVL(:OLD.final_grade, 'NULL') || ' to ' || :NEW.final_grade
    );
END;
/

CREATE OR REPLACE TRIGGER trg_check_capacity
BEFORE INSERT ON enrollment
FOR EACH ROW
DECLARE
    v_count NUMBER;
    v_max NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM enrollment
    WHERE offering_id = :NEW.offering_id AND status = 'Enrolled';

    SELECT max_students INTO v_max
    FROM course_offering
    WHERE offering_id = :NEW.offering_id;

    IF v_count >= v_max THEN
        RAISE_APPLICATION_ERROR(-20002, 'Cannot enroll: offering has reached max capacity.');
    END IF;
END;
/
