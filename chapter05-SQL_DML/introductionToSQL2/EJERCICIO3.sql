-- Adri�n Navarro Gabino

-- EJERCICIO 3

-- Un listado con el nombre de los jugadores de ESPA�A y los minutos que
-- hayan jugado partidos en cada partido.

SELECT NOMBRE, MIN_JUGAR
FROM JUGADOR, JUGAR
WHERE NOMBRE=NOMBRE_JUG AND EQUIPO_JUGADOR='ESPA�A'
ORDER BY NOMBRE;