USE link_a_tutor101;

INSERT INTO `user` (UserID, Name, Email, Password, Role) VALUES
(1,'Cyfred Odarve','cyfred.odarve@linkatutor.com',SHA2('Admin@123',256),'Administrator'),
(2,'Alter Catanus','alter.catanus@linkatutor.com',SHA2('Tutor@123',256),'Tutor'),
(3,'Crismark Bonglay','crismark.bonglay@linkatutor.com',SHA2('Tutor@123',256),'Tutor'),
(4,'Joefrey Gabriza','joefrey.gabriza@linkatutor.com',SHA2('Tutor@123',256),'Tutor'),
(5,'Clark Kent','clark.kent@linkatutor.com',SHA2('Student@123',256),'Student'),
(6,'Ejhay Teves','ejhay.teves@linkatutor.com',SHA2('Student@123',256),'Student'),
(7,'Lordxenus Baconga','lordxenus.baconga@linkatutor.com',SHA2('Student@123',256),'Student'),
(8,'Xavier Bombeo','xavier.bombeo@linkatutor.com',SHA2('Student@123',256),'Student');

INSERT INTO administrator (UserID) VALUES (1);
 
INSERT INTO tutor (UserID, Qualification, HourlyRate, MaxStudents, Status) VALUES
(2,'BS Mathematics, 3 years of tutoring experience',350.00,4,'Active'),
(3,'BS Information Technology, Dean''s Lister',400.00,5,'Active'),
(4,'BSEd Major in English, 2 years of tutoring experience',300.00,2,'Active');
 
INSERT INTO student (UserID, Status) VALUES
(5,'Active'),(6,'Active'),(7,'Active'),(8,'Active');
 
INSERT INTO subject (SubjectID, SubjectName) VALUES
(1,'Mathematics'),(2,'English'),(3,'Physics'),
(4,'Programming'),(5,'Database Systems');
 
INSERT INTO tutoring_subject (TutoringSubjectID, TutorID, SubjectID) VALUES
(1,2,1),(2,2,3),(3,3,4),(4,3,5),(5,4,2);
 
INSERT INTO tutoring_session
(SessionID, TutorID, SubjectID, SessionDate, StartTime, EndTime, SessionType, Status)
VALUES
(1,2,1,'2026-11-03','09:00:00','10:00:00','Group','Completed'),
(2,3,5,'2026-11-05','14:00:00','16:00:00','One-on-One','Completed'),
(3,2,3,'2026-11-16','10:00:00','11:00:00','Group','Open'),
(4,4,2,'2026-11-17','15:00:00','16:00:00','Group','Open'),
(5,3,4,'2026-11-18','13:00:00','15:00:00','Group','Open');
 
-- AdminID is optional: NULL means no administrator is involved
INSERT INTO booking (BookingID, StudentID, SessionID, AdminID, BookingDate, Status) VALUES
(1,5,1,1,'2026-11-01','Completed'),
(2,6,1,NULL,'2026-11-01','Completed'),
(3,7,2,1,'2026-11-02','Completed'),
(4,5,3,NULL,'2026-11-10','Confirmed'),
(5,8,4,NULL,'2026-11-10','Pending'),
(6,6,5,1,'2026-11-11','Confirmed');
 
-- ServiceFee = 10 percent commission; PaymentDate is NULL until paid
INSERT INTO payment (PaymentID, BookingID, Amount, ServiceFee, PaymentDate, Status) VALUES
(1,1,350.00,35.00,'2026-11-01','Paid'),
(2,2,350.00,35.00,'2026-11-01','Paid'),
(3,3,800.00,80.00,'2026-11-02','Paid'),
(4,4,350.00,35.00,'2026-11-10','Paid'),
(5,5,300.00,30.00,NULL,'Pending'),
(6,6,800.00,80.00,'2026-11-11','Paid');
 
INSERT INTO review (ReviewID, BookingID, Rating, Comment, ReviewDate) VALUES
(1,1,5,'Very clear explanations and patient tutor.','2026-11-03'),
(2,2,4,NULL,'2026-11-04'),
(3,3,5,'Helped me finish my database project.','2026-11-05');

SELECT 'user' AS table_name, COUNT(*) AS total_rows FROM `user`
UNION ALL SELECT 'administrator', COUNT(*) FROM administrator
UNION ALL SELECT 'tutor', COUNT(*) FROM tutor
UNION ALL SELECT 'student', COUNT(*) FROM student
UNION ALL SELECT 'subject', COUNT(*) FROM subject
UNION ALL SELECT 'tutoring_subject', COUNT(*) FROM tutoring_subject
UNION ALL SELECT 'tutoring_session', COUNT(*) FROM tutoring_session
UNION ALL SELECT 'booking', COUNT(*) FROM booking
UNION ALL SELECT 'payment', COUNT(*) FROM payment
UNION ALL SELECT 'review', COUNT(*) FROM review;