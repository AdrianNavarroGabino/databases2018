-- Adrián Navarro Gabino

-- EJERCICIO 6

-- Añadir el campo EDAD a la tabla JUGADORES. Actualizar este campo de la
-- siguiente manera:
-- a. Los JUGADORES que empiecen o acaben en VOCAL 25
-- b. Los JUGADORES que la segunda letra de su nombre tenga VOCAL 20
-- c. Los JUGADORES que tengan la cadena es o ES entremedio de su nombre
-- (ni al principio ni al final) 18
-- d. Los demás casos 15
-- e. Una vez actualizados todos, realizar la sentencia necesaria
-- para que la EDAD nunca pueda ser NULA


ALTER TABLE JUGADOR ADD
(
    EDAD VARCHAR2(2)
);

UPDATE JUGADOR
    SET EDAD=25
WHERE NOMBRE LIKE '%A'
   OR NOMBRE LIKE '%E' 
   OR NOMBRE LIKE '%I'
   OR NOMBRE LIKE '%O'
   OR NOMBRE LIKE '%U'
   OR NOMBRE LIKE 'A%'
   OR NOMBRE LIKE 'E%'
   OR NOMBRE LIKE 'I%'
   OR NOMBRE LIKE 'O%'
   OR NOMBRE LIKE 'U%';
   
UPDATE JUGADOR
    SET EDAD=20
WHERE EDAD IS NULL AND
     (NOMBRE LIKE '_A%'
   OR NOMBRE LIKE '_E%'
   OR NOMBRE LIKE '_I%'
   OR NOMBRE LIKE '_O%'
   OR NOMBRE LIKE '_U%');
   
UPDATE JUGADOR
    SET EDAD=18
WHERE EDAD IS NULL AND
     (NOMBRE LIKE '%_ES_%'
   OR NOMBRE LIKE '%_es_%')
  AND NOMBRE NOT LIKE 'ES%'
  AND NOMBRE NOT LIKE '%ES'
  AND NOMBRE NOT LIKE 'es%'
  AND NOMBRE NOT LIKE '%es';
  
UPDATE JUGADOR
    SET EDAD=15
WHERE EDAD IS NULL;

ALTER TABLE JUGADOR MODIFY
(
    EDAD NOT NULL
);