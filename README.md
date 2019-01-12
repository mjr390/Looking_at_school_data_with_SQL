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
;

# Create a view containing the infor on the previous query but broken down by School
# This will be used to easily compare the schools with the top passing rates and the schools with the bottom 5 passing rates
CREATE VIEW Schools_Breakdown AS
SELECT sc.name School_Name, sc.type School_Type, sc.size School_Size, sc.budget School_budget, sc.budget/sc.size Budget_Per_Student,
    AVG(st.math_score) Average_Math_Score, AVG(st.reading_score) Average_Reading_Score, (pass_m/sc.size*100) Percent_Passing_Math,
    (pass_r/sc.size*100) Percent_Passing_Reading, ((pass_m/sc.size*100)+(pass_r/sc.size*100))/2 Overall_Passing_Rate
FROM schools_data sc
JOIN students_data st
ON sc.name = st.school
JOIN ( SELECT COUNT(*) pass_m, sc.name Sc_Name
		FROM students_data st
        JOIN schools_data sc
        ON st.school = sc.name
        WHERE st.math_score >= 70
        GROUP BY 2) t1
ON t1.Sc_Name = sc.name      
JOIN ( SELECT sc.name Sch_name, COUNT(*) pass_r
		FROM students_data st 
        JOIN schools_data sc
        ON st.school = sc.name
        WHERE st.reading_score >= 70
        GROUP BY 1) t2
ON t2.Sch_name = sc.name        
GROUP BY 1
;

# Use the view to find 5 schools with the highest passing rate
SELECT * 
FROM Schools_Breakdown
ORDER BY Overall_Passing_Rate DESC
LIMIT 5 
;

# Use the view to find 5 schools with the lowest passing rate
SELECT * 
FROM Schools_Breakdown
ORDER BY Overall_Passing_Rate 
LIMIT 5 
;

SELECT sc.name School_Name, st.grade Grade, sc.type School_Type,
    AVG(st.math_score) Average_Math_Score
FROM schools_data sc
JOIN students_data st
ON sc.name = st.school      
GROUP BY 1, 2
;

SELECT sc.name School_Name, st.grade Grade, sc.type School_Type,
    AVG(st.reading_score) Average_Reading_Score
FROM schools_data sc
JOIN students_data st
ON sc.name = st.school      
GROUP BY 1, 2
;