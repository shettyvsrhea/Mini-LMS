# 📚 Mini Learning Management System (LMS)

A relational database project built for **Database Systems Lab [CSE-2241]** at **Manipal Institute of Technology, Manipal**.

---


## 📌 Overview

The Mini LMS is a structured relational database system designed to manage academic data for educational institutions. It centralizes records for students, instructors, courses, enrollments, assignments, and grades — ensuring consistency, reducing redundancy, and maintaining data integrity through well-defined constraints and relationships.

---

## 🚩 Problem Statement

Educational institutions deal with large volumes of interconnected academic data. Manual or poorly structured systems often result in:
- Inconsistent or duplicate records
- Incorrect prerequisite validation
- Grade miscalculations
- Difficulty generating academic reports

This project addresses these issues by designing a normalized relational database with enforced constraints and automated computations.

---

## ✨ Features

- **Course Management** — Add and manage courses, credits, and semester offerings
- **Prerequisite Validation** — Enforces prerequisite completion before enrollment
- **Enrollment Control** — Prevents duplicate enrollments and respects capacity limits
- **Assignment & Grading** — Instructors can create assignments with weightages; marks are recorded per student
- **Automated Grade Computation** — Final grades and GPA/CGPA calculated systematically
- **Academic Reporting** — Supports analytical queries for performance evaluation

---

## 🗄️ Data Model

The database manages the following entities:

- **Students** — Personal and academic details
- **Instructors** — Faculty information
- **Courses** — Course details including credits and prerequisites
- **Course Offerings** — Links courses with instructors for specific semesters
- **Enrollments** — Many-to-many relationship between students and course offerings
- **Assignments** — Weightage and maximum marks per course
- **Submissions** — Student marks for each assignment

---

## ⚙️ Constraints Enforced

- Credits must be positive values
- Assignment weightages must total 100%
- No duplicate enrollments allowed
- Prerequisites must be completed before enrollment
- Referential integrity maintained across all entities

---

## 🛠️ Tech Stack

- **Database:** SQL (Relational Database)
- **Course:** CSE-2241 Database Systems Lab

---

## 🚀 Getting Started

1. Clone the repository
   ```bash
   git clone https://github.com/shettyvsrhea/Mini-LMS.git
   cd Mini-LMS
   ```

2. Import the SQL schema into your database (MySQL / PostgreSQL)
   ```bash
   mysql -u root -p < schema.sql
   ```

3. Load sample data (if provided)
   ```bash
   mysql -u root -p < data.sql
   ```

---

## 📄 License

This project was developed as part of an academic lab assignment at MIT Manipal.
