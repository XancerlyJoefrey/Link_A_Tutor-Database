CREATE DATABASE IF NOT EXISTS link_a_tutor101
 CHARACTER SET utf8mb4
 COLLATE utf8mb4_0900_ai_ci;
 
USE link_a_tutor101;

CREATE TABLE IF NOT EXISTS `user` (
 UserID INT NOT NULL AUTO_INCREMENT,
 Name VARCHAR(100) NOT NULL,
 Email VARCHAR(100) NOT NULL,
 Password VARCHAR(255) NOT NULL,
 Role VARCHAR(15) NOT NULL,
 PRIMARY KEY (UserID),
 UNIQUE KEY uq_user_email (Email),
 CONSTRAINT chk_user_name CHECK (CHAR_LENGTH(TRIM(Name)) > 0),
 CONSTRAINT chk_user_email CHECK (Email LIKE '%_@_%._%'),
 CONSTRAINT chk_user_password CHECK (CHAR_LENGTH(TRIM(Password)) > 0),
 CONSTRAINT chk_user_role
    CHECK (Role IN ('Student','Tutor','Administrator'))
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS student (
 UserID INT NOT NULL,
 Status VARCHAR(10) NOT NULL,
 PRIMARY KEY (UserID),
 CONSTRAINT chk_student_status CHECK (Status IN ('Active','Inactive')),
 CONSTRAINT fk_student_user FOREIGN KEY (UserID)
    REFERENCES `user`(UserID) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS administrator (
 UserID INT NOT NULL,
 PRIMARY KEY (UserID),
 CONSTRAINT fk_administrator_user FOREIGN KEY (UserID)
    REFERENCES `user`(UserID) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tutor (
 UserID INT NOT NULL,
 Qualification VARCHAR(150) NOT NULL,
 HourlyRate DECIMAL(8,2) NOT NULL,
 MaxStudents INT NOT NULL,
 Status VARCHAR(10) NOT NULL,
 PRIMARY KEY (UserID),
 CONSTRAINT chk_tutor_qualification
    CHECK (CHAR_LENGTH(TRIM(Qualification)) > 0),
 CONSTRAINT chk_tutor_rate CHECK (HourlyRate > 0),
 CONSTRAINT chk_tutor_max_students CHECK (MaxStudents >= 1),
 CONSTRAINT chk_tutor_status CHECK (Status IN ('Active','Inactive')),
 CONSTRAINT fk_tutor_user FOREIGN KEY (UserID)
    REFERENCES `user`(UserID) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS subject (
 SubjectID INT NOT NULL AUTO_INCREMENT,
 SubjectName VARCHAR(80) NOT NULL,
 PRIMARY KEY (SubjectID),
 UNIQUE KEY uq_subject_name (SubjectName),
 CONSTRAINT chk_subject_name CHECK (CHAR_LENGTH(TRIM(SubjectName)) > 0)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tutoring_session (
 SessionID INT NOT NULL AUTO_INCREMENT,
 TutorID INT NOT NULL,
 SubjectID INT NOT NULL,
 SessionDate DATE NOT NULL,
 StartTime TIME NOT NULL,
 EndTime TIME NOT NULL,
 SessionType VARCHAR(15) NOT NULL,
 Status VARCHAR(10) NOT NULL,
 PRIMARY KEY (SessionID),
 CONSTRAINT chk_session_time CHECK (EndTime > StartTime),
 CONSTRAINT chk_session_type
    CHECK (SessionType IN ('One-on-One','Group')),
 CONSTRAINT chk_session_status
    CHECK (Status IN ('Open','Full','Completed','Cancelled')),
 CONSTRAINT fk_session_tutor FOREIGN KEY (TutorID)
    REFERENCES tutor(UserID) ON DELETE RESTRICT,
 CONSTRAINT fk_session_subject FOREIGN KEY (SubjectID)
    REFERENCES subject(SubjectID) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tutoring_subject (
 TutoringSubjectID INT NOT NULL AUTO_INCREMENT,
 TutorID INT NOT NULL,
 SubjectID INT NOT NULL,
 PRIMARY KEY (TutoringSubjectID),
 UNIQUE KEY uq_tutor_subject (TutorID, SubjectID),
 CONSTRAINT fk_tsubject_tutor FOREIGN KEY (TutorID)
    REFERENCES tutor(UserID) ON DELETE CASCADE,
 CONSTRAINT fk_tsubject_subject FOREIGN KEY (SubjectID)
    REFERENCES subject(SubjectID) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS booking (
 BookingID INT NOT NULL AUTO_INCREMENT,
 StudentID INT NOT NULL,
 SessionID INT NOT NULL,
 AdminID INT DEFAULT NULL,
 BookingDate DATE NOT NULL,
 Status VARCHAR(10) NOT NULL,
 PRIMARY KEY (BookingID),
 CONSTRAINT chk_booking_status
    CHECK (Status IN ('Pending','Confirmed','Rejected','Cancelled','Completed')),
 CONSTRAINT fk_booking_student FOREIGN KEY (StudentID)
    REFERENCES student(UserID) ON DELETE RESTRICT,
 CONSTRAINT fk_booking_session FOREIGN KEY (SessionID)
    REFERENCES tutoring_session(SessionID) ON DELETE RESTRICT,
 CONSTRAINT fk_booking_admin FOREIGN KEY (AdminID)
    REFERENCES administrator(UserID) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS payment (
 PaymentID INT NOT NULL AUTO_INCREMENT,
 BookingID INT NOT NULL,
 Amount DECIMAL(10,2) NOT NULL,
 ServiceFee DECIMAL(10,2) NOT NULL,
 PaymentDate DATE DEFAULT NULL,
 Status VARCHAR(10) NOT NULL,
 PRIMARY KEY (PaymentID),
 CONSTRAINT chk_payment_amount CHECK (Amount >= 0),
 CONSTRAINT chk_payment_fee CHECK (ServiceFee >= 0),
 CONSTRAINT chk_payment_status
    CHECK (Status IN ('Pending','Paid','Refunded')),
 CONSTRAINT fk_payment_booking FOREIGN KEY (BookingID)
    REFERENCES booking(BookingID) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS review (
 ReviewID INT NOT NULL AUTO_INCREMENT,
 BookingID INT NOT NULL,
 Rating INT NOT NULL,
 Comment VARCHAR(500) DEFAULT NULL,
 ReviewDate DATE NOT NULL,
 PRIMARY KEY (ReviewID),
 CONSTRAINT chk_review_rating CHECK (Rating BETWEEN 1 AND 5),
 CONSTRAINT fk_review_booking FOREIGN KEY (BookingID)
    REFERENCES booking(BookingID) ON DELETE RESTRICT
) ENGINE=InnoDB;

SHOW TABLES;

SELECT TABLE_NAME, COLUMN_NAME, data_type, character_maximum_length,
 numeric_precision, numeric_scale, is_nullable,
 column_default, column_key, extra
FROM information_schema.columns
WHERE table_schema = 'link_a_tutor101'
ORDER BY TABLE_NAME, ordinal_position;
 
SELECT table_name, constraint_name, referenced_table_name, delete_rule
FROM information_schema.referential_constraints
WHERE constraint_schema = 'link_a_tutor101'
ORDER BY table_name, constraint_name;