-------------------------------------
-- Crear la BBDD
-------------------------------------
CREATE DATABASE taller_3;

-------------------------------------
--      TABLAS
-------------------------------------

-- Entidad Carreras
CREATE TABLE Carreras (
    id_carrera          SERIAL PRIMARY KEY,
    nombre_carrera      VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Profesores (
    id_profesor         SERIAL PRIMARY KEY,
    nombre              VARCHAR(50) NOT NULL,
    apellido            VARCHAR(50) NOT NULL,
    edad                INT NOT NULL,
                        CONSTRAINT chk_profesor_edad CHECK (edad >= 0 AND edad <= 120)
);

CREATE TABLE Estudiantes (
    id_estudiante       SERIAL PRIMARY KEY,
    nombre              VARCHAR(50) NOT NULL,
    apellido            VARCHAR(50) NOT NULL,
    edad                INT NOT NULL,
    id_carrera          INT NOT NULL,
                        CONSTRAINT chk_estudiante_edad CHECK (edad >= 0 AND edad <= 120)
);

CREATE TABLE Cursos (
    id_curso            SERIAL PRIMARY KEY,
    nombre_curso        VARCHAR(50) NOT NULL UNIQUE,
    creditos            INT NOT NULL,
    id_profesor         INT NOT NULL,
    id_carrera          INT NOT NULL
);

CREATE TABLE Inscripciones (
    id_inscripcion      SERIAL PRIMARY KEY,
    id_estudiante       INT NOT NULL,
    id_curso            INT NOT NULL,
    semestre            INT NOT NULL,
    nota                DECIMAL(4,2) NOT NULL,
                        CONSTRAINT chk_semestre CHECK (semestre >= 1 AND semestre <= 12)
);

-------------------------------------
--      LLAVES FORÁNEAS
-------------------------------------

-- Estudiantes - Carreras (N:N)
ALTER TABLE Estudiantes
ADD CONSTRAINT fk_estudiante_carrera
FOREIGN KEY (id_carrera)
REFERENCES Carreras(id_carrera);

-- Cursos - Profesores (N:1)
ALTER TABLE Cursos
ADD CONSTRAINT fk_curso_profesor
FOREIGN KEY (id_profesor)
REFERENCES Profesores(id_profesor);

-- Cursos - Carreras (N:1)
ALTER TABLE Cursos
ADD CONSTRAINT fk_curso_carrera
FOREIGN KEY (id_carrera)
REFERENCES Carreras(id_carrera);

-- Inscripciones - Estudiantes (N:1)
ALTER TABLE Inscripciones
ADD CONSTRAINT fk_inscripcion_estudiante
FOREIGN KEY (id_estudiante)
REFERENCES Estudiantes(id_estudiante);

-- Inscripciones - Cursos (N:1)
ALTER TABLE Inscripciones
ADD CONSTRAINT fk_inscripcion_curso
FOREIGN KEY (id_curso)
REFERENCES Cursos(id_curso);


-------------------------------------
--      INSERCIÓN DE DATOS
-------------------------------------
-- Generé los datos con ayuda de IA
-------------------------------------

-- Carreras
INSERT INTO Carreras (nombre_carrera) VALUES
('Ingeniería de Sistemas'),
('Ingeniería Industrial'),
('Ingeniería Electrónica'),
('Administración de Empresas'),
('Contaduría Pública'),
('Diseño Gráfico'),
('Psicología'),
('Derecho'),
('Medicina'),
('Arquitectura');

-- Profesores
INSERT INTO Profesores (nombre, apellido, edad) VALUES
('Carlos', 'Ramírez', 45),
('Ana', 'Torres', 39),
('Luis', 'Pérez', 50),
('María', 'Gómez', 41),
('Jorge', 'Martínez', 37),
('Paula', 'Salazar', 48),
('Ricardo', 'Mendoza', 44),
('Lucía', 'Fernández', 36),
('Andrés', 'Vargas', 55),
('Sofía', 'Herrera', 40);

-- Cursos
INSERT INTO Cursos (nombre_curso, creditos, id_profesor, id_carrera) VALUES
('Programación I', 3, 1, 1),
('Estructuras de Datos', 4, 1, 1),

('Procesos Industriales', 3, 2, 2),
('Logística I', 3, 2, 2),

('Circuitos I', 4, 3, 3),
('Electrónica Digital', 4, 3, 3),

('Fundamentos de Administración', 3, 4, 4),
('Marketing I', 3, 4, 4),

('Contabilidad Básica', 3, 5, 5),
('Costos y Presupuestos', 3, 5, 5),

('Diseño Básico', 3, 6, 6),
('Tipografía', 2, 6, 6),

('Introducción a la Psicología', 3, 7, 7),
('Neurociencias', 3, 7, 7),

('Derecho Constitucional', 3, 8, 8),
('Derecho Penal', 3, 8, 8),

('Anatomía I', 4, 9, 9),
('Fisiología', 4, 9, 9),

('Historia de la Arquitectura', 3, 10, 10),
('Diseño Arquitectónico I', 4, 10, 10);

-- Estudiantes
INSERT INTO Estudiantes (nombre, apellido, edad, id_carrera) VALUES
('Juan', 'Pérez', 20, 1),
('Camila', 'Rojas', 22, 1),

('Andrés', 'García', 21, 2),
('Valentina', 'Ruiz', 23, 2),

('Mateo', 'López', 19, 3),
('Sara', 'Torres', 20, 3),

('Daniel', 'Martínez', 24, 4),
('Laura', 'Gómez', 21, 4),

('Felipe', 'Castro', 22, 5),
('Paula', 'Sánchez', 23, 5),

('Carolina', 'Ramírez', 20, 6),
('Diana', 'Morales', 19, 6),

('Esteban', 'Muñoz', 21, 7),
('Juliana', 'Hernández', 22, 7),

('Leonardo', 'Vega', 23, 8),
('Natalia', 'Córdoba', 24, 8),

('Sebastián', 'Ocampo', 20, 9),
('Mariana', 'Quintero', 21, 9),

('Tomás', 'Salazar', 19, 10),
('Isabela', 'Fernández', 20, 10);

-- Inscripciones
INSERT INTO Inscripciones (id_estudiante, id_curso, semestre, nota) VALUES
-- Ingeniería de Sistemas
(1, 1, 1, 4.5),
(1, 2, 1, 3.8),
(2, 1, 1, 4.0),
(2, 2, 1, 4.2),

-- Ingeniería Industrial
(3, 3, 2, 3.9),
(3, 4, 2, 4.1),
(4, 3, 2, 4.4),

-- Electrónica
(5, 5, 1, 3.5),
(6, 6, 1, 4.7),
(5, 6, 1, 4.0),

-- Administración
(7, 7, 3, 4.3),
(8, 8, 3, 3.7),

-- Contaduría
(9, 9, 1, 4.6),
(10, 10, 1, 3.9),

-- Diseño Gráfico
(11, 11, 2, 4.1),
(12, 12, 2, 3.6),

-- Psicología
(13, 13, 4, 4.8),
(14, 14, 4, 3.5),

-- Derecho
(15, 15, 3, 4.0),
(16, 16, 3, 4.4);