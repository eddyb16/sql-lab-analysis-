-- =============================================
-- PROJECT: Microbiology Lab Analysis
-- AUTHOR: Edibo
-- TOOLS: SQLite / DB Fiddle
-- TOPICS: SELECT, WHERE, JOIN, COUNT, GROUP BY
-- =============================================


-- =============================================
-- SECTION 1: CREATE TABLES
-- =============================================

CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    full_name VARCHAR(50),
    age INT,
    gender VARCHAR(10),
    state VARCHAR(30)
);

CREATE TABLE samples (
    sample_id INT PRIMARY KEY,
    patient_id INT,
    sample_type VARCHAR(30),
    collection_date DATE,
    technician VARCHAR(30)
);

CREATE TABLE lab_results (
    result_id INT PRIMARY KEY,
    sample_id INT,
    organism VARCHAR(50),
    test_type VARCHAR(30),
    result VARCHAR(20),
    antibiotic VARCHAR(30),
    sensitivity VARCHAR(20)
);


-- =============================================
-- SECTION 2: INSERT DATA
-- =============================================

INSERT INTO patients VALUES
(1, 'Amina Bello', 34, 'Female', 'Niger State'),
(2, 'Chukwu Eze', 45, 'Male', 'Anambra'),
(3, 'Fatima Usman', 28, 'Female', 'Kano'),
(4, 'Tunde Adeyemi', 52, 'Male', 'Lagos'),
(5, 'Grace Obi', 19, 'Female', 'Enugu'),
(6, 'Ibrahim Musa', 60, 'Male', 'Sokoto'),
(7, 'Ngozi Nwosu', 37, 'Female', 'Rivers'),
(8, 'Emeka Okafor', 41, 'Male', 'Delta'),
(9, 'Hauwa Sule', 25, 'Female', 'Kaduna'),
(10, 'Biodun Adewale', 33, 'Male', 'Ogun');

INSERT INTO samples VALUES
(101, 1, 'Urine', '2024-01-05', 'Dr. Salisu'),
(102, 2, 'Blood', '2024-01-07', 'Dr. Nneka'),
(103, 3, 'Stool', '2024-01-10', 'Dr. Salisu'),
(104, 4, 'Wound Swab', '2024-01-12', 'Dr. Emeka'),
(105, 5, 'Urine', '2024-01-15', 'Dr. Nneka'),
(106, 6, 'Blood', '2024-01-18', 'Dr. Emeka'),
(107, 7, 'Sputum', '2024-01-20', 'Dr. Salisu'),
(108, 8, 'Urine', '2024-01-22', 'Dr. Nneka'),
(109, 9, 'Blood', '2024-01-25', 'Dr. Emeka'),
(110, 10, 'Wound Swab', '2024-01-28', 'Dr. Salisu');

INSERT INTO lab_results VALUES
(201, 101, 'E. coli', 'Culture', 'Positive', 'Ciprofloxacin', 'Resistant'),
(202, 101, 'E. coli', 'Culture', 'Positive', 'Amoxicillin', 'Sensitive'),
(203, 102, 'S. aureus', 'Culture', 'Positive', 'Methicillin', 'Resistant'),
(204, 103, 'Salmonella', 'Culture', 'Positive', 'Ampicillin', 'Sensitive'),
(205, 104, 'Pseudomonas', 'Culture', 'Positive', 'Ciprofloxacin', 'Sensitive'),
(206, 105, 'E. coli', 'Culture', 'Negative', NULL, NULL),
(207, 106, 'S. typhi', 'Widal', 'Positive', 'Chloramphenicol', 'Sensitive'),
(208, 107, 'M. tuberculosis', 'ZN Stain', 'Positive', 'Rifampicin', 'Sensitive'),
(209, 108, 'Klebsiella', 'Culture', 'Positive', 'Gentamicin', 'Resistant'),
(210, 109, 'S. aureus', 'Culture', 'Negative', NULL, NULL),
(211, 110, 'Pseudomonas', 'Culture', 'Positive', 'Meropenem', 'Sensitive');


-- =============================================
-- SECTION 3: ANALYSIS QUERIES
-- =============================================

-- Q1: Patients from Niger State
SELECT *
FROM patients
WHERE state = 'Niger State';

-- Q2: Patients with positive lab results
SELECT DISTINCT patients.full_name
FROM patients
JOIN samples ON patients.patient_id = samples.patient_id
JOIN lab_results ON samples.sample_id = lab_results.sample_id
WHERE lab_results.result = 'Positive';

-- Q3: Number of samples collected per technician
SELECT technician, COUNT(*) AS total_samples
FROM samples
GROUP BY technician;

-- Q4: Organisms resistant to antibiotics
SELECT organism, antibiotic, sensitivity
FROM lab_results
WHERE sensitivity = 'Resistant';

-- Q5: Patients who had Blood samples
SELECT patients.full_name, samples.sample_type
FROM patients
JOIN samples ON patients.patient_id = samples.patient_id
WHERE samples.sample_type = 'Blood';

-- Q6: Patients older than 40
SELECT full_name, age
FROM patients
WHERE age > 40;

-- Q7: Patient names and organisms found in their samples
SELECT patients.full_name, lab_results.organism
FROM patients
JOIN samples ON patients.patient_id = samples.patient_id
JOIN lab_results ON samples.sample_id = lab_results.sample_id;

-- Q8: Count of Male and Female patients
SELECT gender, COUNT(*) AS total
FROM patients
GROUP BY gender;

-- Q9: Resistant patients from Kano or Lagos
SELECT patients.full_name, patients.state, lab_results.sensitivity
FROM patients
JOIN samples ON patients.patient_id = samples.patient_id
JOIN lab_results ON samples.sample_id = lab_results.sample_id
WHERE lab_results.sensitivity = 'Resistant'
AND (patients.state = 'Kano' OR patients.state = 'Lagos');

-- Q10: Technicians and total positive results recorded
SELECT samples.technician, COUNT(*) AS total_positive
FROM samples
JOIN lab_results ON samples.sample_id = lab_results.sample_id
WHERE lab_results.result = 'Positive'
GROUP BY technician;
