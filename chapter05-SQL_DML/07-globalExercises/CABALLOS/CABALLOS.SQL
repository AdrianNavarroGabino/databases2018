-- Adrián Navarro Gabino

-- EJERCICIO 1

-- Indica el nombre de los caballos, el nombre de los jinetes y la posición, de
-- aquellos que hayan quedado entre los dos primeros puestos y que sean de
-- nacionalidad Británica ordenados por el nombre del caballo.

SELECT NOMBRE, JOCKEY, POSICIONFINAL
FROM CABALLOS CA, PARTICIPACIONES PA
WHERE CA.CODCABALLO = PA.CODCABALLO
  AND POSICIONFINAL <= 2
  AND UPPER(CA.NACIONALIDAD) = 'BRITÁNICA'
ORDER BY NOMBRE;

-- EJERCICIO 2

-- Nombre de los Caballos de nacionalidad Española que tengan una A en su nombre
-- o Caballos que los clientes que ha apostado por ellos empiecen con consonante,
-- saliendo duplicados, a lo que te de quitándole los Caballos que hayan quedado
-- segundo. Debes usar conjuntos.

((SELECT NOMBRE
FROM CABALLOS
WHERE UPPER(NACIONALIDAD) = 'ESPAÑOLA'
INTERSECT
SELECT NOMBRE
FROM CABALLOS
WHERE UPPER(NOMBRE) LIKE '%A%')
UNION
SELECT NOMBRE
FROM CABALLOS CA, APUESTAS AP
WHERE CA.CODCABALLO = AP.CODCABALLO
  AND AP.DNICLIENTE IN (SELECT DNICLIENTE
                        FROM CLIENTES
                        WHERE UPPER(SUBSTR(NOMBRE,1,1)) NOT IN ('A','E','I','O','U')))
MINUS
SELECT NOMBRE
FROM CABALLOS CA, PARTICIPACIONES PA
WHERE CA.CODCABALLO = PA.CODCABALLO
  AND PA.POSICIONFINAL = 2;
  
-- EJERCICIO 3

--  Nos ordenan eliminar las carreras en las que no hay caballos inscritos.

DELETE CARRERAS
WHERE CODCARRERA NOT IN (SELECT CODCARRERA
                         FROM PARTICIPACIONES);
                         
-- EJERCICIO 4

-- Como podrás comprobar en la Carrera C6 no hay caballos para realizarla.
-- Introduce 4 caballos de lo ya existentes en la carrera C6. Te puedes inventar
-- jockeys y dorsales.

INSERT INTO PARTICIPACIONES
(CODCABALLO, CODCARRERA, DORSAL, JOCKEY)
VALUES
('1', 'C6', 1, 'ALFREDO ESTRUCH');

INSERT INTO PARTICIPACIONES
(CODCABALLO, CODCARRERA, DORSAL, JOCKEY)
VALUES
('2', 'C6', 4, 'MAX POWERS');

INSERT INTO PARTICIPACIONES
(CODCABALLO, CODCARRERA, DORSAL, JOCKEY)
VALUES
('3', 'C6', 7, 'JACK DANIEL');

INSERT INTO PARTICIPACIONES
(CODCABALLO, CODCARRERA, DORSAL, JOCKEY)
VALUES
('9', 'C6', 2, 'MARTA VIDAL');

-- EJERCICIO 5

-- Ya se ha celebrado la carrera C6 y los caballos llegan por orden de edad del
-- más joven al más adulto.
-- Actualiza la tabla Participaciones con los resultados de la carrera.

CREATE SEQUENCE POSICIONESFINALES;

UPDATE PARTICIPACIONES
    SET POSICIONFINAL = POSICIONESFINALES.NEXTVAL
    WHERE POSICIONFINAL IS NULL
      AND CODCABALLO IN (SELECT CODCABALLO
                         FROM CABALLOS
                         WHERE POSICIONFINAL IS NULL
                           AND FECHANACIMIENTO IN (SELECT MAX(FECHANACIMIENTO)
                                                  FROM CABALLOS CA, PARTICIPACIONES PA
                                                  WHERE CA.CODCABALLO = PA.CODCABALLO
                                                    AND PA.CODCARRERA = 'C6'
                                                    AND PA.POSICIONFINAL IS NULL));
                                                    
UPDATE PARTICIPACIONES
    SET POSICIONFINAL = POSICIONESFINALES.NEXTVAL
    WHERE POSICIONFINAL IS NULL
      AND CODCABALLO IN (SELECT CODCABALLO
                         FROM CABALLOS
                         WHERE POSICIONFINAL IS NULL
                           AND FECHANACIMIENTO IN (SELECT MAX(FECHANACIMIENTO)
                                                  FROM CABALLOS CA, PARTICIPACIONES PA
                                                  WHERE CA.CODCABALLO = PA.CODCABALLO
                                                    AND PA.CODCARRERA = 'C6'
                                                    AND PA.POSICIONFINAL IS NULL));
                                                    
UPDATE PARTICIPACIONES
    SET POSICIONFINAL = POSICIONESFINALES.NEXTVAL
    WHERE POSICIONFINAL IS NULL
      AND CODCABALLO IN (SELECT CODCABALLO
                         FROM CABALLOS
                         WHERE POSICIONFINAL IS NULL
                           AND FECHANACIMIENTO IN (SELECT MAX(FECHANACIMIENTO)
                                                  FROM CABALLOS CA, PARTICIPACIONES PA
                                                  WHERE CA.CODCABALLO = PA.CODCABALLO
                                                    AND PA.CODCARRERA = 'C6'
                                                    AND PA.POSICIONFINAL IS NULL));
                                                    
UPDATE PARTICIPACIONES
    SET POSICIONFINAL = POSICIONESFINALES.NEXTVAL
    WHERE POSICIONFINAL IS NULL
      AND CODCABALLO IN (SELECT CODCABALLO
                         FROM CABALLOS
                         WHERE POSICIONFINAL IS NULL
                           AND FECHANACIMIENTO IN (SELECT MAX(FECHANACIMIENTO)
                                                  FROM CABALLOS CA, PARTICIPACIONES PA
                                                  WHERE CA.CODCABALLO = PA.CODCABALLO
                                                    AND PA.CODCARRERA = 'C6'
                                                    AND PA.POSICIONFINAL IS NULL));

-- EJERCICIO 6

--  Añade los siguientes CHECKS a las tablas del modelo:
-- a) En las Participaciones los nombres de los jockeys tienen siempre las
-- iniciales en mayúsculas.

UPDATE PARTICIPACIONES
    SET JOCKEY = INITCAP(JOCKEY);

ALTER TABLE PARTICIPACIONES ADD (
    CONSTRAINT CHECK_JOCKEY CHECK (JOCKEY = INITCAP(JOCKEY))
);

-- b) La nacionalidad de los caballos solo puede ser Británica, Española,
-- Macedonia  o Árabe.

ALTER TABLE CABALLOS ADD (
    CONSTRAINT CHECK_NACIONALIDAD
    CHECK (NACIONALIDAD IN ('Británica','Española','Macedonia','Árabe'))
);

-- c) La temporada de carreras solo puede transcurrir del 10 de Marzo al 10 de
-- Noviembre.

ALTER TABLE CARRERAS ADD (
    CONSTRAINT CHECK_FECHA CHECK (TO_CHAR(FECHAHORA, 'MMDD') BETWEEN 0310 AND 1110)
);

-- EJERCICIO 7

-- Saca de cada una de las carreras el número total de participantes, debes
-- incluir aquellas en las que no hay caballos inscritos.

SELECT CA.CODCARRERA, COUNT(CODCABALLO)
FROM CARRERAS CA, PARTICIPACIONES PA
WHERE CA.CODCARRERA = PA.CODCARRERA(+)
GROUP BY CA.CODCARRERA;

-- EJERCICIO 8

-- Te piden que introduzcas la siguiente apuesta, un cliente con nacionalidad
-- Escocesa ha apostado por el caballo más pesado de la primera carrera que se
-- corra duante el verano del 2009 con un importe de 2000, y sabemos que en ese
-- momento para esa carrera a ese caballo se paga 30 a 1.

INSERT INTO APUESTAS
(DNICLIENTE, CODCABALLO, CODCARRERA, IMPORTE, TANTOPORUNO)
(SELECT DNICLIENTE, CODCABALLO, CODCARRERA, 2000, 30
FROM CLIENTES CLI, CABALLOS CAB, CARRERAS CAR
WHERE CLI.NACIONALIDAD = 'Escocesa'
  AND CAB.PESO = (SELECT MAX(CAB.PESO)
                  FROM CABALLOS CAB)
  AND TO_CHAR(CAR.FECHAHORA, 'YYYYMMDDHHMM') = (SELECT MIN(TO_CHAR(CAR.FECHAHORA, 'YYYYMMDDHHMM'))
                                          FROM CARRERAS CAR
                                          WHERE TO_CHAR(CAR.FECHAHORA, 'YYYYMMDDHHMM') BETWEEN 200906210000 AND 200909232359));

-- EJERCICIO 9

-- Obtén el nombre del caballo y la carrera con más peso en cada carrera.
SELECT CAR.CODCARRERA, CAB.NOMBRE
FROM CABALLOS CAB, CARRERAS CAR
WHERE (CAB.PESO, CAR.CODCARRERA) IN (SELECT MAX(PESO), PAR.CODCARRERA
                                     FROM CABALLOS CAB, PARTICIPACIONES PAR
                                     WHERE CAB.CODCABALLO = PAR.CODCABALLO
                                       AND PAR.CODCARRERA = CAR.CODCARRERA
                                     GROUP BY PAR.CODCARRERA);

-- EJERCICIO 10

-- Teniendo en cuenta estas dos premisas:

-- 1) Un cliente gana una apuesta si el caballo por el que apuesta gana la carrera.
-- 2) El importe de su premio es el importe apostado multiplicado por el tanto
-- por uno de la apuesta correspondiente. 
 
-- Muestra los nombres de todos los clientes que con sus apuestas hayan  ganado
-- más de 8000 euros.

SELECT CLI.NOMBRE
FROM CLIENTES CLI
WHERE CLI.DNICLIENTE IN (SELECT AP.DNICLIENTE
                         FROM APUESTAS AP
                         WHERE (AP.CODCABALLO, AP.CODCARRERA) IN (SELECT PAR.CODCABALLO, PAR.CODCARRERA
                                                                  FROM PARTICIPACIONES PAR
                                                                  WHERE PAR.POSICIONFINAL = 1)
                         GROUP BY AP.DNICLIENTE
                         HAVING SUM(AP.IMPORTE * AP.TANTOPORUNO) > 8000);

-- EJERCICIO 11

-- Dime jockey que más carreras ha ganado.

SELECT JOCKEY
FROM PARTICIPACIONES
WHERE POSICIONFINAL = 1
GROUP BY JOCKEY
HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                   FROM PARTICIPACIONES
                   WHERE POSICIONFINAL = 1
                   GROUP BY JOCKEY);

-- EJERCICIO 12

-- Sabiendo que el premio de una carrera se lo lleva el vencedor de la misma,
-- dime el propietario que más dinero ha ganado en premios con sus caballos.

SELECT PROPIETARIO
FROM CABALLOS CAB
WHERE CAB.CODCABALLO = 
(SELECT PAR.CODCABALLO
FROM PARTICIPACIONES PAR, CARRERAS CAR
WHERE POSICIONFINAL = 1
  AND PAR.CODCARRERA = CAR.CODCARRERA
GROUP BY PAR.CODCABALLO
HAVING SUM(IMPORTEPREMIO) = (SELECT MAX(SUM(IMPORTEPREMIO))
                             FROM PARTICIPACIONES PAR, CARRERAS CAR
                             WHERE POSICIONFINAL = 1
                             AND PAR.CODCARRERA = CAR.CODCARRERA
                             GROUP BY PAR.CODCABALLO));

-- EJERCICIO 13

-- Saca los caballos (sus nombres) que más veces han quedado entre los tres
-- primeros puestos.

SELECT CAB.NOMBRE
FROM CABALLOS CAB
WHERE CAB.CODCABALLO IN (SELECT PAR.CODCABALLO
                        FROM PARTICIPACIONES PAR
                        WHERE POSICIONFINAL BETWEEN 1 AND 3
                        GROUP BY PAR.CODCABALLO
                        HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                                           FROM PARTICIPACIONES PAR
                                           WHERE POSICIONFINAL BETWEEN 1 AND 3
                                           GROUP BY PAR.CODCABALLO));
                                          
-- EJERCICIO 14

-- Obtén los clientes y la cantidad de caballos sobre los que han apostado,
-- teniendo que haber apostado a más de 1 caballo y con una suma de todas sus
-- apuestas de más de 3.000 euros.

SELECT CLI.NOMBRE, COUNT(DISTINCT CODCABALLO) APUESTAS, SUM(IMPORTE) IMPORTE_TOTAL
FROM CLIENTES CLI, APUESTAS AP
WHERE CLI.DNICLIENTE = AP.DNICLIENTE
GROUP BY CLI.NOMBRE
HAVING COUNT(DISTINCT CODCABALLO) > 1
   AND SUM(IMPORTE) > 3000;