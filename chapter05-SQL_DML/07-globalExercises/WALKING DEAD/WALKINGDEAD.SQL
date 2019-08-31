-- Adrián Navarro Gabino

-- EJERCICIO 1

-- Actores que tengan todas las vocales en su nombre.

SELECT *
FROM ACTORES
WHERE NOMBRE LIKE '%A%'
  AND NOMBRE LIKE '%E%'
  AND NOMBRE LIKE '%I%'
  AND NOMBRE LIKE '%O%'
  AND NOMBRE LIKE '%U%';

-- EJERCICIO 2

-- Actores nacidos antes de 1960 y que tengan menos de 4 letras en su
-- nacionalidad.

SELECT *
FROM ACTORES
WHERE TO_CHAR(FECHA_NAC, 'YYYY') < 1960 AND LENGTH(NACIONALIDAD) < 4;

-- EJERCICIO 3

-- Actores donde la edad no concuerda con la fecha de nacimiento. Después
-- elimina la columna edad y obtén los actores con menos de 30 años
-- (debe salir nombre del actor y su edad actual, que aparezca EDAD_ACTUAL).

SELECT *
FROM ACTORES
WHERE TO_CHAR(SYSDATE, 'YYYY') - TO_CHAR(FECHA_NAC, 'YYYY') != EDAD;

SELECT NOMBRE, TO_CHAR(SYSDATE, 'YYYY') - TO_CHAR(FECHA_NAC, 'YYYY') EDAD_ACTUAL
FROM ACTORES
WHERE TO_CHAR(SYSDATE, 'YYYY') - TO_CHAR(FECHA_NAC, 'YYYY') < 30;

-- EJERCICIO 4

-- Cantidad de actores que han sido protagonistas (Campo a 'S') y suma de sus
-- edades.

SELECT COUNT(HC.PROTA) CANTIDAD,
SUM(TO_CHAR(SYSDATE, 'YYYY')) - SUM(TO_CHAR(FECHA_NAC, 'YYYY')) SUMA_EDADES_ACTUALES
FROM HACER_CASTING HC, ACTORES AC
WHERE HC.NSS = AC.NSS
  AND HC.PROTA = 'S';

-- EJERCICIO 5

-- Añade un campo a personaje que tenga un carácter alfanumérico, y actualiza
-- este campo a S si el personaje si es hombre, y N si no es así.

ALTER TABLE PERSONAJES ADD HOMBRE VARCHAR2(1);

UPDATE PERSONAJES
SET HOMBRE = DECODE(SEXO, 'HOMBRE', 'S', 'MASCULINO', 'S', 'M', 'S', 'N');

-- EJERCICIO 6

-- Elimina el campo anterior de la tabla.

ALTER TABLE PERSONAJES DROP COLUMN HOMBRE;

-- EJERCICIO 7

-- Localizaciones visitadas en la 2 temporada ordenadas por coste.

SELECT NOMBRE_LOC
FROM LOCALIZACIONES
WHERE COD_LOC IN (SELECT COD_LOC
                  FROM ACTUAR
                  WHERE TEMPORADA = 2)
ORDER BY COSTE_LOC;

-- EJERCICIO 8

-- Nombre de los actores que hayan participado en alguna película que tenga un
-- número en su título. También deben salir las posiciones del 5 al 10 de ese
-- título y en minúsculas. Ordenador por nombre.

SELECT AC.NOMBRE, PE.TITULO, LOWER(SUBSTR(PE.TITULO,5,6)) TROZO_TITULO
FROM ACTORES AC, PELICULAS PE
WHERE PE.COD_PELI IN (SELECT HACER_CASTING.CODIGO_PELICULA
                      FROM HACER_CASTING
                      WHERE HACER_CASTING.NSS = AC.NSS)
  AND (PE.TITULO LIKE '%0%'
    OR PE.TITULO LIKE '%1%'
    OR PE.TITULO LIKE '%2%'
    OR PE.TITULO LIKE '%3%'
    OR PE.TITULO LIKE '%4%'
    OR PE.TITULO LIKE '%5%'
    OR PE.TITULO LIKE '%6%'
    OR PE.TITULO LIKE '%7%'
    OR PE.TITULO LIKE '%8%'
    OR PE.TITULO LIKE '%9%')
ORDER BY AC.NOMBRE;
    
-- EJERCICIO 9

-- Personajes que tengan nombre de más de 1 palabra (no se puede usar like).

SELECT NOMBRE
FROM PERSONAJES
WHERE INSTR(LTRIM(RTRIM(NOMBRE)), ' ') > 0;

-- EJERCICIO 10

-- Obtén cada personaje Principal y a la derecha que aparezca la palabra
-- CONVERTIDO o NO CONVERTIDO, si lo ha sido o no. Ordena por nombre.

SELECT NOMBRE,
    DECODE(PR.NOMBRE, CO.PRINCIPAL, 'CONVERTIDO', 'NO CONVERTIDO') RESULTADO
FROM PRINCIPAL PR, CONVERTIR CO
WHERE PR.NOMBRE = CO.PRINCIPAL(+)
ORDER BY NOMBRE;

-- EJERCICIO 11

-- Saca cuantos diferentes niveles de descomposición de Zombies tenemos en la
-- base de datos (nivel y cantidad).

SELECT DETERIORO, COUNT(*) CANTIDAD
FROM ZOMBIE
GROUP BY DETERIORO;

-- EJERCICIO 12

-- Saca cada personaje cuantos zombies ha matado y si no ha matado a ninguno
-- debe salir 0 ordena por orden de cantidad de matados.

SELECT PE.NOMBRE, COUNT(ZO.NOMBRE) CANTIDAD
FROM PERSONAJES PE, ZOMBIE ZO
WHERE PE.NOMBRE = ZO.NOMBRE_PJ_KILL(+)
GROUP BY PE.NOMBRE
ORDER BY 2 DESC;

-- EJERCICIO 12B

-- Ahora haz una select que te saque el que más zombies haya matado.

SELECT NOMBRE_PJ_KILL, COUNT(*) CANTIDAD
FROM ZOMBIE
GROUP BY NOMBRE_PJ_KILL
HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM ZOMBIE GROUP BY NOMBRE_PJ_KILL);

-- EJERCICIO 13

-- Saca cada personaje que salga en más de 1 grupo.

SELECT PERSONAJE, COUNT(*) GRUPOS_A_LOS_QUE_PERTENECE
FROM PERTENECER_GRUPO
GROUP BY PERSONAJE
HAVING COUNT(*) > 1;

-- EJERCICIO 14

-- El personaje que más actúe en la serie.

SELECT PERSONAJE, COUNT(*) VECES_QUE_SALE
FROM PERTENECER_GRUPO, ACTUAR
WHERE PERTENECER_GRUPO.CODIGO_GRUPO = ACTUAR.COD_GRUPO
GROUP BY PERSONAJE, COD_GRUPO
HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                   FROM ACTUAR
                   GROUP BY PERSONAJE, COD_GRUPO);

-- EJERCICIO 15

--  El usuario con menos comentarios.

SELECT USUARIO, COUNT(*)
FROM COMENTAR
GROUP BY USUARIO
HAVING COUNT(*) = (SELECT MIN(COUNT(*))
                   FROM COMENTAR
                   GROUP BY USUARIO);

-- EJERCICIO 16

-- Obtén algún capítulo de la saga que no haya tenido comentario alguno o la
-- que menos actores haya utilizado y quítale los capítulos con menos duración.

(SELECT NUM_CAP CAPITULO, NUM_TEMPO TEMPORADA
FROM CAPITULOS
WHERE (NUM_CAP, NUM_TEMPO) NOT IN (SELECT NUM_CAP, NUM_TEMPO
                                   FROM COMENTAR)
UNION
SELECT CAPITULO, TEMPORADA
FROM ACTUAR
GROUP BY CAPITULO, TEMPORADA, COD_LOC
HAVING COUNT(*) = (SELECT MIN(COUNT(*))
                   FROM ACTUAR
                   GROUP BY CAPITULO, TEMPORADA, COD_LOC))
MINUS
SELECT NUM_CAP CAPITULO, NUM_TEMPO TEMPORADA
FROM CAPITULOS
WHERE DURACION_CAP = (SELECT MIN(DURACION_CAP)
                      FROM CAPITULOS);

-- EJERCICIO 17

-- Obtén los personajes que hayan realizado alguna actuación y si no lo han
-- hecho también deben salir. Indica la cantidad de actuaciones realizadas.
-- Ordénalo por el número de actuaciones de mayor a menor.

SELECT NOMBRE, COUNT(COD_GRUPO) NUMERO_ACTUACIONES
FROM PERSONAJES PE, ACTUAR AC, PERTENECER_GRUPO PG
WHERE PG.CODIGO_GRUPO = AC.COD_GRUPO(+)
  AND PG.PERSONAJE = PE.NOMBRE(+)
GROUP BY NOMBRE
ORDER BY COUNT(*);

-- EJERCICIO 18

-- Saca los nombres de los grupos que hayan hecho más de 1 actuación y si hay
-- más de uno obtén el de código de grupo más pequeño alfabéticamente.

SELECT NOMBRE_GRUPO
FROM GRUPO
WHERE GRUPO.COD_GRUPO IN (SELECT ACTUAR.COD_GRUPO
                          FROM ACTUAR
                          WHERE ACTUAR.COD_GRUPO = GRUPO.COD_GRUPO
                          GROUP BY ACTUAR.COD_GRUPO
                          HAVING COUNT(*) > 1)
  AND NOMBRE_GRUPO = (SELECT MIN(NOMBRE_GRUPO)
                             FROM GRUPO
                             WHERE GRUPO.COD_GRUPO IN (SELECT ACTUAR.COD_GRUPO
                                                       FROM ACTUAR
                                                       WHERE ACTUAR.COD_GRUPO = GRUPO.COD_GRUPO
                                                       GROUP BY ACTUAR.COD_GRUPO
                                                       HAVING COUNT(*) > 1));

-- EJERCICIO 19

-- Obtén todo los personajes que sean principal y zombie a la vez.

SELECT *
FROM PERSONAJES PE
WHERE PE.NOMBRE IN (SELECT PR.NOMBRE
                    FROM PRINCIPAL PR)
  AND PE.NOMBRE IN (SELECT ZO.NOMBRE
                    FROM ZOMBIE ZO);
                    
-- EJERCICIO 20

-- Crea una Vista que te saque todos las capítulos que tengan más comentarios.

SELECT *
FROM CAPITULOS
WHERE (NUM_CAP, NUM_TEMPO) IN (SELECT NUM_CAP, NUM_TEMPO
                                FROM COMENTAR
                                GROUP BY NUM_CAP, NUM_TEMPO
                                HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                                                   FROM COMENTAR
                                                   GROUP BY NUM_CAP, NUM_TEMPO));
                                                   
-- EJERCICIO 21

-- Crea una Vista que te saque todos los datos de las últimas película
-- estrenadas, en caso que ese año se haya estrenado más de una, las que su
-- longitud del título se más grande. En la vista cámbiale el nombre a todos
-- los campos.

SELECT *
FROM PELICULAS
WHERE LENGTH(TITULO) = (SELECT MAX(LENGTH(TITULO))
                        FROM PELICULAS
                        WHERE ANYO = (SELECT MAX(ANYO)
                                      FROM PELICULAS));
