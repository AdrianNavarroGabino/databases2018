-- Adri�n Navarro Gabino

-- EJERCICIO 1

-- Saca los jugadores y �rbitros con el mismo n�mero de caracteres en su
-- nombres.

SELECT JU.NOMBRE AS NOMBRE_JUGADOR
FROM JUGADOR JU, ARBITRO AR
WHERE LENGTH(JU.NOMBRE)=LENGTH(AR.NOMBRE);
UNION
SELECT AR.NOMBRE AS NOMBRE_ARBITRO
FROM JUGADOR JU, ARBITRO AR
WHERE LENGTH(JU.NOMBRE)=LENGTH(AR.NOMBRE);

-- EJERCICIO 2

-- Saca los jugadores de m�s de 25 a�os y qu�tales todos los que no sean de
-- ESPA�A usando MINUS, comprueba que sale el mismo resultado que con una
-- consulta simple.

SELECT *
FROM JUGADOR
WHERE EDAD>25
MINUS
SELECT *
FROM JUGADOR
WHERE EQUIPO_JUGADOR!='ESPA�A';

SELECT *
FROM JUGADOR
WHERE EDAD>25 AND EQUIPO_JUGADOR!='ESPA�A';

-- EJERCICIO 3

-- Nombre de directores que tienen una �A� en su nombre que su tercera letra
-- no es consonante y su longitud es mayor que 5 o que no tienen director
-- controlador y a todo esto �nele sacando duplicados directores con escalas
-- en ESPA�A. 

((SELECT NOMBRE
FROM DIRECTOR
WHERE NOMBRE LIKE '%A%'
INTERSECT
SELECT NOMBRE
FROM DIRECTOR
WHERE UPPER(NOMBRE) LIKE '__A%'
    OR UPPER(NOMBRE) LIKE '__E%'
    OR UPPER(NOMBRE) LIKE '__I%'
    OR UPPER(NOMBRE) LIKE '__O%'
    OR UPPER(NOMBRE) LIKE '__U%'
INTERSECT
SELECT NOMBRE
FROM DIRECTOR
WHERE LENGTH(NOMBRE)>5)
UNION
SELECT NOMBRE
FROM DIRECTOR
WHERE DNI_CONTR IS NULL)
UNION ALL
SELECT DIR.NOMBRE
FROM DIRECTOR DIR, TENER_ESCALA ESC, AEROPUERTOS AER
WHERE DIR.COD_AEROPUERTO=ESC.COD_AEROPUERTO
    AND ESC.COD_AEROPUERTO=AER.CODIGO
    AND AER.PAIS='ESPA�A';
   
-- EJERCICIO 4

-- Nombre de directores que tienen una �A� en su nombre que su tercera letra
-- es consonante y su longitud es mayor que 4 y que tienen director controlador
-- y a todo esto qu�tale directores que tengan escalas en aeropuertos que no
-- sean ESPA�A.

((SELECT NOMBRE
FROM DIRECTOR
WHERE NOMBRE LIKE '%A%'
INTERSECT
SELECT NOMBRE
FROM DIRECTOR
WHERE NOMBRE NOT LIKE '__A%'
    AND NOMBRE NOT LIKE '__E%'
    AND NOMBRE NOT LIKE '__I%'
    AND NOMBRE NOT LIKE '__O%'
    AND NOMBRE NOT LIKE '__U%'
INTERSECT
SELECT NOMBRE
FROM DIRECTOR
WHERE LENGTH(NOMBRE)>4)
INTERSECT
SELECT NOMBRE
FROM DIRECTOR
WHERE DNI_CONTR IS NULL)
MINUS
SELECT DIR.NOMBRE
FROM DIRECTOR DIR, TENER_ESCALA ESC, AEROPUERTOS AER
WHERE DIR.COD_AEROPUERTO=ESC.COD_AEROPUERTO
    AND ESC.COD_AEROPUERTO=AER.CODIGO
    AND AER.PAIS='ESPA�A';

-- EJERCICIO 6

--  Obt�n el nombre, el minuto del gol y el partido (equipo loca, visitante y
-- fecha) de los jugadores de ESPA�A que hayan marcado goles en la primera
-- parte (antes del minuto 45, este incluido).

SELECT JU.NOMBRE, NVL(G.MINUTO,-1) AS MINUTO, G.EQUIPO_L_GOL,
        G.EQUIPO_V_GOL, G.FECHA_GOL
FROM JUGADOR JU,
     JUGAR J,
     GOL G
WHERE   JU.NOMBRE=J.NOMBRE_JUG
    AND J.NOMBRE_JUG=G.JUGADOR_GOL
    AND J.EQUIPO_L_PART=G.EQUIPO_L_GOL
    AND J.EQUIPO_V_PART=G.EQUIPO_V_GOL
    AND J.FECHA_PART=G.FECHA_GOL
    AND JU.EQUIPO_JUGADOR = 'ESPA�A'
    AND G.MINUTO<=45;

SELECT NOMBRE, MIN_GOL, EQUIPO_L_GOL, EQUIPO_V_GOL, FECHA_GOL
FROM GOL G, JUGADOR J
WHERE J.NOMBRE=G.JUGADOR_GOL
   AND EQUIPO_JUGADOR='ESPA�A'
   AND MIN_GOL<=45;
    
-- EJERCICIO 7

-- Obt�n el nombre, el minuto del gol y el partido (equipo locaL, visitante y
-- fecha) de los jugadores de ESPA�A que hayan marcado goles en la primera
-- parte (antes del minuto 45, este incluido), en caso que no hayan marcado
-- tambi�n deben salir apareciendo un -1 en el campo minuto. 

SELECT JU.NOMBRE, NVL(G.MINUTO,-1) AS MINUTO, G.EQUIPO_L_GOL,
        G.EQUIPO_V_GOL, G.FECHA_GOL
FROM JUGADOR JU,
     JUGAR J,
     GOL G
WHERE   JU.NOMBRE=J.NOMBRE_JUG
    AND J.NOMBRE_JUG=G.JUGADOR_GOL(+)
    AND J.EQUIPO_L_PART=G.EQUIPO_L_GOL(+)
    AND J.EQUIPO_V_PART=G.EQUIPO_V_GOL(+)
    AND J.FECHA_PART=G.FECHA_GOL(+)
    AND JU.EQUIPO_JUGADOR = 'ESPA�A'
    AND G.MINUTO(+)<=45;

-- EJERCICIO 8

-- Obt�n el nombre y su pa�s de cada Director junto con el nombre y el pa�s
-- del Director que lo controla. En caso que no tenga tambi�n debe salir.

SELECT DIR.NOMBRE AS DIRECTOR, DIR.PAIS AS PAIS, DIRCONTR.NOMBRE AS CONTROLADOR,
        DIRCONTR.PAIS AS PAIS_CONTROLADOR
FROM DIRECTOR DIR, DIRECTOR DIRCONTR
WHERE DIR.DNI_CONTR=DIRCONTR.DNI(+);
