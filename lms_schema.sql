-- ============================================================
--  MINI LMS  –  Full Schema
--  Oracle SQL (PL/SQL compatible)
-- ============================================================


-- ───────────────────────────────────────────────
--  DEPARTMENT
-- ───────────────────────────────────────────────
CREATE TABLE department (
    dept_id      NUMBER(5),
    dept_name    VARCHAR2(60)  NOT NULL,
    hod_name     VARCHAR2(60),
    CONSTRAINT dept_pk PRIMARY KEY (dept_id),
    CONSTRAINT dept_name_uq UNIQUE (dept_name)
);


-- ───────────────────────────────────────────────
--  INSTRUCTOR
-- ───────────────────────────────────────────────
CREATE TABLE instructor (
    instructor_id    NUMBER(6),
    name             VARCHAR2(60)  NOT NULL,
    email            VARCHAR2(80)  NOT NULL,
    dept_id          NUMBER(5)     NOT NULL,
    designation      VARCHAR2(40),
    date_joined      DATE          DEFAULT SYSDATE,
    CONSTRAINT instructor_pk     PRIMARY KEY (instructor_id),
    CONSTRAINT instructor_email_uq UNIQUE (email),
    CONSTRAINT instructor_dept_fk  FOREIGN KEY (dept_id)
        REFERENCES department (dept_id)
);


-- ───────────────────────────────────────────────
--  STUDENT
-- ───────────────────────────────────────────────
CREATE TABLE student (
    student_id       NUMBER(6),
    reg_no           VARCHAR2(15)  NOT NULL,
    name             VARCHAR2(60)  NOT NULL,
    email            VARCHAR2(80)  NOT NULL,
    gender           CHAR(1)       NOT NULL,
    dob              DATE          NOT NULL,
    dept_id          NUMBER(5)     NOT NULL,
    batch_year       NUMBER(4)     NOT NULL,
    CONSTRAINT student_pk        PRIMARY KEY (student_id),
    CONSTRAINT student_reg_uq    UNIQUE (reg_no),
    CONSTRAINT student_email_uq  UNIQUE (email),
    CONSTRAINT student_gender_ck CHECK (gender IN ('M', 'F', 'O')),
    CONSTRAINT student_dept_fk   FOREIGN KEY (dept_id)
        REFERENCES department (dept_id),
    CONSTRAINT student_batch_ck  CHECK (batch_year BETWEEN 2000 AND 2100)
);


-- ───────────────────────────────────────────────
--  COURSE
-- ───────────────────────────────────────────────
CREATE TABLE course (
    course_id        VARCHAR2(10),
    title            VARCHAR2(100) NOT NULL,
    dept_id          NUMBER(5)     NOT NULL,
    credits          NUMBER(2)     NOT NULL,
    course_type      VARCHAR2(20)  DEFAULT 'Core',
    description      VARCHAR2(300),
    CONSTRAINT course_pk         PRIMARY KEY (course_id),
    CONSTRAINT course_credits_ck CHECK (credits > 0),
    CONSTRAINT course_type_ck    CHECK (course_type IN ('Core', 'Elective', 'Lab', 'Project')),
    CONSTRAINT course_dept_fk    FOREIGN KEY (dept_id)
        REFERENCES department (dept_id)
);


-- ───────────────────────────────────────────────
--  PREREQUISITE
--  A course can have multiple prerequisites.
--  prereq_id is the course that must be completed
--  before course_id can be taken.
-- ───────────────────────────────────────────────
CREATE TABLE prerequisite (
    course_id        VARCHAR2(10),
    prereq_id        VARCHAR2(10),
    min_grade        CHAR(2) DEFAULT 'D',
    CONSTRAINT prereq_pk         PRIMARY KEY (course_id, prereq_id),
    CONSTRAINT prereq_course_fk  FOREIGN KEY (course_id)
        REFERENCES course (course_id),
    CONSTRAINT prereq_prereq_fk  FOREIGN KEY (prereq_id)
        REFERENCES course (course_id),
    CONSTRAINT prereq_no_self_ck CHECK (course_id <> prereq_id),
    CONSTRAINT prereq_grade_ck   CHECK (min_grade IN ('A+','A','B','C','D','F'))
);


-- ───────────────────────────────────────────────
--  COURSE OFFERING
--  One row per course per semester per instructor.
-- ───────────────────────────────────────────────
CREATE TABLE course_offering (
    offering_id      NUMBER(8),
    course_id        VARCHAR2(10)  NOT NULL,
    instructor_id    NUMBER(6)     NOT NULL,
    semester         VARCHAR2(10)  NOT NULL,
    academic_year    VARCHAR2(9)   NOT NULL,
    room_no          VARCHAR2(15),
    max_students     NUMBER(3)     DEFAULT 60  NOT NULL,
    schedule         VARCHAR2(100),
    CONSTRAINT offering_pk          PRIMARY KEY (offering_id),
    CONSTRAINT offering_course_fk   FOREIGN KEY (course_id)
        REFERENCES course (course_id),
    CONSTRAINT offering_inst_fk     FOREIGN KEY (instructor_id)
        REFERENCES instructor (instructor_id),
    CONSTRAINT offering_sem_ck      CHECK (semester IN ('Spring','Summer','Fall','Winter')),
    CONSTRAINT offering_max_ck      CHECK (max_students > 0),
    CONSTRAINT offering_uq          UNIQUE (course_id, instructor_id, semester, academic_year)
);


-- ───────────────────────────────────────────────
--  ENROLLMENT
--  Maps students to course offerings.
-- ───────────────────────────────────────────────
CREATE TABLE enrollment (
    enrollment_id    NUMBER(10),
    student_id       NUMBER(6)     NOT NULL,
    offering_id      NUMBER(8)     NOT NULL,
    enroll_date      DATE          DEFAULT SYSDATE,
    status           VARCHAR2(15)  DEFAULT 'Enrolled',
    final_grade      CHAR(2),
    grade_points     NUMBER(3,1),
    CONSTRAINT enrollment_pk         PRIMARY KEY (enrollment_id),
    CONSTRAINT enrollment_student_fk FOREIGN KEY (student_id)
        REFERENCES student (student_id),
    CONSTRAINT enrollment_offering_fk FOREIGN KEY (offering_id)
        REFERENCES course_offering (offering_id),
    CONSTRAINT enrollment_uq         UNIQUE (student_id, offering_id),
    CONSTRAINT enrollment_status_ck  CHECK (status IN ('Enrolled','Dropped','Completed','Withdrawn')),
    CONSTRAINT enrollment_grade_ck   CHECK (final_grade IN ('A+','A','B','C','D','F') OR final_grade IS NULL),
    CONSTRAINT enrollment_gp_ck      CHECK (grade_points BETWEEN 0 AND 10 OR grade_points IS NULL)
);


-- ───────────────────────────────────────────────
--  ASSIGNMENT
--  Belongs to a course offering.
-- ───────────────────────────────────────────────
CREATE TABLE assignment (
    assignment_id    NUMBER(8),
    offering_id      NUMBER(8)     NOT NULL,
    title            VARCHAR2(100) NOT NULL,
    assignment_type  VARCHAR2(20)  DEFAULT 'Assignment',
    max_marks        NUMBER(5,2)   NOT NULL,
    weightage        NUMBER(5,2)   NOT NULL,
    due_date         DATE,
    description      VARCHAR2(300),
    CONSTRAINT assignment_pk         PRIMARY KEY (assignment_id),
    CONSTRAINT assignment_offering_fk FOREIGN KEY (offering_id)
        REFERENCES course_offering (offering_id),
    CONSTRAINT assignment_type_ck    CHECK (assignment_type IN
        ('Assignment','Quiz','MidTerm','EndTerm','Project','Lab')),
    CONSTRAINT assignment_marks_ck   CHECK (max_marks > 0),
    CONSTRAINT assignment_weight_ck  CHECK (weightage > 0 AND weightage <= 100)
);


-- ───────────────────────────────────────────────
--  SUBMISSION
--  One row per student per assignment.
-- ───────────────────────────────────────────────
CREATE TABLE submission (
    submission_id    NUMBER(10),
    assignment_id    NUMBER(8)     NOT NULL,
    student_id       NUMBER(6)     NOT NULL,
    submit_date      DATE,
    marks_obtained   NUMBER(5,2),
    feedback         VARCHAR2(500),
    graded_by        NUMBER(6),
    graded_on        DATE,
    CONSTRAINT submission_pk           PRIMARY KEY (submission_id),
    CONSTRAINT submission_assign_fk    FOREIGN KEY (assignment_id)
        REFERENCES assignment (assignment_id),
    CONSTRAINT submission_student_fk   FOREIGN KEY (student_id)
        REFERENCES student (student_id),
    CONSTRAINT submission_grader_fk    FOREIGN KEY (graded_by)
        REFERENCES instructor (instructor_id),
    CONSTRAINT submission_uq           UNIQUE (assignment_id, student_id),
    CONSTRAINT submission_marks_ck     CHECK (marks_obtained >= 0 OR marks_obtained IS NULL)
);


-- ───────────────────────────────────────────────
--  ATTENDANCE
--  Daily attendance per student per offering.
-- ───────────────────────────────────────────────
CREATE TABLE attendance (
    attendance_id    NUMBER(10),
    enrollment_id    NUMBER(10)    NOT NULL,
    class_date       DATE          NOT NULL,
    status           CHAR(1)       NOT NULL,
    remarks          VARCHAR2(100),
    CONSTRAINT attendance_pk          PRIMARY KEY (attendance_id),
    CONSTRAINT attendance_enroll_fk   FOREIGN KEY (enrollment_id)
        REFERENCES enrollment (enrollment_id),
    CONSTRAINT attendance_uq          UNIQUE (enrollment_id, class_date),
    CONSTRAINT attendance_status_ck   CHECK (status IN ('P','A','L','M'))
);


-- ───────────────────────────────────────────────
--  ANNOUNCEMENT
--  Instructor posts announcements per offering.
-- ───────────────────────────────────────────────
CREATE TABLE announcement (
    announcement_id  NUMBER(8),
    offering_id      NUMBER(8)     NOT NULL,
    posted_by        NUMBER(6)     NOT NULL,
    title            VARCHAR2(100) NOT NULL,
    content          VARCHAR2(2000) NOT NULL,
    posted_on        DATE          DEFAULT SYSDATE,
    is_urgent        CHAR(1)       DEFAULT 'N',
    CONSTRAINT announcement_pk         PRIMARY KEY (announcement_id),
    CONSTRAINT announcement_offering_fk FOREIGN KEY (offering_id)
        REFERENCES course_offering (offering_id),
    CONSTRAINT announcement_inst_fk    FOREIGN KEY (posted_by)
        REFERENCES instructor (instructor_id),
    CONSTRAINT announcement_urgent_ck  CHECK (is_urgent IN ('Y','N'))
);


-- ───────────────────────────────────────────────
--  GRADE AUDIT LOG
--  Tracks every change to enrollment.final_grade.
-- ───────────────────────────────────────────────
CREATE TABLE grade_audit (
    audit_id         NUMBER(10),
    enrollment_id    NUMBER(10)    NOT NULL,
    old_grade        CHAR(2),
    new_grade        CHAR(2),
    changed_by       NUMBER(6),
    changed_on       DATE          DEFAULT SYSDATE,
    reason           VARCHAR2(200),
    CONSTRAINT grade_audit_pk          PRIMARY KEY (audit_id),
    CONSTRAINT grade_audit_enroll_fk   FOREIGN KEY (enrollment_id)
        REFERENCES enrollment (enrollment_id),
    CONSTRAINT grade_audit_inst_fk     FOREIGN KEY (changed_by)
        REFERENCES instructor (instructor_id)
);


-- ============================================================
--  VIEWS
-- ============================================================

CREATE OR REPLACE VIEW student_cgpa AS
SELECT
    e.student_id,
    s.name,
    s.reg_no,
    ROUND(SUM(e.grade_points * c.credits) / NULLIF(SUM(c.credits), 0), 2) AS cgpa,
    SUM(c.credits) AS total_credits_completed
FROM enrollment e
JOIN course_offering co ON e.offering_id  = co.offering_id
JOIN course          c  ON co.course_id   = c.course_id
JOIN student         s  ON e.student_id   = s.student_id
WHERE e.status = 'Completed'
  AND e.grade_points IS NOT NULL
GROUP BY e.student_id, s.name, s.reg_no;


CREATE OR REPLACE VIEW offering_summary AS
SELECT
    co.offering_id,
    c.course_id,
    c.title                                    AS course_title,
    i.name                                     AS instructor_name,
    co.semester,
    co.academic_year,
    COUNT(e.enrollment_id)                     AS enrolled_count,
    co.max_students,
    co.max_students - COUNT(e.enrollment_id)   AS seats_remaining,
    ROUND(AVG(e.grade_points), 2)              AS avg_grade_points
FROM course_offering co
JOIN course      c  ON co.course_id      = c.course_id
JOIN instructor  i  ON co.instructor_id  = i.instructor_id
LEFT JOIN enrollment e ON co.offering_id = e.offering_id
    AND e.status IN ('Enrolled', 'Completed')
GROUP BY
    co.offering_id, c.course_id, c.title,
    i.name, co.semester, co.academic_year,
    co.max_students;


CREATE OR REPLACE VIEW student_transcript AS
SELECT
    s.reg_no,
    s.name                  AS student_name,
    c.course_id,
    c.title                 AS course_title,
    c.credits,
    co.semester,
    co.academic_year,
    e.final_grade,
    e.grade_points,
    e.status                AS enrollment_status
FROM enrollment  e
JOIN student         s  ON e.student_id  = s.student_id
JOIN course_offering co ON e.offering_id = co.offering_id
JOIN course          c  ON co.course_id  = c.course_id
ORDER BY s.reg_no, co.academic_year, co.semester;


CREATE OR REPLACE VIEW assignment_score_summary AS
SELECT
    sub.student_id,
    s.name                  AS student_name,
    a.offering_id,
    a.assignment_id,
    a.title                 AS assignment_title,
    a.assignment_type,
    a.max_marks,
    a.weightage,
    sub.marks_obtained,
    ROUND((sub.marks_obtained / NULLIF(a.max_marks, 0)) * a.weightage, 2) AS weighted_score
FROM submission sub
JOIN assignment a ON sub.assignment_id = a.assignment_id
JOIN student    s ON sub.student_id    = s.student_id;


CREATE OR REPLACE VIEW attendance_summary AS
SELECT
    e.student_id,
    s.name                  AS student_name,
    e.offering_id,
    COUNT(att.attendance_id)                                      AS total_classes,
    SUM(CASE WHEN att.status = 'P' THEN 1 ELSE 0 END)            AS present,
    SUM(CASE WHEN att.status = 'A' THEN 1 ELSE 0 END)            AS absent,
    SUM(CASE WHEN att.status = 'L' THEN 1 ELSE 0 END)            AS leave,
    ROUND(
        SUM(CASE WHEN att.status = 'P' THEN 1 ELSE 0 END) * 100.0
        / NULLIF(COUNT(att.attendance_id), 0), 2
    )                                                             AS attendance_pct
FROM enrollment  e
JOIN student     s   ON e.student_id    = s.student_id
JOIN attendance  att ON att.enrollment_id = e.enrollment_id
GROUP BY e.student_id, s.name, e.offering_id;

ALTER TABLE enrollment DROP CONSTRAINT enrollment_student_fk;
ALTER TABLE enrollment ADD CONSTRAINT enrollment_student_fk
    FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE CASCADE;

ALTER TABLE submission DROP CONSTRAINT submission_student_fk;
ALTER TABLE submission ADD CONSTRAINT submission_student_fk
    FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE CASCADE;

ALTER TABLE enrollment DROP CONSTRAINT enrollment_offering_fk;
ALTER TABLE enrollment ADD CONSTRAINT enrollment_offering_fk
    FOREIGN KEY (offering_id) REFERENCES course_offering(offering_id) ON DELETE CASCADE;

ALTER TABLE course_offering DROP CONSTRAINT offering_inst_fk;
ALTER TABLE course_offering ADD CONSTRAINT offering_inst_fk
    FOREIGN KEY (instructor_id) REFERENCES instructor(instructor_id) ON DELETE CASCADE;

ALTER TABLE announcement DROP CONSTRAINT announcement_inst_fk;
ALTER TABLE announcement ADD CONSTRAINT announcement_inst_fk
    FOREIGN KEY (posted_by) REFERENCES instructor(instructor_id) ON DELETE CASCADE;

ALTER TABLE submission DROP CONSTRAINT submission_grader_fk;
ALTER TABLE submission ADD CONSTRAINT submission_grader_fk
    FOREIGN KEY (graded_by) REFERENCES instructor(instructor_id) ON DELETE SET NULL;

ALTER TABLE grade_audit DROP CONSTRAINT grade_audit_inst_fk;
ALTER TABLE grade_audit ADD CONSTRAINT grade_audit_inst_fk
    FOREIGN KEY (changed_by) REFERENCES instructor(instructor_id) ON DELETE SET NULL;

ALTER TABLE assignment DROP CONSTRAINT assignment_offering_fk;
ALTER TABLE assignment ADD CONSTRAINT assignment_offering_fk
    FOREIGN KEY (offering_id) REFERENCES course_offering(offering_id) ON DELETE CASCADE;

ALTER TABLE attendance DROP CONSTRAINT attendance_enroll_fk;
ALTER TABLE attendance ADD CONSTRAINT attendance_enroll_fk
    FOREIGN KEY (enrollment_id) REFERENCES enrollment(enrollment_id) ON DELETE CASCADE;

ALTER TABLE submission DROP CONSTRAINT submission_assign_fk;
ALTER TABLE submission ADD CONSTRAINT submission_assign_fk
    FOREIGN KEY (assignment_id) REFERENCES assignment(assignment_id) ON DELETE CASCADE;

ALTER TABLE announcement DROP CONSTRAINT announcement_offering_fk;
ALTER TABLE announcement ADD CONSTRAINT announcement_offering_fk
    FOREIGN KEY (offering_id) REFERENCES course_offering(offering_id) ON DELETE CASCADE;

ALTER TABLE grade_audit DROP CONSTRAINT grade_audit_enroll_fk;
ALTER TABLE grade_audit ADD CONSTRAINT grade_audit_enroll_fk
    FOREIGN KEY (enrollment_id) REFERENCES enrollment(enrollment_id) ON DELETE CASCADE;
