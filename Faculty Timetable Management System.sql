CREATE DATABASE faculty_timetable_db;
USE faculty_timetable_db;

CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50),
    hod_name VARCHAR(50)
);

CREATE TABLE Faculty (
    faculty_id INT PRIMARY KEY,
    faculty_name VARCHAR(50),
    designation VARCHAR(50),
    department_id INT,
    email VARCHAR(100),
    phone_number VARCHAR(15),
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

CREATE TABLE Subjects (
    subject_id INT PRIMARY KEY,
    subject_name VARCHAR(50),
    semester INT,
    credits INT,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

CREATE TABLE Classes (
    class_id INT PRIMARY KEY,
    year INT,
    semester INT,
    section VARCHAR(10),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

CREATE TABLE Rooms (
    room_id INT PRIMARY KEY,
    room_number VARCHAR(20),
    capacity INT,
    room_type VARCHAR(30)
);

CREATE TABLE Time_Slots (
    slot_id INT PRIMARY KEY,
    start_time TIME,
    end_time TIME
);

CREATE TABLE Days (
    day_id INT PRIMARY KEY,
    day_name VARCHAR(20)
);

CREATE TABLE Faculty_Subjects (
    allocation_id INT PRIMARY KEY,
    faculty_id INT,
    subject_id INT,
    FOREIGN KEY (faculty_id) REFERENCES Faculty(faculty_id),
    FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id)
);

CREATE TABLE Timetable (
    timetable_id INT PRIMARY KEY,
    faculty_id INT,
    subject_id INT,
    class_id INT,
    room_id INT,
    day_id INT,
    slot_id INT,
    FOREIGN KEY (faculty_id) REFERENCES Faculty(faculty_id),
    FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id),
    FOREIGN KEY (class_id) REFERENCES Classes(class_id),
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id),
    FOREIGN KEY (day_id) REFERENCES Days(day_id),
    FOREIGN KEY (slot_id) REFERENCES Time_Slots(slot_id),
    UNIQUE (faculty_id, day_id, slot_id),
    UNIQUE (room_id, day_id, slot_id),
    UNIQUE (class_id, day_id, slot_id)
);

CREATE TABLE Faculty_Workload (
    workload_id INT PRIMARY KEY,
    faculty_id INT,
    semester INT,
    total_hours INT,
    FOREIGN KEY (faculty_id) REFERENCES Faculty(faculty_id)
);

CREATE TABLE Attendance_Hours (
    attendance_id INT PRIMARY KEY,
    faculty_id INT,
    subject_id INT,
    date DATE,
    hours_taken INT,
    FOREIGN KEY (faculty_id) REFERENCES Faculty(faculty_id),
    FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id)
);

CREATE TABLE Notifications (
    notification_id INT PRIMARY KEY,
    faculty_id INT,
    message VARCHAR(255),
    date DATE,
    FOREIGN KEY (faculty_id) REFERENCES Faculty(faculty_id)
);

INSERT INTO Departments VALUES
(1, 'CSE', 'Dr. Kumar'),
(2, 'AIML', 'Dr. Priya'),
(3, 'ECE', 'Dr. Ravi');

INSERT INTO Faculty VALUES
(101, 'Dr. Saran', 'Assistant Professor', 1, 'saran@college.edu', '9876543210'),
(102, 'Dr. Anjali', 'Associate Professor', 1, 'anjali@college.edu', '9876501234'),
(103, 'Dr. Rahul', 'Assistant Professor', 2, 'rahul@college.edu', '9876512345'),
(104, 'Dr. Meena', 'Professor', 3, 'meena@college.edu', '9876523456');

INSERT INTO Subjects VALUES
(201, 'DBMS', 5, 4, 1),
(202, 'Operating Systems', 5, 4, 1),
(203, 'Machine Learning', 5, 4, 2),
(204, 'Digital Electronics', 3, 3, 3);

INSERT INTO Classes VALUES
(301, 3, 5, 'A', 1),
(302, 3, 5, 'B', 1),
(303, 3, 5, 'A', 2),
(304, 2, 3, 'A', 3);

INSERT INTO Rooms VALUES
(401, 'R203', 60, 'Theory Room'),
(402, 'R204', 60, 'Theory Room'),
(403, 'LAB1', 40, 'Lab Room'),
(404, 'R305', 70, 'Theory Room');

INSERT INTO Time_Slots VALUES
(501, '09:00:00', '10:00:00'),
(502, '10:00:00', '11:00:00'),
(503, '11:00:00', '12:00:00'),
(504, '12:00:00', '01:00:00'),
(505, '02:00:00', '03:00:00');

INSERT INTO Days VALUES
(601, 'Monday'),
(602, 'Tuesday'),
(603, 'Wednesday'),
(604, 'Thursday'),
(605, 'Friday'),
(606, 'Saturday');

INSERT INTO Faculty_Subjects VALUES
(701, 101, 201),
(702, 102, 202),
(703, 103, 203),
(704, 104, 204);

INSERT INTO Timetable VALUES
(801, 101, 201, 301, 401, 601, 501),
(802, 102, 202, 302, 402, 601, 502),
(803, 103, 203, 303, 403, 602, 501),
(804, 104, 204, 304, 404, 603, 503);

INSERT INTO Faculty_Workload VALUES
(901, 101, 5, 6),
(902, 102, 5, 5),
(903, 103, 5, 6),
(904, 104, 3, 4);

INSERT INTO Attendance_Hours VALUES
(1001, 101, 201, '2026-06-21', 1),
(1002, 102, 202, '2026-06-21', 1),
(1003, 103, 203, '2026-06-21', 2);

INSERT INTO Notifications VALUES
(1101, 101, 'DBMS class shifted to R204', '2026-06-21'),
(1102, 102, 'Operating Systems class rescheduled', '2026-06-21');

SELECT * FROM Departments;

SELECT * FROM Faculty;

SELECT * FROM Subjects;

SELECT * FROM Classes;

SELECT * FROM Rooms;

SELECT * FROM Time_Slots;

SELECT * FROM Days;

SELECT * FROM Faculty_Subjects;

SELECT * FROM Timetable;

SELECT * FROM Faculty_Workload;

SELECT * FROM Attendance_Hours;

SELECT * FROM Notifications;

SELECT 
    f.faculty_name,
    s.subject_name
FROM Faculty_Subjects fs
JOIN Faculty f ON fs.faculty_id = f.faculty_id
JOIN Subjects s ON fs.subject_id = s.subject_id;

SELECT 
    t.timetable_id,
    f.faculty_name,
    s.subject_name,
    d.department_name,
    c.year,
    c.semester,
    c.section,
    r.room_number,
    dy.day_name,
    ts.start_time,
    ts.end_time
FROM Timetable t
JOIN Faculty f ON t.faculty_id = f.faculty_id
JOIN Subjects s ON t.subject_id = s.subject_id
JOIN Classes c ON t.class_id = c.class_id
JOIN Departments d ON c.department_id = d.department_id
JOIN Rooms r ON t.room_id = r.room_id
JOIN Days dy ON t.day_id = dy.day_id
JOIN Time_Slots ts ON t.slot_id = ts.slot_id;

SELECT 
    f.faculty_name,
    fw.semester,
    fw.total_hours
FROM Faculty_Workload fw
JOIN Faculty f ON fw.faculty_id = f.faculty_id;

SELECT 
    f.faculty_name,
    s.subject_name,
    ah.date,
    ah.hours_taken
FROM Attendance_Hours ah
JOIN Faculty f ON ah.faculty_id = f.faculty_id
JOIN Subjects s ON ah.subject_id = s.subject_id;

SELECT 
    f.faculty_name,
    n.message,
    n.date
FROM Notifications n
JOIN Faculty f ON n.faculty_id = f.faculty_id;

SELECT 
    dy.day_name,
    ts.start_time,
    ts.end_time,
    f.faculty_name,
    s.subject_name,
    r.room_number
FROM Timetable t
JOIN Days dy ON t.day_id = dy.day_id
JOIN Time_Slots ts ON t.slot_id = ts.slot_id
JOIN Faculty f ON t.faculty_id = f.faculty_id
JOIN Subjects s ON t.subject_id = s.subject_id
JOIN Rooms r ON t.room_id = r.room_id
WHERE f.faculty_id = 101;

SELECT 
    c.year,
    c.semester,
    c.section,
    d.department_name,
    dy.day_name,
    ts.start_time,
    ts.end_time,
    s.subject_name,
    f.faculty_name,
    r.room_number
FROM Timetable t
JOIN Classes c ON t.class_id = c.class_id
JOIN Departments d ON c.department_id = d.department_id
JOIN Days dy ON t.day_id = dy.day_id
JOIN Time_Slots ts ON t.slot_id = ts.slot_id
JOIN Subjects s ON t.subject_id = s.subject_id
JOIN Faculty f ON t.faculty_id = f.faculty_id
JOIN Rooms r ON t.room_id = r.room_id
WHERE c.class_id = 301;

CREATE VIEW faculty_timetable_view AS
SELECT 
    f.faculty_name,
    s.subject_name,
    c.year,
    c.semester,
    c.section,
    r.room_number,
    dy.day_name,
    ts.start_time,
    ts.end_time
FROM Timetable t
JOIN Faculty f ON t.faculty_id = f.faculty_id
JOIN Subjects s ON t.subject_id = s.subject_id
JOIN Classes c ON t.class_id = c.class_id
JOIN Rooms r ON t.room_id = r.room_id
JOIN Days dy ON t.day_id = dy.day_id
JOIN Time_Slots ts ON t.slot_id = ts.slot_id;

CREATE VIEW faculty_workload_view AS
SELECT 
    f.faculty_name,
    fw.semester,
    fw.total_hours
FROM Faculty_Workload fw
JOIN Faculty f ON fw.faculty_id = f.faculty_id;

DELIMITER //

CREATE PROCEDURE GetFacultyTimetable(IN fid INT)
BEGIN
    SELECT 
        f.faculty_name,
        s.subject_name,
        c.year,
        c.semester,
        c.section,
        r.room_number,
        dy.day_name,
        ts.start_time,
        ts.end_time
    FROM Timetable t
    JOIN Faculty f ON t.faculty_id = f.faculty_id
    JOIN Subjects s ON t.subject_id = s.subject_id
    JOIN Classes c ON t.class_id = c.class_id
    JOIN Rooms r ON t.room_id = r.room_id
    JOIN Days dy ON t.day_id = dy.day_id
    JOIN Time_Slots ts ON t.slot_id = ts.slot_id
    WHERE f.faculty_id = fid;
END //

CREATE PROCEDURE GetClassTimetable(IN cid INT)
BEGIN
    SELECT 
        c.year,
        c.semester,
        c.section,
        s.subject_name,
        f.faculty_name,
        r.room_number,
        dy.day_name,
        ts.start_time,
        ts.end_time
    FROM Timetable t
    JOIN Classes c ON t.class_id = c.class_id
    JOIN Subjects s ON t.subject_id = s.subject_id
    JOIN Faculty f ON t.faculty_id = f.faculty_id
    JOIN Rooms r ON t.room_id = r.room_id
    JOIN Days dy ON t.day_id = dy.day_id
    JOIN Time_Slots ts ON t.slot_id = ts.slot_id
    WHERE c.class_id = cid;
END //

CREATE PROCEDURE GetFacultyWorkload(IN fid INT)
BEGIN
    SELECT 
        f.faculty_name,
        fw.semester,
        fw.total_hours
    FROM Faculty_Workload fw
    JOIN Faculty f ON fw.faculty_id = f.faculty_id
    WHERE f.faculty_id = fid;
END //

DELIMITER ;

CALL GetFacultyTimetable(101);

CALL GetClassTimetable(301);

CALL GetFacultyWorkload(101);