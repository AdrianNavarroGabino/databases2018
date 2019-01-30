-- Adri�n Navarro Gabino

-- EJERCICIO 12

-- Realiza un listado de JUGADORES que sea mayores de 20 a�os, que hayan
-- jugado en partidos que su equipo visitante empiecen por vocal (imaginar
-- que todo esta en MAY�SCULAS) o que hayan sido matriculados en el d�a de hoy.

SELECT NOMBRE
FROM JUGADOR, JUGAR
WHERE JUGADOR.NOMBRE=JUGAR.NOMBRE_JUG
    AND EDAD>20
    AND (EQUIPO_V_PART LIKE 'A%'
    OR EQUIPO_V_PART LIKE 'E%'
    OR EQUIPO_V_PART LIKE 'I%'
    OR EQUIPO_V_PART LIKE 'O%'
    OR EQUIPO_V_PART LIKE 'U%');