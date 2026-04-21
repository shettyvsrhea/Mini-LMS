async function api(endpoint, body) {
    const res = await fetch('/api/' + endpoint, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(body)
    });
    return res.json();
}

async function doConnect() {
    const btn = document.querySelector('.login-btn');
    btn.querySelector('.btn-text').classList.add('hidden');
    btn.querySelector('.btn-loader').classList.remove('hidden');
    const user = v('db-user'), password = v('db-pass'), connectString = v('db-dsn');
    const result = await api('connect', { user, password, connectString });
    if (result.success) {
        document.getElementById('login-screen').classList.add('hidden');
        document.getElementById('main-screen').classList.remove('hidden');
        loadSection('dashboard');
    } else {
        document.getElementById('login-error').textContent = result.error;
        btn.querySelector('.btn-text').classList.remove('hidden');
        btn.querySelector('.btn-loader').classList.add('hidden');
    }
}

async function doDisconnect() {
    await api('disconnect', {});
    document.getElementById('main-screen').classList.add('hidden');
    document.getElementById('login-screen').classList.remove('hidden');
    document.getElementById('login-error').textContent = '';
    const btn = document.querySelector('.login-btn');
    btn.querySelector('.btn-text').classList.remove('hidden');
    btn.querySelector('.btn-loader').classList.add('hidden');
}

function setActiveNav(section) {
    document.querySelectorAll('.nav-link').forEach(l => l.classList.remove('active'));
    const link = document.querySelector(`.nav-link[data-section="${section}"]`);
    if (link) link.classList.add('active');
}

function showLoader() { document.getElementById('page-loader').classList.remove('hidden'); }
function hideLoader() { document.getElementById('page-loader').classList.add('hidden'); }

async function loadSection(section) {
    setActiveNav(section);
    showLoader();
    const body = document.getElementById('page-body');
    body.style.opacity = '0';
    body.style.transform = 'translateY(8px)';

    switch(section) {
        case 'dashboard': await renderDashboard(body); break;
        case 'students': await renderStudents(body); break;
        case 'instructors': await renderInstructors(body); break;
        case 'courses': await renderCourses(body); break;
        case 'offerings': await renderOfferings(body); break;
        case 'enrollments': await renderEnrollments(body); break;
        case 'assignments': await renderAssignments(body); break;
        case 'submissions': await renderSubmissions(body); break;
        case 'attendance': await renderAttendance(body); break;
        case 'announcements': await renderAnnouncements(body); break;
    }

    hideLoader();
    requestAnimationFrame(() => {
        body.style.transition = 'opacity 0.35s ease, transform 0.35s ease';
        body.style.opacity = '1';
        body.style.transform = 'translateY(0)';
    });
}

function buildTable(meta, rows) {
    if (!meta || !rows || rows.length === 0) {
        return '<div class="table-wrap"><div class="empty-state"><i class="fas fa-inbox"></i><p>No records found</p></div></div>';
    }
    let html = '<div class="table-wrap"><table><thead><tr>';
    meta.forEach(m => html += `<th>${m.name.replace(/_/g, ' ')}</th>`);
    html += '</tr></thead><tbody>';
    rows.forEach(r => {
        html += '<tr>';
        meta.forEach(m => {
            let val = r[m.name] != null ? r[m.name] : '<span style="color:var(--text-muted)">—</span>';
            html += `<td>${val}</td>`;
        });
        html += '</tr>';
    });
    html += '</tbody></table></div>';
    return html;
}

function toast(text, isError) {
    let container = document.querySelector('.toast-container');
    if (!container) {
        container = document.createElement('div');
        container.className = 'toast-container';
        document.body.appendChild(container);
    }
    const el = document.createElement('div');
    el.className = `toast ${isError ? 'toast-err' : 'toast-ok'}`;
    el.innerHTML = `<i class="fas ${isError ? 'fa-exclamation-circle' : 'fa-check-circle'}"></i>${text}`;
    container.appendChild(el);
    setTimeout(() => {
        el.classList.add('removing');
        setTimeout(() => el.remove(), 300);
    }, 3500);
}

function sectionHeader(icon, iconClass, title, subtitle) {
    return `<div class="section-header">
        <div class="section-icon ${iconClass}"><i class="fas ${icon}"></i></div>
        <div><div class="section-title">${title}</div><div class="section-subtitle">${subtitle}</div></div>
    </div>`;
}

const cardColors = [
    { bg: 'rgba(99,102,241,0.12)', color: '#818cf8', icon: 'fa-user-graduate' },
    { bg: 'rgba(34,197,94,0.12)', color: '#4ade80', icon: 'fa-chalkboard-teacher' },
    { bg: 'rgba(245,158,11,0.12)', color: '#fbbf24', icon: 'fa-book' },
    { bg: 'rgba(236,72,153,0.12)', color: '#f472b6', icon: 'fa-calendar-alt' },
    { bg: 'rgba(59,130,246,0.12)', color: '#60a5fa', icon: 'fa-clipboard-list' },
    { bg: 'rgba(168,85,247,0.12)', color: '#c084fc', icon: 'fa-tasks' },
    { bg: 'rgba(20,184,166,0.12)', color: '#2dd4bf', icon: 'fa-file-upload' },
    { bg: 'rgba(251,146,60,0.12)', color: '#fb923c', icon: 'fa-bullhorn' },
];

async function renderDashboard(el) {
    const queries = [
        { label: 'Students', sql: 'SELECT COUNT(*) AS cnt FROM student' },
        { label: 'Instructors', sql: 'SELECT COUNT(*) AS cnt FROM instructor' },
        { label: 'Courses', sql: 'SELECT COUNT(*) AS cnt FROM course' },
        { label: 'Offerings', sql: 'SELECT COUNT(*) AS cnt FROM course_offering' },
        { label: 'Enrollments', sql: 'SELECT COUNT(*) AS cnt FROM enrollment' },
        { label: 'Assignments', sql: 'SELECT COUNT(*) AS cnt FROM assignment' },
        { label: 'Submissions', sql: 'SELECT COUNT(*) AS cnt FROM submission' },
        { label: 'Announcements', sql: 'SELECT COUNT(*) AS cnt FROM announcement' }
    ];

    let cards = '';
    for (let i = 0; i < queries.length; i++) {
        const q = queries[i];
        const c = cardColors[i];
        const res = await api('query', { sql: q.sql });
        const val = res.success && res.rows.length > 0 ? res.rows[0].CNT : '?';
        cards += `<div class="card stagger-${i+1}">
            <div class="icon-wrap" style="background:${c.bg};color:${c.color}"><i class="fas ${c.icon}"></i></div>
            <div class="value">${val}</div>
            <div class="label">${q.label}</div>
        </div>`;
    }

    el.innerHTML = `
        ${sectionHeader('fa-chart-pie', 'purple', 'Dashboard', 'Overview of your LMS data')}
        <div class="cards-grid">${cards}</div>`;
}

async function renderStudents(el) {
    const res = await api('query', {
        sql: 'SELECT student_id, reg_no, name, email, gender, dob, dept_id, batch_year FROM student ORDER BY student_id'
    });
    el.innerHTML = `
        ${sectionHeader('fa-user-graduate', 'purple', 'Students', 'Manage student records')}
        ${buildTable(res.meta, res.rows)}
        <div class="form-panel">
            <div class="form-panel-title"><i class="fas fa-plus-circle"></i> Add New Student</div>
            <div class="form-row">
                <input id="s-reg" placeholder="Reg No">
                <input id="s-name" placeholder="Name">
                <input id="s-email" placeholder="Email">
                <input id="s-gender" placeholder="M/F/O" style="width:70px">
                <input id="s-dob" placeholder="DD-MON-YYYY" style="width:140px">
                <input id="s-dept" placeholder="Dept ID" style="width:80px">
                <input id="s-batch" placeholder="Batch" style="width:80px">
                <button class="btn btn-primary" onclick="addStudent()"><i class="fas fa-plus"></i> Add</button>
            </div>
        </div>
        <div class="form-panel">
            <div class="form-panel-title"><i class="fas fa-trash-alt"></i> Delete Student</div>
            <div class="form-row">
                <input id="s-del-id" placeholder="Student ID" style="width:140px">
                <button class="btn btn-danger" onclick="deleteStudent()"><i class="fas fa-trash"></i> Delete</button>
            </div>
        </div>`;
}

async function addStudent() {
    const sql = `BEGIN add_student('${v('s-reg')}','${v('s-name')}','${v('s-email')}','${v('s-gender')}',TO_DATE('${v('s-dob')}','DD-MON-YYYY'),${v('s-dept')},${v('s-batch')}); END;`;
    const res = await api('execute', { sql });
    if (res.success) { toast('Student added successfully'); loadSection('students'); }
    else toast(res.error, true);
}

async function deleteStudent() {
    const res = await api('execute', { sql: `DELETE FROM student WHERE student_id = ${v('s-del-id')}` });
    if (res.success) { toast('Student deleted'); loadSection('students'); }
    else toast(res.error, true);
}

async function renderInstructors(el) {
    const res = await api('query', {
        sql: 'SELECT instructor_id, name, email, dept_id, designation, date_joined FROM instructor ORDER BY instructor_id'
    });
    el.innerHTML = `
        ${sectionHeader('fa-chalkboard-teacher', 'green', 'Instructors', 'Manage instructor records')}
        ${buildTable(res.meta, res.rows)}
        <div class="form-panel">
            <div class="form-panel-title"><i class="fas fa-plus-circle"></i> Add New Instructor</div>
            <div class="form-row">
                <input id="i-id" placeholder="ID" style="width:70px">
                <input id="i-name" placeholder="Name">
                <input id="i-email" placeholder="Email">
                <input id="i-dept" placeholder="Dept ID" style="width:80px">
                <input id="i-desig" placeholder="Designation">
                <button class="btn btn-primary" onclick="addInstructor()"><i class="fas fa-plus"></i> Add</button>
            </div>
        </div>
        <div class="form-panel">
            <div class="form-panel-title"><i class="fas fa-trash-alt"></i> Delete Instructor</div>
            <div class="form-row">
                <input id="i-del-id" placeholder="Instructor ID" style="width:140px">
                <button class="btn btn-danger" onclick="deleteInstructor()"><i class="fas fa-trash"></i> Delete</button>
            </div>
        </div>`;
}

async function addInstructor() {
    const sql = `INSERT INTO instructor VALUES (${v('i-id')},'${v('i-name')}','${v('i-email')}',${v('i-dept')},'${v('i-desig')}',SYSDATE)`;
    const res = await api('execute', { sql });
    if (res.success) { toast('Instructor added successfully'); loadSection('instructors'); }
    else toast(res.error, true);
}

async function deleteInstructor() {
    const res = await api('execute', { sql: `DELETE FROM instructor WHERE instructor_id = ${v('i-del-id')}` });
    if (res.success) { toast('Instructor deleted'); loadSection('instructors'); }
    else toast(res.error, true);
}

async function renderCourses(el) {
    const res = await api('query', {
        sql: 'SELECT course_id, title, dept_id, credits, course_type, description FROM course ORDER BY course_id'
    });
    el.innerHTML = `
        ${sectionHeader('fa-book', 'amber', 'Courses', 'All available courses')}
        ${buildTable(res.meta, res.rows)}
        <div class="form-panel">
            <div class="form-panel-title"><i class="fas fa-plus-circle"></i> Add Course</div>
            <div class="form-row">
                <input id="c-id" placeholder="Course ID (e.g. CS501)" style="width:130px">
                <input id="c-title" placeholder="Title">
                <input id="c-dept" placeholder="Dept ID" style="width:80px">
                <input id="c-credits" placeholder="Credits" style="width:80px">
                <input id="c-type" placeholder="Core/Elective/Lab/Project" style="width:180px">
                <input id="c-desc" placeholder="Description" style="width:220px">
                <button class="btn btn-primary" onclick="addCourse()"><i class="fas fa-plus"></i> Add</button>
            </div>
        </div>
        <div class="form-panel">
            <div class="form-panel-title"><i class="fas fa-pen"></i> Edit Course</div>
            <div class="form-row">
                <input id="c-eid" placeholder="Course ID" style="width:130px">
                <input id="c-etitle" placeholder="New Title">
                <input id="c-ecredits" placeholder="New Credits" style="width:100px">
                <input id="c-etype" placeholder="New Type" style="width:150px">
                <input id="c-edesc" placeholder="New Description" style="width:220px">
                <button class="btn btn-success" onclick="editCourse()"><i class="fas fa-check"></i> Update</button>
            </div>
        </div>`;
}

async function addCourse() {
    const sql = `INSERT INTO course VALUES ('${v('c-id')}', '${v('c-title')}', ${v('c-dept')}, ${v('c-credits')}, '${v('c-type')}', '${v('c-desc')}')`;
    const res = await api('execute', { sql });
    if (res.success) { toast('Course added'); loadSection('courses'); }
    else toast(res.error, true);
}

async function editCourse() {
    const sql = `UPDATE course SET title = '${v('c-etitle')}', credits = ${v('c-ecredits')}, course_type = '${v('c-etype')}', description = '${v('c-edesc')}' WHERE course_id = '${v('c-eid')}'`;
    const res = await api('execute', { sql });
    if (res.success) { toast('Course updated'); loadSection('courses'); }
    else toast(res.error, true);
}

async function renderOfferings(el) {
    const res = await api('query', {
        sql: `SELECT co.offering_id, c.title AS COURSE, i.name AS INSTRUCTOR, co.semester AS SEMESTER,
                     co.academic_year AS YEAR, co.room_no AS ROOM, co.max_students AS MAX_SEATS, co.schedule AS SCHEDULE
              FROM course_offering co
                  JOIN course c ON co.course_id = c.course_id
                  JOIN instructor i ON co.instructor_id = i.instructor_id
              ORDER BY co.offering_id`
    });
    el.innerHTML = `
        ${sectionHeader('fa-calendar-alt', 'red', 'Course Offerings', 'Current semester offerings')}
        ${buildTable(res.meta, res.rows)}
        <div class="form-panel">
            <div class="form-panel-title"><i class="fas fa-plus-circle"></i> Add Offering</div>
            <div class="form-row">
                <input id="o-id" placeholder="Offering ID" style="width:110px">
                <input id="o-cid" placeholder="Course ID" style="width:100px">
                <input id="o-iid" placeholder="Instructor ID" style="width:120px">
                <input id="o-sem" placeholder="Spring/Summer/Fall/Winter" style="width:180px">
                <input id="o-year" placeholder="e.g. 2024-2025" style="width:120px">
                <input id="o-room" placeholder="Room No" style="width:100px">
                <input id="o-max" placeholder="Max Students" style="width:120px">
                <input id="o-sched" placeholder="Schedule" style="width:200px">
                <button class="btn btn-primary" onclick="addOffering()"><i class="fas fa-plus"></i> Add</button>
            </div>
        </div>
        <div class="form-panel">
            <div class="form-panel-title"><i class="fas fa-pen"></i> Edit Offering</div>
            <div class="form-row">
                <input id="o-eid" placeholder="Offering ID" style="width:110px">
                <input id="o-eroom" placeholder="New Room" style="width:100px">
                <input id="o-emax" placeholder="New Max Students" style="width:130px">
                <input id="o-esched" placeholder="New Schedule" style="width:200px">
                <button class="btn btn-success" onclick="editOffering()"><i class="fas fa-check"></i> Update</button>
            </div>
        </div>`;
}

async function addOffering() {
    const sql = `INSERT INTO course_offering VALUES (${v('o-id')}, '${v('o-cid')}', ${v('o-iid')}, '${v('o-sem')}', '${v('o-year')}', '${v('o-room')}', ${v('o-max')}, '${v('o-sched')}')`;
    const res = await api('execute', { sql });
    if (res.success) { toast('Offering added'); loadSection('offerings'); }
    else toast(res.error, true);
}

async function editOffering() {
    const sql = `UPDATE course_offering SET room_no = '${v('o-eroom')}', max_students = ${v('o-emax')}, schedule = '${v('o-esched')}' WHERE offering_id = ${v('o-eid')}`;
    const res = await api('execute', { sql });
    if (res.success) { toast('Offering updated'); loadSection('offerings'); }
    else toast(res.error, true);
}

async function renderEnrollments(el) {
    const res = await api('query', {
        sql: `SELECT e.enrollment_id, s.name AS STUDENT, c.title AS COURSE,
              e.enroll_date AS ENROLLED_ON, e.status, e.final_grade AS GRADE, e.grade_points AS GP
              FROM enrollment e
              JOIN student s ON e.student_id = s.student_id
              JOIN course_offering co ON e.offering_id = co.offering_id
              JOIN course c ON co.course_id = c.course_id
              ORDER BY e.enrollment_id`
    });
    el.innerHTML = `
        ${sectionHeader('fa-clipboard-list', 'purple', 'Enrollments', 'Student enrollment records')}
        ${buildTable(res.meta, res.rows)}
        <div class="form-panel">
            <div class="form-panel-title"><i class="fas fa-user-plus"></i> Enroll Student</div>
            <div class="form-row">
                <input id="e-sid" placeholder="Student ID" style="width:130px">
                <input id="e-oid" placeholder="Offering ID" style="width:130px">
                <button class="btn btn-primary" onclick="enrollStudent()"><i class="fas fa-plus"></i> Enroll</button>
            </div>
        </div>
        <div class="form-panel">
            <div class="form-panel-title"><i class="fas fa-pen"></i> Update Grade</div>
            <div class="form-row">
                <input id="e-eid" placeholder="Enrollment ID" style="width:130px">
                <input id="e-grade" placeholder="Grade (A+/A/B/C/D/F)" style="width:170px">
                <input id="e-gp" placeholder="Grade Points" style="width:130px">
                <button class="btn btn-success" onclick="updateGrade()"><i class="fas fa-check"></i> Update</button>
            </div>
        </div>`;
}

async function enrollStudent() {
    const sql = `BEGIN add_enrollment(${v('e-sid')}, ${v('e-oid')}); END;`;
    const res = await api('execute', { sql });
    if (res.success) { toast('Student enrolled successfully'); loadSection('enrollments'); }
    else toast(res.error, true);
}

async function updateGrade() {
    const sql = `UPDATE enrollment SET final_grade = '${v('e-grade')}', grade_points = ${v('e-gp')}, status = 'Completed' WHERE enrollment_id = ${v('e-eid')}`;
    const res = await api('execute', { sql });
    if (res.success) { toast('Grade updated'); loadSection('enrollments'); }
    else toast(res.error, true);
}

async function renderAssignments(el) {
    const res = await api('query', {
        sql: `SELECT a.assignment_id, c.title AS COURSE, a.title AS ASSIGNMENT, a.assignment_type AS TYPE,
                     a.max_marks AS MAX_MARKS, a.weightage, a.due_date
              FROM assignment a
                       JOIN course_offering co ON a.offering_id = co.offering_id
                       JOIN course c ON co.course_id = c.course_id
              ORDER BY a.assignment_id`
    });
    el.innerHTML = `
        ${sectionHeader('fa-tasks', 'amber', 'Assignments', 'All course assignments')}
        ${buildTable(res.meta, res.rows)}
        <div class="form-panel">
            <div class="form-panel-title"><i class="fas fa-plus-circle"></i> Add New Assignment</div>
            <div class="form-row">
                <input id="a-oid" placeholder="Offering ID" style="width:110px">
                <input id="a-title" placeholder="Title">
                <input id="a-type" placeholder="Type (Lab/Quiz/MidTerm/EndTerm/Project/Assignment)" style="width:160px">
                <input id="a-marks" placeholder="Max Marks" style="width:100px">
                <input id="a-weight" placeholder="Weightage" style="width:100px">
                <input id="a-due" placeholder="DD-MON-YYYY" style="width:140px">
                <button class="btn btn-primary" onclick="addAssignment()"><i class="fas fa-plus"></i> Add</button>
            </div>
        </div>`;
}

async function addAssignment() {
    const sql = `INSERT INTO assignment VALUES (assignment_seq.NEXTVAL, ${v('a-oid')}, '${v('a-title')}', '${v('a-type')}', ${v('a-marks')}, ${v('a-weight')}, TO_DATE('${v('a-due')}','DD-MON-YYYY'), NULL)`;
    const res = await api('execute', { sql });
    if (res.success) { toast('Assignment added successfully'); loadSection('assignments'); }
    else toast(res.error, true);
}

async function renderSubmissions(el) {
    const res = await api('query', {
        sql: `SELECT sub.submission_id, s.name AS STUDENT, a.title AS ASSIGNMENT,
              sub.submit_date AS SUBMITTED, sub.marks_obtained AS MARKS, sub.feedback AS FEEDBACK
              FROM submission sub
              JOIN student s ON sub.student_id = s.student_id
              JOIN assignment a ON sub.assignment_id = a.assignment_id
              ORDER BY sub.submission_id`
    });
    el.innerHTML = `
        ${sectionHeader('fa-file-upload', 'green', 'Submissions', 'Student submission records')}
        ${buildTable(res.meta, res.rows)};
    <div class="form-panel">
        <div class="form-panel-title"><i class="fas fa-plus-circle"></i> Add New Submission</div>
        <div class="form-row">
            <input id="sub-aid" placeholder="Assignment ID" style="width:130px">
                <input id="sub-sid" placeholder="Student ID" style="width:130px">
                    <input id="sub-date" placeholder="DD-MON-YYYY" style="width:140px">
                        <input id="sub-marks" placeholder="Marks" style="width:90px">
                            <input id="sub-fb" placeholder="Feedback">
                                <input id="sub-grader" placeholder="Graded By (Instr ID)" style="width:150px">
                                    <button class="btn btn-primary" onclick="addSubmission()"><i class="fas fa-plus"></i> Add</button>
        </div>
    </div>`;
}

async function addSubmission() {
    const sql = `INSERT INTO submission VALUES (submission_seq.NEXTVAL, ${v('sub-aid')}, ${v('sub-sid')}, TO_DATE('${v('sub-date')}','DD-MON-YYYY'), ${v('sub-marks')}, '${v('sub-fb')}', ${v('sub-grader')}, SYSDATE)`;
    const res = await api('execute', { sql });
    if (res.success) { toast('Submission added successfully'); loadSection('submissions'); }
    else toast(res.error, true);
}

async function renderAttendance(el) {
    el.innerHTML = `
        ${sectionHeader('fa-clipboard-check', 'purple', 'Attendance', 'Look up student attendance records')}
        <div class="search-box">
            <div class="search-wrap">
                <i class="fas fa-search"></i>
                <input id="att-sid" placeholder="Enter Student ID">
            </div>
            <button class="btn btn-primary" onclick="searchAttendance()"><i class="fas fa-search"></i> Search</button>
        </div>
        <div id="att-info" class="info-badges"></div>
        <div id="att-table"></div>`;
}

async function searchAttendance() {
    const sid = v('att-sid');
    if (!sid) return;

    const cgpaRes = await api('query', { sql: `SELECT get_student_cgpa(${sid}) AS CGPA FROM dual` });
    let cgpa = cgpaRes.success && cgpaRes.rows.length > 0 ? cgpaRes.rows[0].CGPA : 'N/A';

    const summRes = await api('query', {
        sql: `SELECT offering_id, total_classes, present, absent, leave, attendance_pct FROM attendance_summary WHERE student_id = ${sid}`
    });

    let info = `<span class="info-badge"><i class="fas fa-star"></i>&nbsp; CGPA: ${cgpa}</span>`;
    if (summRes.success && summRes.rows.length > 0) {
        summRes.rows.forEach(r => {
            let pct = parseFloat(r.ATTENDANCE_PCT);
            let icon = pct >= 75 ? 'fa-check-circle' : 'fa-exclamation-triangle';
            info += `<span class="info-badge"><i class="fas ${icon}"></i>&nbsp; Offering ${r.OFFERING_ID}: ${pct}%</span>`;
        });
    }
    document.getElementById('att-info').innerHTML = info;

    const detRes = await api('query', {
        sql: `SELECT e.offering_id AS OFFERING, c.title AS COURSE, att.class_date AS CLASS_DATE, att.status, att.remarks
              FROM attendance att
              JOIN enrollment e ON att.enrollment_id = e.enrollment_id
              JOIN course_offering co ON e.offering_id = co.offering_id
              JOIN course c ON co.course_id = c.course_id
              WHERE e.student_id = ${sid} ORDER BY att.class_date`
    });
    document.getElementById('att-table').innerHTML = buildTable(detRes.meta, detRes.rows);
}

async function renderAnnouncements(el) {
    const res = await api('query', {
        sql: `SELECT ann.announcement_id AS ID, c.title AS COURSE, i.name AS POSTED_BY,
                     ann.title AS TITLE, ann.content AS CONTENT, ann.posted_on AS POSTED_ON,
                     CASE ann.is_urgent WHEN 'Y' THEN 'YES' ELSE 'NO' END AS URGENT
              FROM announcement ann
                       JOIN course_offering co ON ann.offering_id = co.offering_id
                       JOIN course c ON co.course_id = c.course_id
                       JOIN instructor i ON ann.posted_by = i.instructor_id
              ORDER BY ann.posted_on DESC`
    });
    el.innerHTML = `
        ${sectionHeader('fa-bullhorn', 'red', 'Announcements', 'Course announcements and notices')}
        ${buildTable(res.meta, res.rows)}
        <div class="form-panel">
            <div class="form-panel-title"><i class="fas fa-plus-circle"></i> Add Announcement</div>
            <div class="form-row">
                <input id="ann-oid" placeholder="Offering ID" style="width:110px">
                <input id="ann-by" placeholder="Instructor ID" style="width:120px">
                <input id="ann-title" placeholder="Title">
                <input id="ann-content" placeholder="Content" style="width:250px">
                <input id="ann-urgent" placeholder="Urgent? (Y/N)" style="width:120px">
                <button class="btn btn-primary" onclick="addAnnouncement()"><i class="fas fa-plus"></i> Add</button>
            </div>
        </div>
        <div class="form-panel">
            <div class="form-panel-title"><i class="fas fa-pen"></i> Edit Announcement</div>
            <div class="form-row">
                <input id="ann-eid" placeholder="Announcement ID" style="width:140px">
                <input id="ann-etitle" placeholder="New Title">
                <input id="ann-econtent" placeholder="New Content" style="width:250px">
                <input id="ann-eurgent" placeholder="Urgent? (Y/N)" style="width:120px">
                <button class="btn btn-success" onclick="editAnnouncement()"><i class="fas fa-check"></i> Update</button>
            </div>
        </div>`;
}

async function addAnnouncement() {
    const sql = `INSERT INTO announcement VALUES (announcement_seq.NEXTVAL, ${v('ann-oid')}, ${v('ann-by')}, '${v('ann-title')}', '${v('ann-content')}', SYSDATE, '${v('ann-urgent')}')`;
    const res = await api('execute', { sql });
    if (res.success) { toast('Announcement added'); loadSection('announcements'); }
    else toast(res.error, true);
}

async function editAnnouncement() {
    const sql = `UPDATE announcement SET title = '${v('ann-etitle')}', content = '${v('ann-econtent')}', is_urgent = '${v('ann-eurgent')}' WHERE announcement_id = ${v('ann-eid')}`;
    const res = await api('execute', { sql });
    if (res.success) { toast('Announcement updated'); loadSection('announcements'); }
    else toast(res.error, true);
}

function v(id) { return document.getElementById(id).value.trim(); }