**Autor:** Cristian Camilo Cortes Ortiz

**código**: 202478542  

**Universidad del Valle**  

**Programa:** Tecnología en Desarrollo de software 

**Asignatura:** Bases de Datos

**Profesor:** Daniel Quintero Capera

**Fecha:** 18 Octubre 2025

---

### Taller 3

> Los puntos:

-  **PARTE 1: CREACIÓN DE TABLAS**
-  **PARTE 2: INSERTS**
-  **PARTE 3: CONSULTAS EN ÁLGEBRA RELACIONAL**

Están en el archivo:
```bash
taller-3.sql
```
-  **PARTE 4: ANÁLISIS Y REFLEXIÓN**

#### Preguntas:

---

#####  1. ¿Cuál es la diferencia entre UNION e INTERSECT en el contexto de este taller?

**`UNION`** Sirve cuando se necesita juntar el resultado de dos consultas distintas
sin que estas tengan relación entre ellas.

**`INTERSECT`** Sirve para encontrar lo que comparten dos consultas en común

---

##### 2. ¿En qué situaciones sería útil usar EXCEPT en consultas de bases de datos?

Cuando dentro de una consulta se necesitar filtrar o descartar los registros que
no cumplan con la condición definida.

---

##### 3. ¿Por qué el CROSS JOIN puede generar resultados muy grandes? ¿Cuándo es útil y cuándo no?

Porque realiza una operación aritmética al multiplicar la cantidad de filas de
cada tabla, por ejemplo:

En la consultas #12:

-- 22 estudiantes
-- 20 cursos
-- 32 inscripciones
-- 22 * 20 * 32 = 14080 combinaciones

Es útil cuando se necesitan todas las combinaciones posibles entre las tablas

No es útil cuando la consulta deba implementar llaves foráneas, para eso se puede
utilizar los **`JOIN`**

---

##### 4. ¿Qué restricciones deben cumplir dos relaciones para poder realizar UNION, INTERSECT o EXCEPT entre ellas?

Para poder unir dos consultas a través de **`UNION`**, **`INTERSECT`**, **`EXCEPT`** 
ambas consultas deben de compartir las mismas columnas, ya que la segunda consulta
trabaja sobre la primera así que debe haber consistencia entre ellas.

---

##### 5. Explique con un ejemplo de este taller cómo se puede combinar CROSS JOIN con otras operaciones del álgebra relacional para obtener resultados útiles.

```SQL
-------------------------------------
-- Consulta 8: CROSS JOIN
-- Como yo tengo varias carreras de ingeniería,
-- pues entonces voy a filtrar por la Ingeniería de Sistemas 
SELECT e.id_estudiante, e.nombre, e.apellido, 
c.id_curso, c.nombre_curso, c.creditos
FROM estudiantes e
CROSS JOIN cursos c
JOIN carreras cr ON cr.id_carrera = e.id_carrera
WHERE c.id_carrera = 
(SELECT id_carrera FROM carreras 
    WHERE nombre_carrera = 'Ingeniería de Sistemas')
    AND (c.creditos > 3);
-------------------------------------
```

En este caso el **`CROSS JOIN`** realiza el producto cartesiano entre las tablas
**`Estudiantes`** con 22 registros y **`Cursos`** con 20 registros dando un total de 
22 * 20 = 440. Pero agregando otra clausula o condición se puede realizar un
producto cartesiano más exacto y que cumplan con criterios de búsqueda más
específicos.

---