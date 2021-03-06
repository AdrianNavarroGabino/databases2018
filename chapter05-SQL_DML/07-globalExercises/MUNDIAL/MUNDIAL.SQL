-- Adri�n Navarro Gabino

-- EJERCICIO 1

-- Jugadores�que�hayan�jugado�partidos�y�si�no�lo�han�hecho�que�salgan�tambi�n,
--�debe�salir�nombre,�los� equipos�que�se�enfrentaron�y�el�resultado.
--�(Ordenado�descendentemente�por�equipo�local)

SELECT J.NOMBRE, PA.EQUIPO_L, PA.EQUIPO_V, PA.RESULTADO_L, PA.RESULTADO_V
FROM JUGADOR J, JUGAR JU, PARTIDO PA
WHERE J.NOMBRE = JU.NOMBRE_JUG(+)
  AND JU.EQUIPO_L_PART=PA.EQUIPO_L(+)
  AND JU.EQUIPO_V_PART=PA.EQUIPO_V(+)
  AND JU.FECHA_PART=PA.FECHA(+)
ORDER BY PA.EQUIPO_L DESC;

-- EJERCICIO 2

-- El�gol�m�s�tempranero�en�cualquier�MUNDIAL,�saca�el�minuto,�el�jugador�y�el
--�partido�donde�se� produjo.

SELECT *
FROM GOL
WHERE MINUTO = (SELECT MIN(MINUTO) FROM GOL);

-- EJERCICIO 3

-- Saca�los�delanteros�de�los�equipos�que�hagan�de�local�que�hayan�empatado
--�partidos,�quitando� duplicados.

SELECT DISTINCT J.NOMBRE, J.EQUIPO_JUGADOR
FROM JUGAR JU, JUGADOR J, PARTIDO PA
WHERE JU.PUESTO_JUGAR = 'DL'
  AND PA.RESULTADO_L = PA.RESULTADO_V
  AND JU.EQUIPO_L_PART = PA.EQUIPO_L
  AND JU.EQUIPO_V_PART = PA.EQUIPO_V
  AND JU.NOMBRE_JUG = J.NOMBRE
  AND JU.EQUIPO_L_PART = J.EQUIPO_JUGADOR
ORDER BY J.NOMBRE;

-- EJERCICIO 4

-- Saca�todos�los�jugadores�que�han�jugado�en�un�puesto�no�habitual�al�suyo.�

SELECT J.*
FROM JUGADOR J, JUGAR JU
WHERE J.PUESTO_HAB != JU.PUESTO_JUGAR
  AND JU.NOMBRE_JUG = J.NOMBRE;
                          
-- EJERCICIO 5

-- Saca�el�nombre�del�jugador�que�haya�marcado�el�gol�m�s�tempranero�y�el
--��rbitro�mayor�alfab�ticamente.

SELECT JUGADOR_GOL JUGADOR_Y_ARBITRO
FROM GOL
WHERE MINUTO = (SELECT MIN(MINUTO) FROM GOL)
UNION
SELECT NOMBRE JUGADOR_Y_ARBITRO
FROM ARBITRO
WHERE NOMBRE = (SELECT MAX(NOMBRE)
                       FROM ARBITRO);

-- EJERCICIO 6

-- Muestra�la�cantidad�de�goles,�la�selecci�n�a�la�que�pertenece�y�el�m�ximo
--�goleador�de�todas�las� primeras�partes�de�los�partidos�(La�primera�parte
--�dura�45�minutos)
                  
SELECT COUNT(*), EQUIPO_JUGADOR, GOL.JUGADOR_GOL
FROM GOL, JUGADOR
WHERE MINUTO <= 45
  AND GOL.JUGADOR_GOL = JUGADOR.NOMBRE
GROUP BY GOL.JUGADOR_GOL, EQUIPO_JUGADOR
HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                   FROM GOL
                   WHERE MINUTO <= 45
                   GROUP BY JUGADOR_GOL);

-- EJERCICIO 7

-- Muestra�los�equipos�que�hayan�ganado�partidos,�sacando�duplicados.

SELECT EQUIPO_L EQUIPO_GANADOR
FROM PARTIDO
WHERE RESULTADO_L > RESULTADO_V
UNION ALL
SELECT EQUIPO_V EQUIPO_GANADOR
FROM PARTIDO
WHERE RESULTADO_L < RESULTADO_V;

-- EJERCICIO 8

-- Jugadores�que�hayan�metido�alg�n�gol�y�hayan�jugado�menos�de�3�partidos�o
--�que�no�hayan�marcado�ning�n�gol�pero�hayan�jugado�m�s�de�5�partidos.

SELECT NOMBRE
FROM JUGADOR
WHERE (NOMBRE IN (SELECT NOMBRE_JUG
                 FROM JUGAR
                 GROUP BY NOMBRE_JUG
                 HAVING COUNT(*) < 3)
  AND NOMBRE IN (SELECT JUGADOR_GOL
                 FROM GOL))
   OR (NOMBRE IN (SELECT NOMBRE_JUG
                 FROM JUGAR
                 GROUP BY NOMBRE_JUG
                 HAVING COUNT(*) > 5)
   AND NOMBRE NOT IN (SELECT JUGADOR_GOL
                      FROM GOL));

-- OPCI�N M�S R�PIDA:

(SELECT DISTINCT JUGADOR_GOL NOMBRE
FROM GOL
INTERSECT
SELECT NOMBRE_JUG NOMBRE
FROM JUGAR
GROUP BY NOMBRE_JUG
HAVING COUNT(*) < 3)
UNION
(SELECT NOMBRE_JUG NOMBRE
FROM JUGAR
GROUP BY NOMBRE_JUG
HAVING COUNT(*) > 5
MINUS
SELECT DISTINCT JUGADOR_GOL NOMBRE
FROM GOL);

-- EJERCICIO 9

-- Una�vista�con�el�resultado�que�menos�se�haya�dado.�

SELECT PA.RESULTADO_L||'-'||PA.RESULTADO_V AS RESULTADO, COUNT(*) CONTADOR
FROM PARTIDO PA
GROUP BY PA.RESULTADO_L, PA.RESULTADO_V
HAVING COUNT(*) = (SELECT MIN(COUNT(*))
                   FROM PARTIDO PA
                   GROUP BY PA.RESULTADO_L, PA.RESULTADO_V);

-- EJERCICIO 10

-- Cu�l�es�el�resultado�que�m�s�veces�se�ha�dado�en�los�Mundiales�siempre�que
--�haya�habido�m�s�de�3� goles

SELECT PA.RESULTADO_L||'-'||PA.RESULTADO_V AS RESULTADO, COUNT(*) CONTADOR
FROM PARTIDO PA
WHERE PA.RESULTADO_L + PA.RESULTADO_V > 3
GROUP BY PA.RESULTADO_L, PA.RESULTADO_V
HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                   FROM PARTIDO PA
                   WHERE PA.RESULTADO_L + PA.RESULTADO_V > 3
                   GROUP BY PA.RESULTADO_L, PA.RESULTADO_V);