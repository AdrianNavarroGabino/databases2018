-- Adri�n Navarro Gabino

-- EJERCICIO 11

-- Obt�n el nombre de cada JUGADOR, pero que aparezca concatenado
-- con el literal �La edad de XXXX ser�: � y a la derecha de su nombre
-- que aparezca la edad que tendr�a en el d�a de hoy pero del a�o 2050.
-- Debes usar SYSDATE.

SELECT 'La edad de '||NOMBRE||' sera:' AS NOMBRE,
    2050 - TO_CHAR(SYSDATE, 'YYYY') + EDAD AS EDAD
FROM JUGADOR;