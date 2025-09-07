CREATE DATABASE courses_manager;
\c courses_manager;

-- Estudiantes
CREATE TABLE Students (
    id_student INT NOT NULL UNIQUE,
    name VARCHAR(200) NOT NULL,
    address VARCHAR(200) NOT NULL,
    email VARCHAR(200) NOT NULL UNIQUE,
    registration_number_student INT PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Profesores
CREATE TABLE Professors (
    id_professor INT NOT NULL UNIQUE,
    name VARCHAR(200) NOT NULL,
    address VARCHAR(200) NOT NULL,
    email VARCHAR(200) NOT NULL UNIQUE,
    registration_number_professor INT PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Cursos
CREATE TABLE Courses (
    id_course INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    registration_number_professor INT NOT NULL,
    FOREIGN KEY (registration_number_professor) REFERENCES Professors(registration_number_professor),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Inscripciones
CREATE TABLE Inscriptions (
    id_course INT NOT NULL,
    registration_number_student INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (registration_number_student, id_course),
    FOREIGN KEY (id_course) REFERENCES Courses(id_course),
    FOREIGN KEY (registration_number_student) REFERENCES Students(registration_number_student)
);

-- Calificaciones
CREATE TABLE Qualifications (
    id_course INT NOT NULL,
    registration_number_student INT NOT NULL,
    note DECIMAL(3,1) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (registration_number_student, id_course),
    FOREIGN KEY (id_course) REFERENCES Courses(id_course),
    FOREIGN KEY (registration_number_student) REFERENCES Students(registration_number_student)
);

-- Insertar 10 estudiantes
INSERT INTO Students (id_student, name, address, email, registration_number_student)
VALUES
(103432154, 'Juan Pérez', 'Calle 1 # 2-3', 'juanp@uni.edu.co', 2025432754),
(103345376, 'María Gómez', 'Calle 4 # 5-6', 'mariag@uni.edu.co', 2025897632),
(105643287, 'Luis Torres', 'Calle 7 # 8-9', 'luist@uni.edu.co', 2025453414),
(104312321, 'Sofía Castro', 'Calle 10 # 11-12', 'sofiac@uni.edu.co', 2025342123),
(103456341, 'Pedro Morales', 'Calle 13 # 14-15', 'pedrom@uni.edu.co', 2025434213),
(103563532, 'Laura Ríos', 'Calle 16 # 17-18', 'laurar@uni.edu.co', 2025431212),
(104534212, 'Andrés Silva', 'Calle 19 # 20-21', 'andress@uni.edu.co', 2025345678),
(103256732, 'Camila Vargas', 'Calle 22 # 23-24', 'camilav@uni.edu.co', 2025433212),
(104532112, 'Felipe Herrera', 'Calle 25 # 26-27', 'felipeh@uni.edu.co', 2025435763),
(103345678, 'Valentina Cruz', 'Calle 28 # 29-30', 'valentinac@uni.edu.co', 2025432121);

-- Insertar 3 profesores
INSERT INTO Professors (id_professor, name, address, email, registration_number_professor)
VALUES
(1046543321, 'Carlos Lopez', 'Carrera 23 # 34 - 56', 'carlos.lopez@uni.edu.co', 2025453322),
(1034567354, 'Ana Marquez', 'Carrera 54 # 87 - 16', 'ana.marquez@uni.edu.co', 2025453321),
(1034212792, 'Jorge Ramirez', 'Carrera 65 # 34 - 36', 'jorge.ramires@uni.edu.co', 2025453432);

-- Insertar Cursos
INSERT INTO Courses (name, registration_number_professor)
VALUES
('Matemáticas básicas', 2025453322),
('Desarrollo de software', 2025453432),
('Arquitectura distribuida', 2025453432),
('Bases de datos', 2025453321),
('Análisis de Datos', 2025453432);

-- Insertar inscripciones
INSERT INTO Inscriptions (id_course, registration_number_student)
VALUES
(1, 2025432754), (3, 2025432754),
(2, 2025897632), (4, 2025897632),
(1, 2025453414), (3, 2025453414),
(2, 2025342123), (4, 2025342123),
(1, 2025434213), (3, 2025434213),
(2, 2025431212), (4, 2025431212),
(1, 2025345678), (3, 2025345678),
(2, 2025433212), (4, 2025433212),
(1, 2025435763), (3, 2025435763),
(2, 2025432121), (4, 2025432121);

-- Insertar calificaciones
INSERT INTO Qualifications (id_course, registration_number_student, note)
VALUES
(1, 2025432754, 4.1), (3, 2025432754, 3.4),
(2, 2025897632, 3.9), (4, 2025897632, 4.5),
(1, 2025453414, 4.5), (3, 2025453414, 4.7),
(2, 2025342123, 4.3), (4, 2025342123, 3.7),
(1, 2025434213, 4.5), (3, 2025434213, 4.6),
(2, 2025431212, 2.8), (4, 2025431212, 4.5),
(1, 2025345678, 5.0), (3, 2025345678,4.8),
(2, 2025433212, 4.3), (4, 2025433212, 4.4),
(1, 2025435763, 4.2), (3, 2025435763, 4.2),
(2, 2025432121, 3.9), (4, 2025432121, 4.1);

-- Consultas:

-- 1. Obtener todos los estudiantes registrados en la base de datos.
SELECT * from Students;

-- 2. Obtener todos los cursos junto con el nombre del profesor que los imparte.
SELECT Courses.id_course, Courses.name, Professors.name
FROM Courses
JOIN Professors ON Courses.registration_number_professor = Professors.registration_number_professor;

-- 3. Obtener todos los estudiantes que se han inscrito en un curso específico.
SELECT Students.id_student, Students.name, Students.registration_number_student, Courses.name
FROM Students
JOIN Inscriptions ON Inscriptions.registration_number_student = Students.registration_number_student
JOIN Courses ON Courses.id_course = Inscriptions.id_course
WHERE Inscriptions.id_course = 3;

-- 4. Obtener los cursos en los que un estudiante específico.
SELECT Courses.id_course, Courses.name, Students.registration_number_student, Students.name
FROM Courses
JOIN Inscriptions ON Inscriptions.id_course = Courses.id_course
JOIN Students ON Students.registration_number_student = Inscriptions.registration_number_student
WHERE Students.registration_number_student = 2025453414;

-- 5. Obtener los estudiantes y sus calificaciones en un curso específico.
SELECT Students.registration_number_student, Students.name, Courses.name, Qualifications.note
FROM Students
JOIN Qualifications ON Qualifications.registration_number_student = Students.registration_number_student
JOIN Inscriptions ON Inscriptions.registration_number_student = Students.registration_number_student
JOIN Courses ON Courses.id_course = Inscriptions.id_course
WHERE Inscriptions.id_course = 3;

-- 6. Obtener la promedio de calificación de los estudiantes en un curso.
SELECT Courses.id_course, Courses.name, AVG(Qualifications.note) AS average
FROM Qualifications
JOIN Courses ON Courses.id_course = Qualifications.id_course
WHERE Courses.id_course = 1
GROUP BY Courses.id_course, Courses.name;

-- 7. Obtener los profesores que enseñan más de 2 cursos.
SELECT Professors.registration_number_professor, Professors.name, COUNT(Courses.id_course) AS Total_courses
FROM Professors
JOIN Courses ON Professors.registration_number_professor = Courses.registration_number_professor
GROUP BY Professors.registration_number_professor
ORDER BY Total_courses DESC
LIMIT 1;

-- 8. obtener cursos sin estudiantes inscritos.
SELECT Courses.id_course, Courses.name
FROM Courses
WHERE NOT EXISTS (
    SELECT 1
    FROM Inscriptions
    WHERE Inscriptions.id_course = Courses.id_course
);