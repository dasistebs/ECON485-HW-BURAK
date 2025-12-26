-- ECON485 – Homework 2 (Burak version)
-- Simple registration system using StudentRecords / CatalogCourses / OfferedSections / RegistrationsBasic

CREATE DATABASE IF NOT EXISTS econ485_burak;
USE econ485_burak;

-------------------------------------------------
-- Part 1a – Create base tables
-------------------------------------------------

CREATE TABLE StudentRecords (
  StudentID   INT PRIMARY KEY,
  UniversityID VARCHAR(20) NOT NULL,
  FirstName   VARCHAR(50) NOT NULL,
  LastName    VARCHAR(50) NOT NULL,
  ProgramCode VARCHAR(50),
  CohortYear  INT
);

CREATE TABLE CatalogCourses (
  CatalogID    INT PRIMARY KEY,
  CourseCode   VARCHAR(20) NOT NULL,
  CourseName   VARCHAR(100) NOT NULL,
  LocalCredits INT,
  EctsCredits  INT
);

CREATE TABLE OfferedSections (
  OfferedID     INT PRIMARY KEY,
  CatalogID     INT NOT NULL,
  TermLabel     VARCHAR(10) NOT NULL,
  YearValue     INT NOT NULL,
  SectionLabel  VARCHAR(10) NOT NULL,
  CapacityLimit INT,
  MainInstructor VARCHAR(100),
  CONSTRAINT fk_offered_catalog
    FOREIGN KEY (CatalogID) REFERENCES CatalogCourses(CatalogID)
);

CREATE TABLE RegistrationsBasic (
  RegID        INT PRIMARY KEY,
  StudentID    INT NOT NULL,
  OfferedID    INT NOT NULL,
  RegisteredOn DATE,
  CONSTRAINT fk_reg_student
    FOREIGN KEY (StudentID) REFERENCES StudentRecords(StudentID),
  CONSTRAINT fk_reg_offered
    FOREIGN KEY (OfferedID) REFERENCES OfferedSections(OfferedID)
);

-------------------------------------------------
-- Part 1b – Insert example data
-- 3 courses, 4 sections, 10 students, 15 registrations
-------------------------------------------------

INSERT INTO CatalogCourses (CatalogID, CourseCode, CourseName, LocalCredits, EctsCredits) VALUES
  (201, 'ECON120', 'Economic Thinking',          3, 6),
  (202, 'ECON230', 'Applied Microeconomics',     3, 6),
  (203, 'MATH140', 'Introductory Calculus',      4, 7);

INSERT INTO OfferedSections (OfferedID, CatalogID, TermLabel, YearValue, SectionLabel, CapacityLimit, MainInstructor) VALUES
  (2001, 201, 'Fall', 2025, '01', 55, 'Dr. Aksoy'),
  (2002, 201, 'Fall', 2025, '02', 55, 'Dr. Tekin'),
  (2003, 202, 'Fall', 2025, '01', 40, 'Dr. Yaman'),
  (2004, 203, 'Fall', 2025, '01', 45, 'Dr. Durmaz');

INSERT INTO StudentRecords (StudentID, UniversityID, FirstName, LastName, ProgramCode, CohortYear) VALUES
  (1,  '20252001', 'Burak',   'Ozdemir',  'Economics',     2025),
  (2,  '20252002', 'Elif',    'Cetin',    'Economics',     2025),
  (3,  '20252003', 'Merve',   'Tan',      'Business',      2024),
  (4,  '20252004', 'Kerem',   'Sari',     'Economics',     2023),
  (5,  '20252005', 'Ozgur',   'Dal',      'Mathematics',   2025),
  (6,  '20252006', 'Deniz',   'Boz',      'Economics',     2024),
  (7,  '20252007', 'Eren',    'Kiran',    'Computer Eng',  2023),
  (8,  '20252008', 'Yasmin',  'Acar',     'Economics',     2022),
  (9,  '20252009', 'Kaan',    'Ersoy',    'Business',      2024),
  (10, '20252010', 'Selma',   'Ucar',     'Economics',     2025);

INSERT INTO RegistrationsBasic (RegID, StudentID, OfferedID, RegisteredOn) VALUES
  (1,  1, 2001, '2025-09-01'),
  (2,  1, 2004, '2025-09-01'),
  (3,  2, 2001, '2025-09-01'),
  (4,  2, 2003, '2025-09-01'),
  (5,  3, 2001, '2025-09-02'),
  (6,  3, 2004, '2025-09-02'),
  (7,  4, 2002, '2025-09-02'),
  (8,  4, 2003, '2025-09-02'),
  (9,  5, 2004, '2025-09-02'),
  (10, 6, 2001, '2025-09-03'),
  (11, 7, 2002, '2025-09-03'),
  (12, 8, 2003, '2025-09-03'),
  (13, 9, 2004, '2025-09-03'),
  (14,10, 2001, '2025-09-03'),
  (15,10, 2003, '2025-09-03');

-------------------------------------------------
-- Part 1c – Demonstrate add and drop
-------------------------------------------------

-- Add actions
-- Burak (StudentID = 1) ECON230 (OfferedID 2003) adds
INSERT INTO RegistrationsBasic (RegID, StudentID, OfferedID, RegisteredOn)
VALUES (16, 1, 2003, '2025-09-04');

-- Elif (StudentID = 2) MATH140 (OfferedID 2004) adds
INSERT INTO RegistrationsBasic (RegID, StudentID, OfferedID, RegisteredOn)
VALUES (17, 2, 2004, '2025-09-04');

-- Merve (StudentID = 3) ECON120 second section (OfferedID 2002) adds
INSERT INTO RegistrationsBasic (RegID, StudentID, OfferedID, RegisteredOn)
VALUES (18, 3, 2002, '2025-09-04');

-- Drop actions
-- Burak drops Calculus (RegID = 2)
DELETE FROM RegistrationsBasic
WHERE RegID = 2;

-- Elif drops Applied Microeconomics (RegID = 4)
DELETE FROM RegistrationsBasic
WHERE RegID = 4;

-- Merve drops Calculus (RegID = 6)
DELETE FROM RegistrationsBasic
WHERE RegID = 6;

-- Optional check of current registrations
SELECT * FROM RegistrationsBasic ORDER BY RegID;

-------------------------------------------------
-- Part 1d – Final registration report (JOIN)
-------------------------------------------------

SELECT
  s.FirstName,
  s.LastName,
  c.CourseCode,
  o.SectionLabel,
  o.TermLabel,
  o.YearValue,
  r.RegisteredOn
FROM RegistrationsBasic r
JOIN StudentRecords  s ON r.StudentID = s.StudentID
JOIN OfferedSections o ON r.OfferedID = o.OfferedID
JOIN CatalogCourses  c ON o.CatalogID = c.CatalogID
ORDER BY s.LastName, s.FirstName, c.CourseCode, o.SectionLabel;

-------------------------------------------------
-- Part 2 – Prerequisite support
-------------------------------------------------

CREATE TABLE CoursePrerequisites (
  PrereqID         INT PRIMARY KEY,
  TargetCatalogID  INT NOT NULL,
  RequiredCatalogID INT NOT NULL,
  MinimumGrade     CHAR(2) NOT NULL,
  CONSTRAINT fk_prereq_target
    FOREIGN KEY (TargetCatalogID)  REFERENCES CatalogCourses(CatalogID),
  CONSTRAINT fk_prereq_required
    FOREIGN KEY (RequiredCatalogID) REFERENCES CatalogCourses(CatalogID)
);

CREATE TABLE CompletedCourseRecords (
  CompletionID INT PRIMARY KEY,
  StudentID    INT NOT NULL,
  CatalogID    INT NOT NULL,
  GradeCode    CHAR(2) NOT NULL,
  CONSTRAINT fk_completed_student
    FOREIGN KEY (StudentID) REFERENCES StudentRecords(StudentID),
  CONSTRAINT fk_completed_catalog
    FOREIGN KEY (CatalogID) REFERENCES CatalogCourses(CatalogID)
);

-- Example: ECON230 (202) requires ECON120 (201) and MATH140 (203)
INSERT INTO CoursePrerequisites (PrereqID, TargetCatalogID, RequiredCatalogID, MinimumGrade) VALUES
  (1, 202, 201, 'C'),
  (2, 202, 203, 'D');

-- Example completed courses / grades for some students
INSERT INTO CompletedCourseRecords (CompletionID, StudentID, CatalogID, GradeCode) VALUES
  (1, 1, 201, 'B'),   -- Burak: ECON120 B
  (2, 1, 203, 'C'),   -- Burak: MATH140 C

  (3, 2, 201, 'D'),   -- Elif: ECON120 D (below C)
  (4, 2, 203, 'B'),   -- Elif: MATH140 B

  (5, 3, 201, 'C'),   -- Merve: ECON120 C
  -- Merve has never taken MATH140

  (6, 4, 201, 'A'),   -- Kerem: ECON120 A
  (7, 4, 203, 'B');   -- Kerem: MATH140 B

-------------------------------------------------
-- Part 2c – Assistive SQL queries
-------------------------------------------------

-- 1) List all prerequisites of a target course (example: ECON230, CatalogID = 202)

SELECT
  c_target.CourseCode AS TargetCourseCode,
  c_target.CourseName AS TargetCourseName,
  c_req.CourseCode    AS RequiredCourseCode,
  c_req.CourseName    AS RequiredCourseName,
  p.MinimumGrade
FROM CoursePrerequisites p
JOIN CatalogCourses c_target ON p.TargetCatalogID   = c_target.CatalogID
JOIN CatalogCourses c_req    ON p.RequiredCatalogID = c_req.CatalogID
WHERE p.TargetCatalogID = 202;

-- 2) Check whether a specific student passed prerequisites
-- Example: StudentID = 1, target course CatalogID = 202

SELECT
  s.StudentID,
  s.FirstName,
  s.LastName,
  c_target.CourseCode AS TargetCourseCode,
  c_req.CourseCode    AS RequiredCourseCode,
  c_req.CourseName    AS RequiredCourseName,
  p.MinimumGrade,
  cc.GradeCode        AS StudentGrade,
  CASE
    WHEN cc.GradeCode IS NULL THEN 'NOT COMPLETED'
    WHEN cc.GradeCode >= p.MinimumGrade THEN 'OK'
    ELSE 'BELOW MINIMUM'
  END AS PrerequisiteStatus
FROM CoursePrerequisites p
JOIN CatalogCourses c_target ON p.TargetCatalogID   = c_target.CatalogID
JOIN CatalogCourses c_req    ON p.RequiredCatalogID = c_req.CatalogID
LEFT JOIN CompletedCourseRecords cc
       ON cc.CatalogID = p.RequiredCatalogID
      AND cc.StudentID = 1         -- parameter: StudentID
JOIN StudentRecords s
       ON s.StudentID = 1          -- same StudentID
WHERE p.TargetCatalogID = 202;     -- parameter: target course
