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
