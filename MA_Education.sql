#################
-- Start off by examining our data to make sure it is clean
-- See how many districts are represented in each table
-- Count the distinct District Codes
#################


SELECT COUNT(DISTINCT District_Code)
FROM advanced_courses;
# 303

SELECT COUNT(DISTINCT District_Code)
FROM ClassSize_GenPop;
# 406

SELECT COUNT(DISTINCT District_Code)
FROM ClassSize_RaceEth;
# 406

SELECT COUNT(DISTINCT District_Code)
FROM Dropouts;
# 311

SELECT COUNT(DISTINCT District_Code)
FROM enrollment_grade;
# 406

SELECT COUNT(DISTINCT District_Code)
FROM Enrollment_RaceGen;
# 406

SELECT COUNT(DISTINCT District_Code)
FROM Enrollment_SelectedPop;
# 406 

SELECT COUNT(DISTINCT District_Code)
FROM Grades_offered;
# 399

SELECT COUNT(DISTINCT District_Code)
FROM Grad_rates;
# 302

SELECT COUNT(DISTINCT District_Code)
FROM mcas_10_elamath;
# 303

SELECT COUNT(DISTINCT District_Code)
FROM mcas_3_8;
# 358

SELECT COUNT(DISTINCT District_Code)
FROM mcas_hssci;
# 301

SELECT COUNT(DISTINCT District_Code)
FROM perpupil_expenditure;
# 405

SELECT COUNT(DISTINCT District_Code)
FROM staff_retention;
# 403

SELECT COUNT(DISTINCT District_Code)
FROM teachers;
# 406

SELECT COUNT(DISTINCT District_Code)
FROM Staff_RaceGender;
# 406

#################
-- See how many total districts are represented altogether
#################
SELECT
	COUNT(*)
FROM (
SELECT DISTINCT District_Code
FROM advanced_courses
UNION
SELECT DISTINCT District_Code
FROM ClassSize_GenPop
UNION
SELECT DISTINCT District_Code
FROM ClassSize_RaceEth
UNION
SELECT DISTINCT District_Code
FROM Dropouts
UNION
SELECT DISTINCT District_Code
FROM enrollment_grade
UNION
SELECT DISTINCT District_Code
FROM Enrollment_RaceGen
UNION
SELECT DISTINCT District_Code
FROM Enrollment_SelectedPop
UNION
SELECT DISTINCT District_Code
FROM Grades_offered
UNION
SELECT DISTINCT District_Code
FROM Grad_rates
UNION
SELECT DISTINCT District_Code
FROM mcas_10_elamath
UNION
SELECT DISTINCT District_Code
FROM mcas_3_8
UNION
SELECT DISTINCT District_Code
FROM mcas_hssci
UNION
SELECT DISTINCT District_Code
FROM perpupil_expenditure
UNION
SELECT DISTINCT District_Code
FROM staff_retention
UNION
SELECT DISTINCT District_Code
FROM Staff_RaceGender
UNION
SELECT DISTINCT District_Code
FROM teachers) a;
# 407

#################
-- Doing a quick check to see the lengths of District codes in each data set
#################

SELECT LENGTH(District_Code)
FROM advanced_courses
GROUP BY LENGTH(District_Code);
# 8

SELECT LENGTH(District_Code)
FROM ClassSize_GenPop
GROUP BY LENGTH(District_Code);
# 8

SELECT LENGTH(District_Code)
FROM ClassSize_RaceEth
GROUP BY LENGTH(District_Code);
# 8

SELECT LENGTH(District_Code)
FROM Dropouts
GROUP BY LENGTH(District_Code);
# 8

SELECT LENGTH(District_Code)
FROM enrollment_grade
GROUP BY LENGTH(District_Code);
# 8

SELECT LENGTH(District_Code)
FROM Enrollment_RaceGen
GROUP BY LENGTH(District_Code);
# 8

SELECT LENGTH(District_Code)
FROM Enrollment_SelectedPop
GROUP BY LENGTH(District_Code);
# 8 

SELECT LENGTH(District_Code)
FROM Grades_offered
GROUP BY LENGTH(District_Code);
# 8

SELECT LENGTH(District_Code)
FROM Grad_rates
GROUP BY LENGTH(District_Code);
# 8

SELECT LENGTH(District_Code)
FROM mcas_10_elamath
GROUP BY LENGTH(District_Code);
# 8

SELECT LENGTH(District_Code)
FROM mcas_3_8
GROUP BY LENGTH(District_Code);
# 8

SELECT LENGTH(District_Code)
FROM mcas_hssci
GROUP BY LENGTH(District_Code);
# 8

SELECT LENGTH(District_Code)
FROM perpupil_expenditure
GROUP BY LENGTH(District_Code);
# 8

SELECT LENGTH(District_Code)
FROM staff_retention
GROUP BY LENGTH(District_Code);
# 8

SELECT LENGTH(District_Code)
FROM Staff_RaceGender
GROUP BY LENGTH(District_Code);
# 8

SELECT LENGTH(District_Code)
FROM teachers
GROUP BY LENGTH(District_Code);
# 8

-- Prior to checking this, the District_Code in the teachers table was not correct, and had to be adjusted

#################
-- We're going to focus on some demographics here
-- Goal is to allow a superintendent to find comparable districts
#################

# Focus on following tables: 
-- enrollment_grade
-- Enrollment_RaceGen
-- Enrollment_SelectedPop

SELECT * FROM enrollment_grade;
SELECT * FROM Enrollment_RaceGen;
SELECT * FROM Enrollment_SelectedPop;

# Start by looking at racial/ethnic demographics
# Aggregate the racial groups for grouping later
-- Average
SELECT
    ROUND(AVG(White), 2) AS White,  
    ROUND(AVG(African_American),2) AS AfricanAmerican,
    ROUND(AVG(Hispanic), 2) AS Hispanic,
    ROUND(AVG(Asian),2) AS Asian,
    ROUND(AVG(Native_American), 2) AS NativeAmerican, 
    ROUND(AVG(MultiRace_NonHispanic), 2) AS MultiRace,
    ROUND(AVG(NativeHawaiian_PacificIslander), 2) AS PacificIslander
FROM Enrollment_RaceGen;

-- Min
SELECT
    ROUND(MIN(White), 2) AS White,  
    ROUND(MIN(African_American),2) AS AfricanAmerican,
    ROUND(MIN(Hispanic), 2) AS Hispanic,
    ROUND(MIN(Asian),2) AS Asian,
    ROUND(MIN(Native_American), 2) AS NativeAmerican, 
    ROUND(MIN(MultiRace_NonHispanic), 2) AS MultiRace,
    ROUND(MIN(NativeHawaiian_PacificIslander), 2) AS PacificIslander
FROM Enrollment_RaceGen;

-- Max
SELECT
    ROUND(MAX(White), 2) AS White,  
    ROUND(MAX(African_American),2) AS AfricanAmerican,
    ROUND(MAX(Hispanic), 2) AS Hispanic,
    ROUND(MAX(Asian),2) AS Asian,
    ROUND(MAX(Native_American), 2) AS NativeAmerican, 
    ROUND(MAX(MultiRace_NonHispanic), 2) AS MultiRace,
    ROUND(MAX(NativeHawaiian_PacificIslander), 2) AS PacificIslander
FROM Enrollment_RaceGen;


# Group districts with similar demographic makeup, based on data above

SELECT
	District_Name,
    White,
    Hispanic,
    African_American,
    Asian,
    MultiRace_NonHispanic,
    Native_American, 
    NativeHawaiian_PacificIslander,
    ROW_NUMBER() OVER(ORDER BY White DESC, Hispanic DESC, African_American DESC, Asian DESC) AS Row_Num
FROM Enrollment_RaceGen;

#When you add in the size of the district, the similarities are harder to find
-- This is perhaps because of the many Charter Schools with very low numbers

SELECT
	r.District_Name,
    e.Total,
    r.White,
    r.Hispanic,
    r.African_American,
    r.Asian,
    r.MultiRace_NonHispanic,
    r.Native_American, 
    r.NativeHawaiian_PacificIslander,
    ROW_NUMBER() OVER(ORDER BY r.White DESC, r.Hispanic DESC, r.African_American DESC, r.Asian DESC) AS Row_Num
FROM Enrollment_RaceGen r
JOIN enrollment_grade e ON r.District_Code = e.District_Code;

# Now we are just tring to get the 3 districts above and 3 below, based on demographics alone
-- This could be used to specifically look at the districts w/ similar demographics to yours
-- A superintendent could just swap out the District Name to get the districts similar to theirs

WITH cte AS (
	SELECT
	District_Name, White, Hispanic, African_American, Asian, MultiRace_NonHispanic,
    Native_American, NativeHawaiian_PacificIslander,
    ROW_NUMBER() OVER(ORDER BY White DESC, Hispanic DESC, African_American DESC, Asian DESC) AS Row_Num
FROM Enrollment_RaceGen
), 
cte2 AS (
	SELECT Row_Num
	FROM cte
	WHERE District_Name = 'Hopedale'
)
SELECT cte.*
FROM cte, cte2
WHERE cte2.Row_Num - 3 <= cte.Row_Num AND cte.Row_Num<= cte2.Row_Num +3;
	
#You can do something similar, but with much greater ease for schools with similar student numbers
-- You would use this if you just want to look at number of students

WITH cte1 AS(
SELECT District_Name, Total,
    ROW_NUMBER() OVER(ORDER BY Total DESC) AS Row_Num
FROM enrollment_grade
),
cte2 AS(
SELECT Row_Num
FROM cte1
WHERE District_Name = 'Hopedale'
)
SELECT cte1.*
FROM cte1, cte2
WHERE cte2.Row_Num - 3 <= cte1.Row_Num AND cte1.Row_Num<= cte2.Row_Num +3; 


# A more complex query if you want to look at both demographics AND size of district
-- This first narrows down based on size of district, THEN on demographics
-- Narrows down to 200 above and 200 below (between 15-20 student difference each grade level)
-- This could be used by a superintendent to find comparable districts in terms of stu population and demographics

WITH cte1 AS(
SELECT
	r.District_Name, r.White, r.Hispanic, r.African_American, r.Asian, r.MultiRace_NonHispanic,
    r.Native_American, r.NativeHawaiian_PacificIslander,
    g.Total
FROM Enrollment_RaceGen r
JOIN enrollment_grade g ON r.District_Code = g.District_Code
),
cte2 AS(
SELECT District_Name, Total
FROM cte1
WHERE District_Name = 'Hopedale'
),
cte3 AS(
SELECT cte1.*, 
	ROW_NUMBER() OVER(ORDER BY White DESC, Hispanic DESC, African_American DESC, Asian DESC) AS Row_Num
FROM cte1,cte2
WHERE cte1.Total <= cte2.Total + 200 AND cte1.Total >= cte2.Total - 200
),
cte4 AS(
SELECT Row_Num 
FROM cte3
WHERE District_name = 'Hopedale')
SELECT
	cte3.*
FROM cte3, cte4
WHERE cte3.Row_Num >= cte4.Row_Num -3 AND cte3.Row_Num <= cte4.Row_Num +3;

# Can also further separate populations by school type
-- You can use this if you want to specifically compare a specific school population
SELECT
	District_Name,
    Total,
    PK AS Total_in_PK,
    K + 1st + 2nd + 3rd + 4th AS Total_in_ES,
    5th + 6th + 7th + 8th AS Total_in_MS,
    9th + 10th + 11th + 12th AS Total_in_HS,
    SP AS Total_Outplaced,
    ROW_NUMBER() OVER(ORDER BY Total DESC)
FROM enrollment_grade
;

#Finding districts with similarly sized Elementary Schools
-- Could do this for PK, MS, or HS as well

WITH cte AS (
SELECT
	District_Name,
    Total,
    PK AS Total_in_PK,
    K + 1st + 2nd + 3rd + 4th AS Total_in_ES,
    5th + 6th + 7th + 8th AS Total_in_MS,
    9th + 10th + 11th + 12th AS Total_in_HS,
    SP AS Total_Outplaced,
    ROW_NUMBER() OVER(ORDER BY K + 1st + 2nd + 3rd + 4th DESC) AS Row_Num #this would change for school type
FROM enrollment_grade
),
cte2 AS (
SELECT
	Row_Num
FROM cte
WHERE District_Name = 'Hopedale'
)
SELECT cte.*
FROM cte, cte2
WHERE cte2.Row_Num - 3 <= cte.Row_Num AND cte.Row_Num<= cte2.Row_Num +3;

# Finding districts with similar special populations
-- Focus on the First Language not English and ELL
-- WITHOUT taking into account size of student population

WITH cte1 AS(
SELECT District_Name, FL_Not_English_Num, FL_Not_English_Percent, ELL_Num, ELL_Percent,
	ROW_NUMBER () OVER(ORDER BY FL_Not_English_Percent DESC, ELL_Percent DESC) AS Row_Num
FROM Enrollment_SelectedPop
),
cte2 AS(
SELECT Row_Num
FROM cte1
WHERE District_Name = 'Hopedale'
)
SELECT cte1.*
FROM cte1, cte2
WHERE cte1.Row_Num >= cte2.Row_Num - 3 AND cte1.Row_Num <= cte2.Row_Num +3;
;

-- Focus on the First Language not English and ELL
-- WITH taking into account size of student population

WITH cte1 AS(
SELECT s.District_Name, s.FL_Not_English_Num, s.FL_Not_English_Percent, s.ELL_Num, s.ELL_Percent,
	g.Total
FROM Enrollment_SelectedPop s
JOIN enrollment_grade g ON s.District_Code = g.District_Code
),
cte2 AS(
SELECT District_Name, Total
FROM cte1
WHERE District_Name = 'Hopedale'
),
cte3 AS(
SELECT cte1.*,
	ROW_NUMBER () OVER(ORDER BY s.FL_Not_English_Percent DESC, s.ELL_Percent DESC) AS Row_Num
FROM cte1, cte2
WHERE cte1.Total >= cte2.Total -200 AND cte1.Total <= cte2.Total
),
cte4 AS(
SELECT District_Name, Row_Num
FROM cte3
WHERE District_Name = 'Hopedale'
)
SELECT cte3.*
FROM cte3, cte4
WHERE cte3.Row_Num >= cte4.Row_Num -3 AND cte3.Row_Num <= cte4.Row_Num +3;

SELECT * FROM Enrollment_SelectedPop;
SELECT * FROM enrollment_grade;

-- Focus on Students with disabilities
-- WITHOUT taking into account size of student population

WITH cte1 AS(
SELECT District_Name, Students_With_Disabilities_Percent,
	ROW_NUMBER () OVER(ORDER BY Students_With_Disabilities_Percent DESC) AS Row_Num
FROM Enrollment_SelectedPop
),
cte2 AS(
SELECT District_Name, Row_Num
FROM cte1
WHERE District_Name = 'Hopedale'
)
SELECT cte1.*
FROM cte1,cte2
WHERE cte1.Row_Num >= cte2.Row_Num -3 AND cte1.Row_Num <= cte2.Row_Num +3
;

-- Focus on Students with disabilities
-- WITH taking into account size of student population

WITH cte1 AS(
SELECT s.District_Name, s.Students_With_Disabilities_Percent,
	g.Total
FROM Enrollment_SelectedPop s
JOIN enrollment_grade g ON g.District_Code = s.District_Code
),
cte2 AS (
SELECT District_Name, Total
FROM cte1
WHERE District_Name = 'Hopedale'
),
cte3 AS(
SELECT cte1.*,
	ROW_NUMBER () OVER(ORDER BY Students_With_Disabilities_Percent DESC) AS Row_Num
FROM cte1, cte2
WHERE cte1.Total >= cte2.Total -200 AND cte1.Total <= cte2.Total +200
),
cte4 AS(
SELECT District_Name, Row_Num
FROM cte3
WHERE District_Name = 'Hopedale'
)
SELECT cte3.*
FROM cte3, cte4
WHERE cte3.Row_Num >= cte4.Row_Num - 3 AND cte3.Row_Num <= cte4.Row_Num +3;


-- Focus on Economically Disadvantaged students
-- WITHOUT taking into account size of student population

WITH cte1 AS (
SELECT District_Name, Economically_Disadvantaged_Percent,
	ROW_NUMBER() OVER(ORDER BY Economically_Disadvantaged_Percent DESC) AS Row_Num
FROM Enrollment_SelectedPop
),
cte2 AS (
SELECT District_Name, Row_Num
FROM cte1
WHERE District_Name = 'Hopedale'
)
SELECT cte1.*
FROM cte1, cte2
WHERE cte1.Row_Num >= cte2.Row_Num -3 AND cte1.Row_Num <= cte2.Row_Num +3;

-- Focus on Economically Disadvantaged students
-- WITH taking into account size of student population

WITH cte1 AS(
SELECT s.District_Name, s.Economically_Disadvantaged_Percent,
	g.Total
FROM Enrollment_SelectedPop s
JOIN enrollment_grade g ON s.District_Code = g.District_Code
),
cte2 AS(
SELECT District_Name, Total
FROM cte1
WHERE District_Name = 'Hopedale'
),
cte3 AS (
SELECT cte1.*,
	ROW_NUMBER() OVER(ORDER BY Economically_Disadvantaged_Percent DESC) AS Row_Num
FROM cte1, cte2
WHERE cte1.Total >= cte2.Total -200 AND cte1.Total <= cte2.Total +200
),
cte4 AS (
SELECT District_Name, Row_Num
FROM cte3
WHERE District_Name = 'Hopedale'
)
SELECT cte3.*
FROM cte3, cte4
WHERE cte3.Row_Num >= cte4.Row_Num -3 AND cte3.Row_Num <= cte4.Row_Num +3;


#################
-- Query to see if there is relationship between some of the data
-- Goal is to allow leadership at DESE to see if there is correlation between a measurement and success
#################

-- We did much of this in Tableau, but we didn't look at the Advanced Courses impact on success
-- How does it impact Grad Rate?

SELECT * FROM advanced_courses;
SELECT * FROM Grad_rates;

-- First get the percentage of students completing advanced courses in each district
SELECT
	District_Name,
    District_Code,
    ROUND(Num_Students_Completing_Advanced / Total_Grade_11_12 * 100, 2) AS Percent_Advanced
FROM advanced_courses;

-- Join that data with the graduation rates (inner join, since many districts don't have High Schools)
SELECT
	a.District_Name,
    a.District_Code,
    ROUND(a.Num_Students_Completing_Advanced / a.Total_Grade_11_12 * 100, 2) AS Percent_Advanced,
    g.Percent_Graduated
FROM advanced_courses a
INNER JOIN Grad_rates g ON a.District_Code = g.District_Code;

-- Now to see if there is a connection with some regression analysis
-- First set our variables to x and y
-- Then get the averages of those two variables
WITH cte1 AS (
SELECT
	a.District_Name,
    a.District_Code,
    ROUND(a.Num_Students_Completing_Advanced / a.Total_Grade_11_12 * 100, 2) AS x,
    g.Percent_Graduated AS y
FROM advanced_courses a
INNER JOIN Grad_rates g ON a.District_Code = g.District_Code
)
SELECT 
	AVG(x) AS x_bar,
    AVG(y) AS y_bar
FROM cte1;

-- Next we have to get the slope
WITH cte1 AS (
SELECT
	ROUND(a.Num_Students_Completing_Advanced / a.Total_Grade_11_12 * 100, 2) AS x,
    g.Percent_Graduated AS y
FROM advanced_courses a
INNER JOIN Grad_rates g ON a.District_Code = g.District_Code
),
cte2 AS(
SELECT 
	x, AVG(x) OVER () AS x_bar,
    y, AVG(y) OVER () AS y_bar
FROM cte1)
SELECT
	SUM((x - x_bar) * (y - y_bar)) / SUM((x - x_bar) * (x - x_bar)) AS slope
FROM cte2;

-- Now we have to calculate the intercept
WITH cte1 AS (
SELECT
	ROUND(a.Num_Students_Completing_Advanced / a.Total_Grade_11_12 * 100, 2) AS x,
    g.Percent_Graduated AS y
FROM advanced_courses a
INNER JOIN Grad_rates g ON a.District_Code = g.District_Code
),
cte2 AS(
SELECT 
	x, AVG(x) OVER () AS x_bar,
    y, AVG(y) OVER () AS y_bar
FROM cte1), 
cte3 AS(
SELECT
	SUM((x - x_bar) * (y - y_bar)) / SUM((x - x_bar) * (x - x_bar)) AS slope,
    MAX(x_bar) AS x_bar_max,
    MAX(y_bar) AS y_bar_max
FROM cte2)
SELECT 
	slope,
    y_bar_max - x_bar_max * slope AS intercept
FROM cte3;

-- This gives our best fit regression line as: y = 0.49097121923762843x + 56.7868725112729

-- Now we have to find the Rsquared value
-- This shows the actual vs. predicted values
WITH cte1 AS (
SELECT
	ROUND(a.Num_Students_Completing_Advanced / a.Total_Grade_11_12 * 100, 2) AS x,
    g.Percent_Graduated AS y
FROM advanced_courses a
INNER JOIN Grad_rates g ON a.District_Code = g.District_Code
)
SELECT 
	x, 
    y, 
    0.49097121923762843 * x + 56.7868725112729 AS y_predicted
FROM cte1;

-- This goes further to give us the numbers we need including mean of y
WITH cte1 AS (
SELECT
	ROUND(a.Num_Students_Completing_Advanced / a.Total_Grade_11_12 * 100, 2) AS x,
    g.Percent_Graduated AS y
FROM advanced_courses a
INNER JOIN Grad_rates g ON a.District_Code = g.District_Code
), cte2 AS (
SELECT 
	x, 
    y, 
    0.49097121923762843 * x + 56.7868725112729 AS y_predicted
FROM cte1)
SELECT AVG(y) AS y_mean
FROM cte2;

-- Now we should be able to get our r squared value
WITH cte1 AS (
SELECT
	ROUND(a.Num_Students_Completing_Advanced / a.Total_Grade_11_12 * 100, 2) AS x,
    g.Percent_Graduated AS y
FROM advanced_courses a
INNER JOIN Grad_rates g ON a.District_Code = g.District_Code
), cte2 AS (
SELECT 
	x, 
    y, 
    0.49097121923762843 * x + 56.7868725112729 AS y_predicted
FROM cte1
), cte3 AS(
SELECT AVG(y) AS y_mean
FROM cte2)
SELECT
	1 - SUM(POWER(cte2.y - cte2.y_predicted, 2))/SUM(POWER(cte2.y - cte3.y_mean, 2)) AS r_squared
FROM cte2, cte3;

-- An R^2 value of 0.36856055424077483 suggests that the the number of advanced courses doesn't really impact grad rate