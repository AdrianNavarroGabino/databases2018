-- Adrián Navarro Gabino

-- EJERCICIO 3

-- Un listado con el nombre de los jugadores de ESPAÑA y los minutos que
-- hayan jugado partidos en cada partido.

SELECT NOMBRE, MIN_JUGAR
FROM JUGADOR, JUGAR
WHERE NOMBRE=NOMBRE_JUG AND EQUIPO_JUGADOR='ESPAÑA'
ORDER BY NOMBRE;