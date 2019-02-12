-- Adrián Navarro Gabino

-- EJERCICIO 4

--  Jugadores que hayan jugado más de 90 minutos ordenados por
-- nombre descendentemente

SELECT NOMBRE_JUG
FROM JUGAR
WHERE MIN_JUGAR>90
ORDER BY NOMBRE_JUG DESC;