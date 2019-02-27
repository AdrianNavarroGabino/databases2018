-- Adrián Navarro Gabino

-- EJERCICIO 1

-- Obtén los aeropuertos que tengan la misma longitud de cadena que cualquier
-- nombre de director que comience o termine por VOCAL.

SELECT *
FROM AEROPUERTOS AER
WHERE EXISTS (SELECT 1
            FROM DIRECTOR DIR
            WHERE LENGTH(DIR.NOMBRE)=LENGTH(AER.NOMBRE)
             AND (UPPER(DIR.NOMBRE) LIKE 'A%'
               OR UPPER(DIR.NOMBRE) LIKE '%A'
               OR UPPER(DIR.NOMBRE) LIKE 'E%'
               OR UPPER(DIR.NOMBRE) LIKE '%E'
               OR UPPER(DIR.NOMBRE) LIKE 'I%'
               OR UPPER(DIR.NOMBRE) LIKE '%I'
               OR UPPER(DIR.NOMBRE) LIKE 'O%'
               OR UPPER(DIR.NOMBRE) LIKE '%O'
               OR UPPER(DIR.NOMBRE) LIKE 'U%'
               OR UPPER(DIR.NOMBRE) LIKE '%U'));

SELECT *
FROM AEROPUERTOS
WHERE LENGTH(NOMBRE) IN (SELECT LENGTH(NOMBRE)
			FROM DIRECTOR
			WHERE SUBSTR(UPPER(NOMBRE),1,1) IN ('A','E','I','O','U')
  			   OR SUBSTR(UPPER(NOMBRE),-1) IN ('A','E','I','O','U'));
              
-- EJERCICIO 2

-- Dime todos los datos de las escalas que con los que ha subido y bajado han
-- cubierto la capacidad del vuelo.

SELECT NUM_VUELO, COD_AVION, FECHA_VUELO
FROM TENER_ESCALA TE
GROUP BY TE.COD_AVION, TE.FECHA_VUELO, TE.NUM_VUELO
HAVING SUM(TE.PASAJEROS_SUBEN) - SUM(TE.PASAJEROS_BAJAN) +
(
    SELECT VO.PLAZAS_OCUPADAS
    FROM VOLAR VO
    WHERE VO.COD_AVION = TE.COD_AVION
      AND VO.FECHA_VUELO = TE.FECHA_VUELO
      AND VO.NUM_VUELO = TE.NUM_VUELO
)
    >= (
        SELECT AV.CAPACIDAD
        FROM AVIONES AV, VOLAR VO
        WHERE VO.COD_AVION = TE.COD_AVION
        AND VO.FECHA_VUELO = TE.FECHA_VUELO
        AND VO.NUM_VUELO = TE.NUM_VUELO
        AND AV.CODIGO = VO.COD_AVION
    );

-- CLASE

SELECT *
FROM TENER_ESCALA
WHERE (NUM_VUELO, FECHA_VUELO, COD_AVION) IN
	(SELECT NUM_VUELO, FECHA_VUELO, COD_AVION
	FROM TENER_ESCALA T
	GROUP BY NUM_VUELO, FECHA_VUELO, COD_AVION
	HAVING SUM(PASAJEROS_SUBEN) - SUM(PASAJEROS_BAJAN) =
		(SELECT CAPACIDAD - PLAZAS_OCUPADAS
		FROM VOLAR V, AVIONES A
		WHERE V.COD_AVION=A.CODIGO
		  AND T.COD_AVION=V.COD_AVION
		  AND T.FECHA=V.FECHA_VUELO
		  AND T.NUM_VUELO=V.NUM_VUELO));

-- EJERCICIO 3

-- Nombre de los aeropuertos de los que no ha despegado ningún avión.

SELECT AER.NOMBRE
FROM AEROPUERTOS AER
WHERE NOT EXISTS (SELECT 1
                FROM PROGRAMA_VUELO PROG
                WHERE PROG.COD_AERO_DESPEGAR=AER.CODIGO);

SELECT * FROM AEROPUERTOS
WHERE CODIGO NOT IN (SELECT COD_AERO_DESPEGAR FROM PROGRAMA_VUELO);
               
-- EJERCICIO 4

-- Aviones que tiene al menos 2 vuelos realizados.

SELECT *
FROM AVIONES
WHERE CODIGO IN (SELECT COD_AVION
                 FROM VOLAR
                 GROUP BY COD_AVION
                 HAVING COUNT(*) > 1);
     
-- EJERCICIO 5

-- Avión con más vuelos realizados.

SELECT *
FROM AVIONES
WHERE CODIGO IN
(
    SELECT COD_AVION
    FROM VOLAR
    GROUP BY COD_AVION
    HAVING COUNT(*) =
    (
        SELECT MAX(COUNT(*))
        FROM VOLAR
        GROUP BY COD_AVION
    )
);

-- EJERCICIO 6

-- Elimina los aviones que no tengan ningún vuelo realizado.

DELETE FROM AVIONES AV
WHERE CODIGO NOT IN (SELECT COD_AVION FROM VOLAR V);

-- EJERCICIO 7

-- Inserta un avión y asígnale el número de vuelo o vuelos que menos
-- vuelos tenga.

INSERT INTO AVIONES
(CODIGO)
VALUES
('12321');

INSERT INTO VOLAR
(COD_AVION, FECHA_VUELO, NUM_VUELO)
(
    SELECT '12321', TRUNC(SYSDATE), NUM_VUELO
    FROM VOLAR
    WHERE COD_AVION IN
    (
        SELECT COD_AVION
        FROM VOLAR 
        GROUP BY COD_AVION
        HAVING COUNT(*) =
        (
            SELECT MIN(COUNT(*))
            FROM VOLAR
            GROUP BY COD_AVION
        )
    )
);

-- EJERCICIO 8

-- Dime el vuelo que más escalas tenga.

SELECT *
FROM VOLAR
WHERE (NUM_VUELO, COD_AVION) IN
(
    SELECT NUM_VUELO, COD_AVION
    FROM TENER_ESCALA
    GROUP BY NUM_VUELO, COD_AVION, FECHA_VUELO
    HAVING COUNT(*) =
    (
        SELECT MAX(COUNT(*))
        FROM TENER_ESCALA
        GROUP BY NUM_VUELO, COD_AVION, FECHA_VUELO
    )
);

-- EJERCICIO 9

-- Crea un campo edad en ACTORES y actualiza ese campo edad de cada actor
-- con las edad que ya tenga más la suma de las películas que haya hecho
-- algún casting.

ALTER TABLE ACTORES ADD
(
    EDAD2 VARCHAR2(3)
);
   
UPDATE ACTORES AC
    SET EDAD2=(SELECT AC.EDAD + NVL(COUNT(HC.CODIGO_PELICULA),0)
                FROM HACER_CASTING HC
                WHERE HC.NSS = AC.NSS);
               
-- EJERCICIO 10

-- Dime la actuación (PK de ACTUAR) que mayor número de zombies ha tenido
-- sumando los de todas sus localizaciones.
      
SELECT AC.TEMPORADA, AC.CAPITULO
FROM ACTUAR AC
WHERE AC.COD_LOC =
(
    SELECT LO.COD_LOC
    FROM LOCALIZACIONES LO
    WHERE LO.COD_LOC = AC.COD_LOC
    GROUP BY LO.COD_LOC
    HAVING SUM(LO.NUM_ZOMBIES) =
    (
        SELECT MAX(SUM(LO2.NUM_ZOMBIES))
        FROM LOCALIZACIONES LO2
        GROUP BY LO2.COD_LOC
    )
);

-- CLASE

SELECT *
FROM ACTUAR
WHERE (CAPITULO, TEMPORADA, COD_GRUPO) IN
	(SELECT CAPITULO, TEMPORADA, COD_GRUPO
	FROM ACTUAR ACT, LOCALIZACIONES LOC
	WHERE ACT.COD_LOC = LOC.COD_LOC
	GROUP BY CAPITULO, TEMPORADA, COD_GRUPO
	HAVING SUM(NUM_ZOMBIES) = (SELECT MAX(SUM(NUM_ZOMBIES))
				  FROM ACTUAR ACT, LOCALIZACIONES LOC
				  WHERE ACT.COD_LOC=LOC.COD_LOC
				  GROUP BY CAPITULO, TEMPORADA, COD_GRUPO));