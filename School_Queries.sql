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

# Create a single table with some key metrics for the entire district
# This table will show the total number of schools, total number of students and the total budget for the entire district
# It will also show the average scores for each subject as well as what percent of students are passing each subject. A score of at least 70 is required to pass
SELECT COUNT(DISTINCT sc.School_ID) Total_Schools, COUNT(st.Student_ID) Total_Students, SUM(DISTINCT sc.budget) Total_District_Budget,
    AVG(st.math_score) Average_Math_Score, AVG(st.reading_score) Average_Reading_Score, (pass_m/COUNT(st.Student_ID)*100) Percent_Passing_Math,
    (pass_r/COUNT(st.Student_ID)*100) Percent_Passing_Reading, ((pass_m/COUNT(st.Student_ID)*100)+(pass_r/COUNT(st.Student_ID)*100))/2 Overall_Passing_Rate
FROM schools_data sc
INNER JOIN students_data st
ON sc.name = st.school
JOIN ( SELECT st.Student_ID, COUNT(*) pass_m
		FROM students_data st
        WHERE st.math_score >= 70) t1
JOIN ( SELECT st.Student_ID, COUNT(*) pass_r
		FROM students_data st 
        WHERE st.reading_score >= 70) t2



