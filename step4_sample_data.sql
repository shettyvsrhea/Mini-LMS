INSERT INTO department VALUES (1, 'Computer Science & Engineering', 'Dr. Ramesh Kumar');
INSERT INTO department VALUES (2, 'Information Technology', 'Dr. Priya Nair');
INSERT INTO department VALUES (3, 'Electronics & Communication', 'Dr. Suresh Bhat');
INSERT INTO department VALUES (4, 'Mathematics', 'Dr. Anjali Menon');

INSERT INTO instructor VALUES (1, 'Dr. Ramesh Kumar',  'ramesh.kumar@mit.edu',  1, 'Professor',            TO_DATE('01-JAN-2010','DD-MON-YYYY'));
INSERT INTO instructor VALUES (2, 'Dr. Priya Nair',    'priya.nair@mit.edu',    2, 'Associate Professor',  TO_DATE('15-JUN-2013','DD-MON-YYYY'));
INSERT INTO instructor VALUES (3, 'Dr. Suresh Bhat',   'suresh.bhat@mit.edu',   3, 'Professor',            TO_DATE('10-AUG-2008','DD-MON-YYYY'));
INSERT INTO instructor VALUES (4, 'Dr. Anjali Menon',  'anjali.menon@mit.edu',  4, 'Assistant Professor',  TO_DATE('20-MAR-2018','DD-MON-YYYY'));
INSERT INTO instructor VALUES (5, 'Mr. Kiran Shetty',  'kiran.shetty@mit.edu',  1, 'Lecturer',             TO_DATE('05-JUL-2020','DD-MON-YYYY'));

INSERT INTO student VALUES (1, '240962001', 'Aarav Sharma',    'aarav.sharma@learner.mit.edu',    'M', TO_DATE('12-MAR-2005','DD-MON-YYYY'), 1, 2024);
INSERT INTO student VALUES (2, '240962002', 'Rhea Shetty',     'rhea.shetty@learner.mit.edu',     'F', TO_DATE('22-JUL-2005','DD-MON-YYYY'), 1, 2024);
INSERT INTO student VALUES (3, '240962003', 'Mohammed ML',     'mohammed.ml@learner.mit.edu',     'M', TO_DATE('05-NOV-2004','DD-MON-YYYY'), 1, 2024);
INSERT INTO student VALUES (4, '240962004', 'Sneha Rao',       'sneha.rao@learner.mit.edu',       'F', TO_DATE('18-JAN-2005','DD-MON-YYYY'), 2, 2024);
INSERT INTO student VALUES (5, '240962005', 'Arjun Nambiar',   'arjun.nambiar@learner.mit.edu',   'M', TO_DATE('30-APR-2005','DD-MON-YYYY'), 2, 2024);
INSERT INTO student VALUES (6, '240962006', 'Divya Krishnan',  'divya.krishnan@learner.mit.edu',  'F', TO_DATE('09-SEP-2004','DD-MON-YYYY'), 1, 2024);
INSERT INTO student VALUES (7, '240962007', 'Rahul Verma',     'rahul.verma@learner.mit.edu',     'M', TO_DATE('14-FEB-2005','DD-MON-YYYY'), 3, 2024);
INSERT INTO student VALUES (8, '240962008', 'Pooja Hegde',     'pooja.hegde@learner.mit.edu',     'F', TO_DATE('27-DEC-2004','DD-MON-YYYY'), 1, 2024);

INSERT INTO course VALUES ('CS101', 'Introduction to Programming',     1, 4, 'Core',     'Fundamentals of programming using C');
INSERT INTO course VALUES ('CS201', 'Data Structures & Algorithms',    1, 4, 'Core',     'Arrays, linked lists, trees, graphs');
INSERT INTO course VALUES ('CS301', 'Database Systems',                1, 3, 'Core',     'Relational databases and SQL');
INSERT INTO course VALUES ('CS302', 'Operating Systems',               1, 3, 'Core',     'Process management and memory');
INSERT INTO course VALUES ('IT101', 'Web Technologies',                2, 3, 'Core',     'HTML, CSS, JavaScript basics');
INSERT INTO course VALUES ('EC101', 'Digital Electronics',             3, 4, 'Core',     'Logic gates and digital circuits');
INSERT INTO course VALUES ('MA101', 'Engineering Mathematics I',       4, 4, 'Core',     'Calculus and linear algebra');
INSERT INTO course VALUES ('CS401', 'Machine Learning',                1, 3, 'Elective', 'Supervised and unsupervised learning');

INSERT INTO prerequisite VALUES ('CS201', 'CS101', 'D');
INSERT INTO prerequisite VALUES ('CS301', 'CS201', 'C');
INSERT INTO prerequisite VALUES ('CS401', 'CS301', 'B');

INSERT INTO course_offering VALUES (1, 'CS101', 1, 'Fall', '2024-2025', 'AB-301', 60, 'Mon/Wed/Fri 9:00-10:00');
INSERT INTO course_offering VALUES (2, 'CS201', 1, 'Fall', '2024-2025', 'AB-302', 60, 'Tue/Thu 10:00-11:30');
INSERT INTO course_offering VALUES (3, 'CS301', 5, 'Fall', '2024-2025', 'CS-Lab1',55, 'Mon/Wed 11:00-12:30');
INSERT INTO course_offering VALUES (4, 'CS302', 2, 'Fall', '2024-2025', 'AB-401', 50, 'Tue/Thu 2:00-3:30');
INSERT INTO course_offering VALUES (5, 'IT101', 2, 'Fall', '2024-2025', 'IT-Lab2',45, 'Mon/Wed/Fri 10:00-11:00');
INSERT INTO course_offering VALUES (6, 'MA101', 4, 'Fall', '2024-2025', 'AB-101', 70, 'Mon/Tue/Wed/Thu 8:00-9:00');
INSERT INTO course_offering VALUES (7, 'CS401', 1, 'Fall', '2024-2025', 'AB-303', 40, 'Fri 2:00-5:00');

INSERT INTO enrollment VALUES (1,  1, 1, TO_DATE('01-AUG-2024','DD-MON-YYYY'), 'Completed', 'A',  9.0);
INSERT INTO enrollment VALUES (2,  1, 2, TO_DATE('01-AUG-2024','DD-MON-YYYY'), 'Completed', 'B',  8.0);
INSERT INTO enrollment VALUES (3,  1, 6, TO_DATE('01-AUG-2024','DD-MON-YYYY'), 'Completed', 'A+', 10.0);
INSERT INTO enrollment VALUES (4,  2, 1, TO_DATE('01-AUG-2024','DD-MON-YYYY'), 'Completed', 'B',  8.0);
INSERT INTO enrollment VALUES (5,  2, 3, TO_DATE('01-AUG-2024','DD-MON-YYYY'), 'Completed', 'A',  9.0);
INSERT INTO enrollment VALUES (6,  2, 6, TO_DATE('01-AUG-2024','DD-MON-YYYY'), 'Completed', 'C',  7.0);
INSERT INTO enrollment VALUES (7,  3, 1, TO_DATE('01-AUG-2024','DD-MON-YYYY'), 'Completed', 'A+', 10.0);
INSERT INTO enrollment VALUES (8,  3, 2, TO_DATE('01-AUG-2024','DD-MON-YYYY'), 'Completed', 'A',  9.0);
INSERT INTO enrollment VALUES (9,  3, 3, TO_DATE('01-AUG-2024','DD-MON-YYYY'), 'Completed', 'B',  8.0);
INSERT INTO enrollment VALUES (10, 4, 4, TO_DATE('01-AUG-2024','DD-MON-YYYY'), 'Completed', 'A',  9.0);
INSERT INTO enrollment VALUES (11, 4, 5, TO_DATE('01-AUG-2024','DD-MON-YYYY'), 'Completed', 'B',  8.0);
INSERT INTO enrollment VALUES (12, 5, 4, TO_DATE('01-AUG-2024','DD-MON-YYYY'), 'Completed', 'C',  7.0);
INSERT INTO enrollment VALUES (13, 5, 5, TO_DATE('01-AUG-2024','DD-MON-YYYY'), 'Completed', 'A',  9.0);
INSERT INTO enrollment VALUES (14, 6, 1, TO_DATE('01-AUG-2024','DD-MON-YYYY'), 'Enrolled',  NULL, NULL);
INSERT INTO enrollment VALUES (15, 6, 3, TO_DATE('01-AUG-2024','DD-MON-YYYY'), 'Enrolled',  NULL, NULL);
INSERT INTO enrollment VALUES (16, 7, 6, TO_DATE('01-AUG-2024','DD-MON-YYYY'), 'Enrolled',  NULL, NULL);
INSERT INTO enrollment VALUES (17, 8, 1, TO_DATE('01-AUG-2024','DD-MON-YYYY'), 'Enrolled',  NULL, NULL);
INSERT INTO enrollment VALUES (18, 8, 2, TO_DATE('01-AUG-2024','DD-MON-YYYY'), 'Dropped',   NULL, NULL);
INSERT INTO enrollment VALUES (19, 1, 7, TO_DATE('01-AUG-2024','DD-MON-YYYY'), 'Enrolled',  NULL, NULL);

INSERT INTO assignment VALUES (1,  1, 'Lab 1: Hello World',        'Lab',       10,  5,  TO_DATE('20-AUG-2024','DD-MON-YYYY'), 'Basic I/O in C');
INSERT INTO assignment VALUES (2,  1, 'Quiz 1: Basics',            'Quiz',      20,  10, TO_DATE('01-SEP-2024','DD-MON-YYYY'), 'Variables and loops');
INSERT INTO assignment VALUES (3,  1, 'Mid Term Exam',             'MidTerm',   50,  30, TO_DATE('15-SEP-2024','DD-MON-YYYY'), 'Chapters 1-4');
INSERT INTO assignment VALUES (4,  1, 'End Term Exam',             'EndTerm',   100, 55, TO_DATE('15-NOV-2024','DD-MON-YYYY'), 'Full syllabus');
INSERT INTO assignment VALUES (5,  2, 'Assignment 1: Arrays',      'Assignment',20,  10, TO_DATE('25-AUG-2024','DD-MON-YYYY'), 'Array operations');
INSERT INTO assignment VALUES (6,  2, 'Quiz 1: Linked Lists',      'Quiz',      20,  10, TO_DATE('10-SEP-2024','DD-MON-YYYY'), 'Singly and doubly linked lists');
INSERT INTO assignment VALUES (7,  2, 'Mid Term Exam',             'MidTerm',   50,  30, TO_DATE('20-SEP-2024','DD-MON-YYYY'), 'Chapters 1-5');
INSERT INTO assignment VALUES (8,  2, 'End Term Exam',             'EndTerm',   100, 50, TO_DATE('20-NOV-2024','DD-MON-YYYY'), 'Full syllabus');
INSERT INTO assignment VALUES (9,  3, 'Lab 1: SQL Basics',         'Lab',       20,  10, TO_DATE('22-AUG-2024','DD-MON-YYYY'), 'DDL and DML');
INSERT INTO assignment VALUES (10, 3, 'Mid Term Exam',             'MidTerm',   50,  30, TO_DATE('18-SEP-2024','DD-MON-YYYY'), 'SQL and ER Model');
INSERT INTO assignment VALUES (11, 3, 'Mini Project',              'Project',   100, 20, TO_DATE('30-OCT-2024','DD-MON-YYYY'), 'Database mini project');
INSERT INTO assignment VALUES (12, 3, 'End Term Exam',             'EndTerm',   100, 40, TO_DATE('18-NOV-2024','DD-MON-YYYY'), 'Full syllabus');

INSERT INTO submission VALUES (1,  1,  1, TO_DATE('19-AUG-2024','DD-MON-YYYY'), 9.5,  'Excellent work',        5, TO_DATE('21-AUG-2024','DD-MON-YYYY'));
INSERT INTO submission VALUES (2,  2,  1, TO_DATE('01-SEP-2024','DD-MON-YYYY'), 18,   'Good understanding',    1, TO_DATE('03-SEP-2024','DD-MON-YYYY'));
INSERT INTO submission VALUES (3,  3,  1, TO_DATE('15-SEP-2024','DD-MON-YYYY'), 44,   'Well done',             1, TO_DATE('17-SEP-2024','DD-MON-YYYY'));
INSERT INTO submission VALUES (4,  4,  1, TO_DATE('15-NOV-2024','DD-MON-YYYY'), 88,   'Very good',             1, TO_DATE('18-NOV-2024','DD-MON-YYYY'));
INSERT INTO submission VALUES (5,  1,  2, TO_DATE('19-AUG-2024','DD-MON-YYYY'), 8,    'Good effort',           5, TO_DATE('21-AUG-2024','DD-MON-YYYY'));
INSERT INTO submission VALUES (6,  2,  2, TO_DATE('01-SEP-2024','DD-MON-YYYY'), 15,   'Needs improvement',     1, TO_DATE('03-SEP-2024','DD-MON-YYYY'));
INSERT INTO submission VALUES (7,  3,  2, TO_DATE('15-SEP-2024','DD-MON-YYYY'), 38,   'Average performance',   1, TO_DATE('17-SEP-2024','DD-MON-YYYY'));
INSERT INTO submission VALUES (8,  4,  2, TO_DATE('15-NOV-2024','DD-MON-YYYY'), 75,   'Good',                  1, TO_DATE('18-NOV-2024','DD-MON-YYYY'));
INSERT INTO submission VALUES (9,  1,  3, TO_DATE('19-AUG-2024','DD-MON-YYYY'), 10,   'Perfect',               5, TO_DATE('21-AUG-2024','DD-MON-YYYY'));
INSERT INTO submission VALUES (10, 2,  3, TO_DATE('01-SEP-2024','DD-MON-YYYY'), 20,   'Full marks',            1, TO_DATE('03-SEP-2024','DD-MON-YYYY'));
INSERT INTO submission VALUES (11, 5,  1, TO_DATE('24-AUG-2024','DD-MON-YYYY'), 18,   'Good array handling',   1, TO_DATE('26-AUG-2024','DD-MON-YYYY'));
INSERT INTO submission VALUES (12, 6,  1, TO_DATE('09-SEP-2024','DD-MON-YYYY'), 16,   'Solid understanding',   1, TO_DATE('11-SEP-2024','DD-MON-YYYY'));
INSERT INTO submission VALUES (13, 7,  1, TO_DATE('20-SEP-2024','DD-MON-YYYY'), 42,   'Good work',             1, TO_DATE('22-SEP-2024','DD-MON-YYYY'));
INSERT INTO submission VALUES (14, 9,  2, TO_DATE('21-AUG-2024','DD-MON-YYYY'), 18,   'Well structured SQL',   5, TO_DATE('23-AUG-2024','DD-MON-YYYY'));
INSERT INTO submission VALUES (15, 10, 2, TO_DATE('17-SEP-2024','DD-MON-YYYY'), 44,   'Good ER diagram',       5, TO_DATE('19-SEP-2024','DD-MON-YYYY'));
INSERT INTO submission VALUES (16, 11, 2, TO_DATE('29-OCT-2024','DD-MON-YYYY'), 88,   'Impressive project',    5, TO_DATE('31-OCT-2024','DD-MON-YYYY'));
INSERT INTO submission VALUES (17, 12, 2, TO_DATE('17-NOV-2024','DD-MON-YYYY'), 76,   'Good exam performance', 5, TO_DATE('19-NOV-2024','DD-MON-YYYY'));

INSERT INTO attendance VALUES (1,  1,  TO_DATE('05-AUG-2024','DD-MON-YYYY'), 'P', NULL);
INSERT INTO attendance VALUES (2,  1,  TO_DATE('07-AUG-2024','DD-MON-YYYY'), 'P', NULL);
INSERT INTO attendance VALUES (3,  1,  TO_DATE('09-AUG-2024','DD-MON-YYYY'), 'P', NULL);
INSERT INTO attendance VALUES (4,  1,  TO_DATE('12-AUG-2024','DD-MON-YYYY'), 'A', 'Sick');
INSERT INTO attendance VALUES (5,  1,  TO_DATE('14-AUG-2024','DD-MON-YYYY'), 'P', NULL);
INSERT INTO attendance VALUES (6,  1,  TO_DATE('16-AUG-2024','DD-MON-YYYY'), 'P', NULL);
INSERT INTO attendance VALUES (7,  1,  TO_DATE('19-AUG-2024','DD-MON-YYYY'), 'P', NULL);
INSERT INTO attendance VALUES (8,  1,  TO_DATE('21-AUG-2024','DD-MON-YYYY'), 'P', NULL);
INSERT INTO attendance VALUES (9,  1,  TO_DATE('23-AUG-2024','DD-MON-YYYY'), 'L', 'Medical leave');
INSERT INTO attendance VALUES (10, 1,  TO_DATE('26-AUG-2024','DD-MON-YYYY'), 'P', NULL);
INSERT INTO attendance VALUES (11, 4,  TO_DATE('05-AUG-2024','DD-MON-YYYY'), 'P', NULL);
INSERT INTO attendance VALUES (12, 4,  TO_DATE('07-AUG-2024','DD-MON-YYYY'), 'P', NULL);
INSERT INTO attendance VALUES (13, 4,  TO_DATE('09-AUG-2024','DD-MON-YYYY'), 'A', NULL);
INSERT INTO attendance VALUES (14, 4,  TO_DATE('12-AUG-2024','DD-MON-YYYY'), 'P', NULL);
INSERT INTO attendance VALUES (15, 4,  TO_DATE('14-AUG-2024','DD-MON-YYYY'), 'P', NULL);
INSERT INTO attendance VALUES (16, 4,  TO_DATE('16-AUG-2024','DD-MON-YYYY'), 'A', NULL);
INSERT INTO attendance VALUES (17, 4,  TO_DATE('19-AUG-2024','DD-MON-YYYY'), 'P', NULL);
INSERT INTO attendance VALUES (18, 4,  TO_DATE('21-AUG-2024','DD-MON-YYYY'), 'P', NULL);
INSERT INTO attendance VALUES (19, 4,  TO_DATE('23-AUG-2024','DD-MON-YYYY'), 'P', NULL);
INSERT INTO attendance VALUES (20, 4,  TO_DATE('26-AUG-2024','DD-MON-YYYY'), 'P', NULL);
INSERT INTO attendance VALUES (21, 7,  TO_DATE('05-AUG-2024','DD-MON-YYYY'), 'P', NULL);
INSERT INTO attendance VALUES (22, 7,  TO_DATE('07-AUG-2024','DD-MON-YYYY'), 'P', NULL);
INSERT INTO attendance VALUES (23, 7,  TO_DATE('09-AUG-2024','DD-MON-YYYY'), 'P', NULL);
INSERT INTO attendance VALUES (24, 7,  TO_DATE('12-AUG-2024','DD-MON-YYYY'), 'P', NULL);
INSERT INTO attendance VALUES (25, 7,  TO_DATE('14-AUG-2024','DD-MON-YYYY'), 'A', 'Festival');
INSERT INTO attendance VALUES (26, 7,  TO_DATE('16-AUG-2024','DD-MON-YYYY'), 'P', NULL);
INSERT INTO attendance VALUES (27, 7,  TO_DATE('19-AUG-2024','DD-MON-YYYY'), 'P', NULL);
INSERT INTO attendance VALUES (28, 7,  TO_DATE('21-AUG-2024','DD-MON-YYYY'), 'P', NULL);
INSERT INTO attendance VALUES (29, 7,  TO_DATE('23-AUG-2024','DD-MON-YYYY'), 'P', NULL);
INSERT INTO attendance VALUES (30, 7,  TO_DATE('26-AUG-2024','DD-MON-YYYY'), 'P', NULL);

INSERT INTO announcement VALUES (1, 1, 1, 'Welcome to CS101',
    'Welcome to Introduction to Programming. Please install Code::Blocks before the first lab.',
    TO_DATE('01-AUG-2024','DD-MON-YYYY'), 'N');
INSERT INTO announcement VALUES (2, 1, 1, 'Lab 1 Submission Deadline Extended',
    'The deadline for Lab 1 has been extended to 21-AUG-2024.',
    TO_DATE('18-AUG-2024','DD-MON-YYYY'), 'Y');
INSERT INTO announcement VALUES (3, 2, 1, 'DSA Reference Material',
    'Please refer to CLRS Chapter 3 for the upcoming quiz on linked lists.',
    TO_DATE('05-SEP-2024','DD-MON-YYYY'), 'N');
INSERT INTO announcement VALUES (4, 3, 5, 'Mini Project Guidelines Released',
    'The mini project guidelines have been uploaded. Teams of 2-3 students. Deadline: 30-OCT-2024.',
    TO_DATE('01-SEP-2024','DD-MON-YYYY'), 'Y');
INSERT INTO announcement VALUES (5, 3, 5, 'Lab Session Rescheduled',
    'The lab session on 10-SEP has been moved to 12-SEP due to a faculty meeting.',
    TO_DATE('08-SEP-2024','DD-MON-YYYY'), 'Y');

COMMIT;
