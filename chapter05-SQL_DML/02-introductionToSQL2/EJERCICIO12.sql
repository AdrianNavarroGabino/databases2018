-- Adrián Navarro Gabino

-- EJERCICIO 12

-- Realiza un listado de JUGADORES que sea mayores de 20 años, que hayan
-- jugado en partidos que su equipo visitante empiecen por vocal (imaginar
-- que todo esta en MAYÚSCULAS) o que hayan sido matriculados en el día de hoy.

SELECT NOMBRE
FROM JUGADOR, JUGAR
WHERE JUGADOR.NOMBRE=JUGAR.NOMBRE_JUG
    AND EDAD>20
    AND (EQUIPO_V_PART LIKE 'A%'
    OR EQUIPO_V_PART LIKE 'E%'
    OR EQUIPO_V_PART LIKE 'I%'
    OR EQUIPO_V_PART LIKE 'O%'
    OR EQUIPO_V_PART LIKE 'U%');