use SQL_City_Schools;
# Change the names of columns containing spaces so they are easier to work with
# No need to run these lines more than once
# ALTER TABLE schools_data CHANGE `School ID` `School_ID` VARCHAR(50);
#ALTER TABLE students_data CHANGE `Student ID` `Student_ID` VARCHAR(50);

# Check to make sure there are no duplicate students by comparing the number of total students to the number of distinct students
SELECT COUNT(*)
FROM(	select DISTINCT Student_ID 
	FROM students_data) t1;
    
SELECT COUNT(*)
FROM students_data;   

# 