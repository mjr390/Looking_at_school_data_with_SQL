use SQL_City_Schools;
#SELECT COUNT(*) num_Schools
#FROM schools_data
#UNION
#SELECT COUNT(*) num_Students
#FROM students_data;

ALTER TABLE schools_data CHANGE `School ID` `School_ID` VARCHAR(50);
ALTER TABLE students_data CHANGE `Student ID` `Student_ID` VARCHAR(50);