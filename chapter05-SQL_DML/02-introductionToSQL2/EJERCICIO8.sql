-- Adrián Navarro Gabino

-- EJERCICIO 8

-- Realiza el listado anterior usando ANY

SELECT *
FROM JUGADOR
WHERE EDAD=ANY(SELECT EDAD FROM JUGADOR WHERE EDAD>=20);