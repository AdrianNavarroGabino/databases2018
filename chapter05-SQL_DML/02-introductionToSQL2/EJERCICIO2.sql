-- Adri�n Navarro Gabino

-- EJERCICIO 2

-- Obt�n las distintas nacionalidades de los �rbitros, no deben salir repetidos.

SELECT DISTINCT NACIONALIDAD
FROM ARBITRO
WHERE NACIONALIDAD IS NOT NULL;