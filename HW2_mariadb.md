


# ECON485 – Homework 2 (Burak) – terminal output

```

MariaDB [(none)]> CREATE DATABASE econ485_burak;
Query OK, 1 row affected (0.004 sec)

MariaDB [(none)]> USE econ485_burak;
Database changed

MariaDB [econ485_burak]> CREATE TABLE StudentRecords (
    StudentID    INT PRIMARY KEY,
    UniversityID VARCHAR(20) NOT NULL,
    FirstName    VARCHAR(50) NOT NULL,
    LastName     VARCHAR(50) NOT NULL,
    ProgramCode  VARCHAR(50),
    CohortYear   INT
);
Query OK, 0 rows affected (0.039 sec)

MariaDB [econ485_burak]> CREATE TABLE CatalogCourses (
    CatalogID    INT PRIMARY KEY,
    CourseCode   VARCHAR(20) NOT NULL,
    CourseName   VARCHAR(100) NOT NULL,
    LocalCredits INT,
    EctsCredits  INT
);
Query OK, 0 rows affected (0.021 sec)

MariaDB [econ485_burak]> CREATE TABLE OfferedSections (
    OfferedID      INT PRIMARY KEY,
    CatalogID      INT NOT NULL,
    TermLabel      VARCHAR(10) NOT NULL,
    YearValue      INT NOT NULL,
    SectionLabel   VARCHAR(10) NOT NULL,
    CapacityLimit  INT,
    MainInstructor VARCHAR(100),
    CONSTRAINT fk_offered_catalog
      FOREIGN KEY (CatalogID) REFERENCES CatalogCourses(CatalogID)
);
Query OK, 0 rows affected (0.025 sec)

MariaDB [econ485_burak]> CREATE TABLE RegistrationsBasic (
    RegID        INT PRIMARY KEY,
    StudentID    INT NOT NULL,
    OfferedID    INT NOT NULL,
    RegisteredOn DATE,
    CONSTRAINT fk_reg_student
      FOREIGN KEY (StudentID) REFERENCES StudentRecords(StudentID),
    CONSTRAINT fk_reg_offered
      FOREIGN KEY (OfferedID) REFERENCES OfferedSections(OfferedID)
);
Query OK, 0 rows affected (0.023 sec)

MariaDB [econ485_burak]> INSERT INTO CatalogCourses (CatalogID, CourseCode, CourseName, LocalCredits, EctsCredits) VALUES
    (201, 'ECON120', 'Economic Thinking',      3, 6),
    (202, 'ECON230', 'Applied Microeconomics', 3, 6),
    (203, 'MATH140', 'Introductory Calculus',  4, 7);
Query OK, 3 rows affected (0.005 sec)
Records: 3  Duplicates: 0  Warnings: 0

MariaDB [econ485_burak]> INSERT INTO OfferedSections (OfferedID, CatalogID, TermLabel, YearValue, SectionLabel, CapacityLimit, MainInstructor) VALUES
    (2001, 201, 'Fall', 2025, '01', 55, 'Dr. Aksoy'),
    (2002, 201, 'Fall', 2025, '02', 55, 'Dr. Tekin'),
    (2003, 202, 'Fall', 2025, '01', 40, 'Dr. Yaman'),
    (2004, 203, 'Fall', 2025, '01', 45, 'Dr. Durmaz');
Query OK, 4 rows affected (0.003 sec)
Records: 4  Duplicates: 0  Warnings: 0

MariaDB [econ485_burak]> INSERT INTO StudentRecords (StudentID, UniversityID, FirstName, LastName, ProgramCode, CohortYear) VALUES
    (1,  '20252001', 'Burak',  'Ozdemir', 'Economics',    2025),
    (2,  '20252002', 'Elif',   'Cetin',   'Economics',    2025),
    (3,  '20252003', 'Merve',  'Tan',     'Business',     2024),
    (4,  '20252004', 'Kerem',  'Sari',    'Economics',    2023),
    (5,  '20252005', 'Ozgur',  'Dal',     'Mathematics',  2025),
    (6,  '20252006', 'Deniz',  'Boz',     'Economics',    2024),
    (7,  '20252007', 'Eren',   'Kiran',   'Computer Eng', 2023),
    (8,  '20252008', 'Yasmin', 'Acar',    'Economics',    2022),
    (9,  '20252009', 'Kaan',   'Ersoy',   'Business',     2024),
    (10, '20252010', 'Selma',  'Ucar',    'Economics',    2025);
Query OK, 10 rows affected (0.002 sec)
Records: 10  Duplicates: 0  Warnings: 0

MariaDB [econ485_burak]> INSERT INTO RegistrationsBasic (RegID, StudentID, OfferedID, RegisteredOn) VALUES
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
Query OK, 15 rows affected (0.002 sec)
Records: 15  Duplicates: 0  Warnings: 0

-- Add
MariaDB [econ485_burak]> INSERT INTO RegistrationsBasic (RegID, StudentID, OfferedID, RegisteredOn)
VALUES (16, 1, 2003, '2025-09-04');  -- Burak adds ECON230
Query OK, 1 row affected (0.001 sec)

MariaDB [econ485_burak]> INSERT INTO RegistrationsBasic (RegID, StudentID, OfferedID, RegisteredOn)
VALUES (17, 2, 2004, '2025-09-04');  -- Elif adds MATH140
Query OK, 1 row affected (0.000 sec)

MariaDB [econ485_burak]> INSERT INTO RegistrationsBasic (RegID, StudentID, OfferedID, RegisteredOn)
VALUES (18, 3, 2002, '2025-09-04');  -- Merve adds ECON120 sec 02
Query OK, 1 row affected (0.000 sec)

-- Drop
MariaDB [econ485_burak]> DELETE FROM RegistrationsBasic WHERE RegID = 2;   -- Burak drops Calculus
Query OK, 1 row affected (0.002 sec)

MariaDB [econ485_burak]> DELETE FROM RegistrationsBasic WHERE RegID = 4;   -- Elif drops ECON230
Query OK, 1 row affected (0.000 sec)

MariaDB [econ485_burak]> DELETE FROM RegistrationsBasic WHERE RegID = 6;   -- Merve drops Calculus
Query OK, 1 row affected (0.000 sec)

-- Kontrol
MariaDB [econ485_burak]> SELECT * FROM RegistrationsBasic ORDER BY RegID;
+-------+-----------+-----------+--------------+
| RegID | StudentID | OfferedID | RegisteredOn |
+-------+-----------+-----------+--------------+
| 1     | 1         | 2001      | 2025-09-01   |
| 3     | 2         | 2001      | 2025-09-01   |
| 5     | 3         | 2001      | 2025-09-02   |
| 7     | 4         | 2002      | 2025-09-02   |
| 8     | 4         | 2003      | 2025-09-02   |
| 9     | 5         | 2004      | 2025-09-02   |
| 10    | 6         | 2001      | 2025-09-03   |
| 11    | 7         | 2002      | 2025-09-03   |
| 12    | 8         | 2003      | 2025-09-03   |
| 13    | 9         | 2004      | 2025-09-03   |
| 14    | 10        | 2001      | 2025-09-03   |
| 15    | 10        | 2003      | 2025-09-03   |
| 16    | 1         | 2003      | 2025-09-04   |
| 17    | 2         | 2004      | 2025-09-04   |
| 18    | 3         | 2002      | 2025-09-04   |
+-------+-----------+-----------+--------------+
15 rows in set (0.000 sec)

MariaDB [econ485_burak]> SELECT
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
+-----------+----------+------------+--------------+-----------+-----------+--------------+
| FirstName | LastName | CourseCode | SectionLabel | TermLabel | YearValue | RegisteredOn |
+-----------+----------+------------+--------------+-----------+-----------+--------------+
| Yasmin    | Acar     | ECON230    | 01           | Fall      | 2025      | 2025-09-03   |
| Deniz     | Boz      | ECON120    | 01           | Fall      | 2025      | 2025-09-03   |
| Elif      | Cetin    | ECON120    | 01           | Fall      | 2025      | 2025-09-01   |
| Elif      | Cetin    | MATH140    | 01           | Fall      | 2025      | 2025-09-04   |
| Ozgur     | Dal      | MATH140    | 01           | Fall      | 2025      | 2025-09-02   |
| Kaan      | Ersoy    | MATH140    | 01           | Fall      | 2025      | 2025-09-03   |
| Eren      | Kiran    | ECON120    | 02           | Fall      | 2025      | 2025-09-03   |
| Burak     | Ozdemir  | ECON120    | 01           | Fall      | 2025      | 2025-09-01   |
| Burak     | Ozdemir  | ECON230    | 01           | Fall      | 2025      | 2025-09-04   |
| Kerem     | Sari     | ECON120    | 02           | Fall      | 2025      | 2025-09-02   |
| Kerem     | Sari     | ECON230    | 01           | Fall      | 2025      | 2025-09-02   |
| Merve     | Tan      | ECON120    | 01           | Fall      | 2025      | 2025-09-02   |
| Merve     | Tan      | ECON120    | 02           | Fall      | 2025      | 2025-09-04   |
| Selma     | Ucar     | ECON120    | 01           | Fall      | 2025      | 2025-09-03   |
| Selma     | Ucar     | ECON230    | 01           | Fall      | 2025      | 2025-09-03   |
+-----------+----------+------------+--------------+-----------+-----------+--------------+
15 rows in set (0.003 sec)

MariaDB [econ485_burak]> CREATE TABLE CoursePrerequisites (
    PrereqID          INT PRIMARY KEY,
    TargetCatalogID   INT NOT NULL,
    RequiredCatalogID INT NOT NULL,
    MinimumGrade      CHAR(2) NOT NULL,
    CONSTRAINT fk_prereq_target
      FOREIGN KEY (TargetCatalogID)   REFERENCES CatalogCourses(CatalogID),
    CONSTRAINT fk_prereq_required
      FOREIGN KEY (RequiredCatalogID) REFERENCES CatalogCourses(CatalogID)
);
Query OK, 0 rows affected (0.031 sec)

MariaDB [econ485_burak]> CREATE TABLE CompletedCourseRecords (
    CompletionID INT PRIMARY KEY,
    StudentID    INT NOT NULL,
    CatalogID    INT NOT NULL,
    GradeCode    CHAR(2) NOT NULL,
    CONSTRAINT fk_completed_student
      FOREIGN KEY (StudentID) REFERENCES StudentRecords(StudentID),
    CONSTRAINT fk_completed_catalog
      FOREIGN KEY (CatalogID) REFERENCES CatalogCourses(CatalogID)
);
Query OK, 0 rows affected (0.025 sec)

MariaDB [econ485_burak]> INSERT INTO CoursePrerequisites (PrereqID, TargetCatalogID, RequiredCatalogID, MinimumGrade) VALUES
    (1, 202, 201, 'C'),  -- ECON230 requires ECON120
    (2, 202, 203, 'D');  -- ECON230 requires MATH140
Query OK, 2 rows affected (0.002 sec)
Records: 2  Duplicates: 0  Warnings: 0

MariaDB [econ485_burak]> INSERT INTO CompletedCourseRecords (CompletionID, StudentID, CatalogID, GradeCode) VALUES
    (1, 1, 201, 'B'),
    (2, 1, 203, 'C'),
    (3, 2, 201, 'D'),
    (4, 2, 203, 'B'),
    (5, 3, 201, 'C'),
    (6, 4, 201, 'A'),
    (7, 4, 203, 'B');
Query OK, 7 rows affected (0.001 sec)
Records: 7  Duplicates: 0  Warnings: 0

MariaDB [econ485_burak]> -- List all prerequisites of ECON230 (CatalogID = 202)
MariaDB [econ485_burak]> SELECT
    c_target.CourseCode AS TargetCourseCode,
    c_target.CourseName AS TargetCourseName,
    c_req.CourseCode    AS RequiredCourseCode,
    c_req.CourseName    AS RequiredCourseName,
    p.MinimumGrade
FROM CoursePrerequisites p
JOIN CatalogCourses c_target ON p.TargetCatalogID   = c_target.CatalogID
JOIN CatalogCourses c_req    ON p.RequiredCatalogID = c_req.CatalogID
WHERE p.TargetCatalogID = 202;
+------------------+------------------------+--------------------+------------------------+--------------+
| TargetCourseCode | TargetCourseName       | RequiredCourseCode | RequiredCourseName     | MinimumGrade |
+------------------+------------------------+--------------------+------------------------+--------------+
| ECON230          | Applied Microeconomics | ECON120            | Economic Thinking      | C            |
| ECON230          | Applied Microeconomics | MATH140            | Introductory Calculus  | D            |
+------------------+------------------------+--------------------+------------------------+--------------+
2 rows in set (0.001 sec)

MariaDB [econ485_burak]> -- Check prerequisites for StudentID = 1, TargetCatalogID = 202
MariaDB [econ485_burak]> SELECT
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
      AND cc.StudentID = 1
JOIN StudentRecords s
       ON s.StudentID = 1
WHERE p.TargetCatalogID = 202;
+-----------+-----------+----------+------------------+--------------------+------------------------+--------------+-------------+--------------------+
| StudentID | FirstName | LastName | TargetCourseCode | RequiredCourseCode | RequiredCourseName     | MinimumGrade | StudentGrade| PrerequisiteStatus |
+-----------+-----------+----------+------------------+--------------------+------------------------+--------------+-------------+--------------------+
| 1         | Burak     | Ozdemir  | ECON230          | ECON120            | Economic Thinking      | C            | B           | BELOW MINIMUM      |
| 1         | Burak     | Ozdemir  | ECON230          | MATH140            | Introductory Calculus  | D            | C           | BELOW MINIMUM      |
+-----------+-----------+----------+------------------+--------------------+------------------------+--------------+-------------+--------------------+
2 rows in set (0.003 sec)
```
```

