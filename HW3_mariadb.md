
# ECON485 – Homework 3 (Burak) – terminal output

```
MariaDB [(none)]> USE econ485_burak;
Database changed

-- Task 1: List students and their registered sections
MariaDB [econ485_burak]> SELECT
    s.FirstName,
    s.LastName,
    c.CourseCode,
    o.SectionLabel
FROM RegistrationsBasic r
JOIN StudentRecords  s ON r.StudentID = s.StudentID
JOIN OfferedSections o ON r.OfferedID = o.OfferedID
JOIN CatalogCourses  c ON o.CatalogID = c.CatalogID
ORDER BY s.LastName, s.FirstName, c.CourseCode, o.SectionLabel;
+-----------+----------+------------+--------------+
| FirstName | LastName | CourseCode | SectionLabel |
+-----------+----------+------------+--------------+
| Yasmin    | Acar     | ECON230    | 01           |
| Deniz     | Boz      | ECON120    | 01           |
| Elif      | Cetin    | ECON120    | 01           |
| Elif      | Cetin    | MATH140    | 01           |
| Ozgur     | Dal      | MATH140    | 01           |
| Kaan      | Ersoy    | MATH140    | 01           |
| Eren      | Kiran    | ECON120    | 02           |
| Burak     | Ozdemir  | ECON120    | 01           |
| Burak     | Ozdemir  | ECON230    | 01           |
| Kerem     | Sari     | ECON120    | 02           |
| Kerem     | Sari     | ECON230    | 01           |
| Merve     | Tan      | ECON120    | 01           |
| Merve     | Tan      | ECON120    | 02           |
| Selma     | Ucar     | ECON120    | 01           |
| Selma     | Ucar     | ECON230    | 01           |
+-----------+----------+------------+--------------+
15 rows in set (0.008 sec)

-- Task 2: Show courses with total student counts
MariaDB [econ485_burak]> SELECT
    c.CourseCode,
    c.CourseName,
    COUNT(r.StudentID) AS TotalStudents
FROM CatalogCourses c
LEFT JOIN OfferedSections o
       ON o.CatalogID = c.CatalogID
LEFT JOIN RegistrationsBasic r
       ON r.OfferedID = o.OfferedID
GROUP BY
    c.CatalogID,
    c.CourseCode,
    c.CourseName
ORDER BY c.CourseCode;
+------------+------------------------+--------------+
| CourseCode | CourseName             | TotalStudents|
+------------+------------------------+--------------+
| ECON120    | Economic Thinking      | 8            |
| ECON230    | Applied Microeconomics | 4            |
| MATH140    | Introductory Calculus  | 3            |
+------------+------------------------+--------------+
3 rows in set (0.002 sec)

-- Task 3: List all prerequisites for each course
MariaDB [econ485_burak]> SELECT
    c_target.CourseCode AS TargetCourseCode,
    c_target.CourseName AS TargetCourseName,
    c_req.CourseCode    AS RequiredCourseCode,
    c_req.CourseName    AS RequiredCourseName,
    p.MinimumGrade
FROM CatalogCourses c_target
LEFT JOIN CoursePrerequisites p
       ON p.TargetCatalogID = c_target.CatalogID
LEFT JOIN CatalogCourses c_req
       ON p.RequiredCatalogID = c_req.CatalogID
ORDER BY
    c_target.CourseCode,
    c_req.CourseCode;
+------------------+------------------------+--------------------+------------------------+--------------+
| TargetCourseCode | TargetCourseName       | RequiredCourseCode | RequiredCourseName     | MinimumGrade |
+------------------+------------------------+--------------------+------------------------+--------------+
| ECON120          | Economic Thinking      | NULL               | NULL                   | NULL         |
| ECON230          | Applied Microeconomics | ECON120            | Economic Thinking      | C            |
| ECON230          | Applied Microeconomics | MATH140            | Introductory Calculus  | D            |
| MATH140          | Introductory Calculus  | NULL               | NULL                   | NULL         |
+------------------+------------------------+--------------------+------------------------+--------------+
4 rows in set (0.001 sec)

-- Task 4: Identify students eligible to take ECON230 (CatalogID = 202)
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
    END AS PrereqStatus
FROM StudentRecords s
JOIN CoursePrerequisites p
      ON p.TargetCatalogID = 202
JOIN CatalogCourses c_target
      ON c_target.CatalogID = p.TargetCatalogID
JOIN CatalogCourses c_req
      ON c_req.CatalogID = p.RequiredCatalogID
LEFT JOIN CompletedCourseRecords cc
      ON cc.StudentID = s.StudentID
     AND cc.CatalogID = p.RequiredCatalogID
WHERE
    NOT EXISTS (
        SELECT 1
        FROM CoursePrerequisites p2
        LEFT JOIN CompletedCourseRecords cc2
               ON cc2.StudentID = s.StudentID
              AND cc2.CatalogID = p2.RequiredCatalogID
        WHERE p2.TargetCatalogID = 202
          AND (cc2.GradeCode IS NULL OR cc2.GradeCode < p2.MinimumGrade)
    )
  AND NOT EXISTS (
        SELECT 1
        FROM RegistrationsBasic r
        JOIN OfferedSections o ON r.OfferedID = o.OfferedID
        WHERE r.StudentID = s.StudentID
          AND o.CatalogID = 202
    )
ORDER BY s.LastName, s.FirstName, c_req.CourseCode;
Empty set (0.008 sec)

-- Task 5: Detect students who registered without meeting prerequisites
MariaDB [econ485_burak]> SELECT
    s.FirstName,
    s.LastName,
    c_target.CourseCode  AS TargetCourseCode,
    c_req.CourseCode     AS MissingOrFailedPrereqCode,
    c_req.CourseName     AS MissingOrFailedPrereqTitle,
    cc.GradeCode         AS StudentGrade,
    p.MinimumGrade
FROM RegistrationsBasic r
JOIN OfferedSections o
      ON r.OfferedID = o.OfferedID
JOIN CatalogCourses c_target
      ON o.CatalogID = c_target.CatalogID
JOIN StudentRecords s
      ON r.StudentID = s.StudentID
JOIN CoursePrerequisites p
      ON p.TargetCatalogID = c_target.CatalogID
LEFT JOIN CompletedCourseRecords cc
      ON cc.StudentID = s.StudentID
     AND cc.CatalogID = p.RequiredCatalogID
JOIN CatalogCourses c_req
      ON c_req.CatalogID = p.RequiredCatalogID
WHERE
      cc.GradeCode IS NULL          -- prerequisite not completed
   OR cc.GradeCode < p.MinimumGrade -- or grade below minimum
ORDER BY s.LastName, s.FirstName, c_target.CourseCode, c_req.CourseCode;
+-----------+----------+------------------+----------------------------+----------------------------+-------------+--------------+
| FirstName | LastName | TargetCourseCode | MissingOrFailedPrereqCode  | MissingOrFailedPrereqTitle | StudentGrade| MinimumGrade |
+-----------+----------+------------------+----------------------------+----------------------------+-------------+--------------+
| Yasmin    | Acar     | ECON230          | ECON120                    | Economic Thinking          | NULL        | C            |
| Yasmin    | Acar     | ECON230          | MATH140                    | Introductory Calculus      | NULL        | D            |
| Burak     | Ozdemir  | ECON230          | ECON120                    | Economic Thinking          | B           | C            |
| Burak     | Ozdemir  | ECON230          | MATH140                    | Introductory Calculus      | C           | D            |
| Kerem     | Sari     | ECON230          | ECON120                    | Economic Thinking          | A           | C            |
| Kerem     | Sari     | ECON230          | MATH140                    | Introductory Calculus      | B           | D            |
| Selma     | Ucar     | ECON230          | ECON120                    | Economic Thinking          | NULL        | C            |
| Selma     | Ucar     | ECON230          | MATH140                    | Introductory Calculus      | NULL        | D            |
+-----------+----------+------------------+----------------------------+----------------------------+-------------+--------------+
8 rows in set (0.002 sec)
```
```

