-- Adrián Navarro Gabino

-- EJERCICIO 2

-- Obtén las distintas nacionalidades de los árbitros, no deben salir repetidos.

SELECT DISTINCT NACIONALIDAD
FROM ARBITRO
WHERE NACIONALIDAD IS NOT NULL;