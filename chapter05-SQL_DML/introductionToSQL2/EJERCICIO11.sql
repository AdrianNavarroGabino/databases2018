-- Adrián Navarro Gabino

-- EJERCICIO 11

-- Obtén el nombre de cada JUGADOR, pero que aparezca concatenado
-- con el literal ‘La edad de XXXX será: ’ y a la derecha de su nombre
-- que aparezca la edad que tendría en el día de hoy pero del año 2050.
-- Debes usar SYSDATE.

SELECT 'La edad de '||NOMBRE||' sera:' AS NOMBRE,
    2050 - TO_CHAR(SYSDATE, 'YYYY') + EDAD AS EDAD
FROM JUGADOR;