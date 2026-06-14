# Microbiology Lab SQL Analysis

## Project Overview
This project analyzes a microbiology lab database containing patient records, 
sample collections, and lab results from a fictional Nigerian clinical setting. 
It was built as part of my data analysis learning journey to practice core SQL skills.

## Tools Used
- SQLite / DB Fiddle
- GitHub

## Database Structure
Three related tables:

- **patients** — patient demographics (name, age, gender, state)
- **samples** — sample collection records (sample type, date, technician)
- **lab_results** — test results (organism, antibiotic, sensitivity)

## SQL Concepts Covered
- SELECT, WHERE, DISTINCT
- JOIN across 3 tables
- COUNT and GROUP BY
- AND, OR with brackets
- HAVING
- UNION
- Window Functions: RANK(), ROW_NUMBER(), AVG(), COUNT() running total
- CTEs (Common Table Expressions) including multiple CTEs

## Questions Answered
1. Which patients are from Niger State?
2. Which patients had positive lab results?
3. How many samples did each technician collect?
4. Which organisms showed antibiotic resistance?
5. Which patients had Blood samples collected?
6. Which patients are older than 40?
7. What organisms were found in each patient's sample?
8. How many Male and Female patients are in the database?
9. Which patients from Kano or Lagos had Resistant results?
10. How many positive results did each technician record?
11. Rank patients by age oldest to youngest
12. Row number partitioned by organism
13. Average age of patients within the same state shown alongside each row
14. Running total of samples collected
15. CTE to get positive results then filter for Resistant
16. CTE to show technicians with more than 2 samples
17. Multiple CTEs to join patients older than 35 with their sample types

## About Me
Microbiology graduate transitioning into data analysis. 
Currently building skills in SQL, Excel, and Python on a self-taught journey.
