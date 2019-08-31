-- Adrián Navarro Gabino


-- EJERCICIO 1

-- Haz una vista sobre la tabla DIRECTOR del modelo AEROPUERTO, sobre todos los
-- campos menos el codigo del controlador. Utiliza alias para que los campos
-- no se llamen igual.

CREATE OR REPLACE VIEW DIRECTORES
(DNI_DIR, COD_AER, NOMBRE_DIR, DIRECCION_DIR, TELEFONO_DIR, PAIS_DIR)
AS
SELECT DNI, COD_AEROPUERTO, NOMBRE, DIRECCION, TELEFONO, PAIS
FROM DIRECTOR;

-- EJERCICIO 2

-- Realiza insert, updates y deletes sobre la vista y comprueba que los cambios
-- y los errores se produce igual que si los hicieras sobre la tabla original.

INSERT INTO DIRECTORES
(DNI_DIR, COD_AER, NOMBRE_DIR)
VALUES
('AXSAD1', 'ABD', 'ANTONIO');

UPDATE DIRECTORES
    SET NOMBRE_DIR = 'JORGE PEREZ'
    WHERE COD_AER = 'ABD';

DELETE FROM DIRECTORES
WHERE COD_AER = 'ABD';

-- EJERCICIO 3

-- Elimina la vista y vuélvela a crear pero como de solo lectura y comprueba
-- que no puedes hacer cambios. Créala también cruzando con AEROPUERTOS y
-- comprueba que no es actualizable al ser de dos tablas la vista.

DROP VIEW DIRECTORES;

CREATE OR REPLACE VIEW DIRECTORES
(DNI_DIR, COD_AER, NOMBRE_DIR, DIRECCION_DIR, TELEFONO_DIR, PAIS_DIR)
AS
SELECT DNI, COD_AEROPUERTO, NOMBRE, DIRECCION, TELEFONO, PAIS
FROM DIRECTOR
WITH READ ONLY;

INSERT INTO DIRECTORES
(DNI_DIR, COD_AER, NOMBRE_DIR)
VALUES
('AXSAD1', 'ABD', 'ANTONIO');
-- ORA-42399: cannot perform a DML operation on a read-only view

DROP VIEW DIRECTORES;

CREATE OR REPLACE VIEW DIRECTORES
(DNI_DIR, COD_AER, NOMBRE_DIR, DIRECCION_DIR, TELEFONO_DIR, PAIS_DIR, COD_AEROPUERTO, NOMBRE_AER)
AS
SELECT DNI, COD_AEROPUERTO, DIRECTOR.NOMBRE, DIRECCION, TELEFONO, DIRECTOR.PAIS, CODIGO, AEROPUERTOS.NOMBRE
FROM DIRECTOR, AEROPUERTOS
WHERE COD_AEROPUERTO = CODIGO;

INSERT INTO DIRECTORES
(DNI_DIR, COD_AER, NOMBRE_DIR, COD_AEROPUERTO, NOMBRE_AER)
VALUES
('AXSAD1', 'ABD', 'ANTONIO', 'ABD', 'ADSSFSD');
-- ORA-01776: cannot modify more than one base table through a join view

-- EJERCICIO 4

-- Elimina la vista y vuélvela a crear con todos los campos y solo con
-- directores que no tengan controladores. Comprueba que a medida que vas
-- updateando la vista dando valor al campo de los controladores estos
-- desaparecen de la Vista.

DROP VIEW DIRECTORES;

CREATE OR REPLACE VIEW DIRECTORES
AS
SELECT *
FROM DIRECTOR
WHERE DIRECTOR.DNI_CONTR IS NULL;

SELECT *
FROM DIRECTORES
WHERE NOMBRE LIKE '%AS%';
-- 5 ROWS

UPDATE DIRECTORES
    SET DNI_CONTR = '77777777S'
    WHERE DNI = '33333333W';

SELECT *
FROM DIRECTORES
WHERE NOMBRE LIKE '%AS%';
-- 4 ROWS

-- EJERCICIO 5

-- Elimina la vista y vuélvela a crear pero esta vez con WITH CHECK OPTION,
-- comprueba como ahora no puedes hacer las actualizaciones anteriores.

DROP VIEW DIRECTORES;

CREATE OR REPLACE VIEW DIRECTORES
AS
SELECT *
FROM DIRECTOR
WHERE DIRECTOR.DNI_CONTR IS NULL
WITH CHECK OPTION;

UPDATE DIRECTORES
    SET DNI_CONTR = '77777777S'
    WHERE DNI = '33333333W';
-- ORA-01402: view WITH CHECK OPTION where-clause violation

-- EJERCICIO 6

-- Crea una Vista sobre la tabla TMP_DIRECTORES aunque no exista.
-- Posteriormente crea la tabla con CREATE TABLE ...... AS SELECT. Y haz un
-- clon de la tabla DIRECTORES, comprueba haciendo una select sobre la vista
-- creada como recoge los datos.

CREATE OR REPLACE FORCE VIEW VISTA_TMP_DIRECTORES
AS
SELECT *
FROM TMP_DIRECTORES;
-- ORA-24344: success with compilation error

CREATE TABLE TMP_DIRECTORES
AS
SELECT *
FROM DIRECTOR;

SELECT *
FROM VISTA_TMP_DIRECTORES;

-- EJERCICIO 7

-- Crea una vista sobre el ejercicio 5 de CONJUNTOS, sacando todos los datos de
-- directores.

-- (Directores de aeropuertos españoles y que no tengan nadie que los controle
-- o que sean norteamericanos y su aeropuerto tenga menos de 3 salidas o que
-- tengan una E en su tercera letra del nombre, queremos que sí salgan
-- repetidos. (Se hará cuando demos agrupaciones).)

CREATE VIEW DIRECTORES2
AS
(SELECT D.NOMBRE
  FROM DIRECTOR D, AEROPUERTOS AE
  WHERE D.COD_AEROPUERTO=AE.CODIGO
  AND AE.PAIS='ESPAÑA'
  AND DNI_CONTR IS NULL
 UNION ALL
SELECT D.NOMBRE
  FROM DIRECTOR D, AEROPUERTOS AE, PROGRAMA_VUELO PR
  WHERE D.COD_AEROPUERTO=AE.CODIGO
  AND AE.CODIGO=COD_AERO_DESPEGAR
  AND (D.PAIS='ESTADOS UNIDOS' OR D.PAIS='USA')
  GROUP BY AE.CODIGO, D.NOMBRE
  HAVING COUNT(*)>3
  UNION ALL                        
SELECT NOMBRE
  FROM DIRECTOR 
  WHERE NOMBRE LIKE '___E%');

-- EJERCICIO 8

--¿Es actualizable?. Realiza una consulta sobre cual es el PAIS que mas
-- directores tiene que cumplen esos requisitos del ejercicio 5, ¿te parece más
-- fácil usando la vista?, hazla sin usar la vista.

INSERT INTO DIRECTORES2
(NOMBRE)
VALUES
('GINES JIMENEZ');
-- ORA-01732: data manipulation operation not legal on this view
-- No es actualizable

SELECT PAIS, COUNT(*) NUMERO_DIRECTORES
FROM DIRECTOR
WHERE DIRECTOR.NOMBRE IN (SELECT DIRECTORES2.NOMBRE FROM DIRECTORES2)
GROUP BY PAIS
HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM DIRECTOR
WHERE DIRECTOR.NOMBRE IN (SELECT DIRECTORES2.NOMBRE FROM DIRECTORES2) GROUP BY PAIS);

SELECT PAIS, COUNT(*) NUMERO_DIRECTORES
FROM DIRECTOR
WHERE DIRECTOR.NOMBRE IN
(
SELECT D.NOMBRE
  FROM DIRECTOR D, AEROPUERTOS AE
  WHERE D.COD_AEROPUERTO=AE.CODIGO
  AND AE.PAIS='ESPAÑA'
  AND DNI_CONTR IS NULL
 UNION ALL
SELECT D.NOMBRE
  FROM DIRECTOR D, AEROPUERTOS AE, PROGRAMA_VUELO PR
  WHERE D.COD_AEROPUERTO=AE.CODIGO
  AND AE.CODIGO=COD_AERO_DESPEGAR
  AND (D.PAIS='ESTADOS UNIDOS' OR D.PAIS='USA')
  GROUP BY AE.CODIGO, D.NOMBRE
  HAVING COUNT(*)>3
  UNION ALL                        
SELECT NOMBRE
  FROM DIRECTOR 
  WHERE NOMBRE LIKE '___E%'
)
GROUP BY PAIS
HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM DIRECTOR
                    WHERE DIRECTOR.NOMBRE IN
                    (
                    SELECT D.NOMBRE
                      FROM DIRECTOR D, AEROPUERTOS AE
                      WHERE D.COD_AEROPUERTO=AE.CODIGO
                      AND AE.PAIS='ESPAÑA'
                      AND DNI_CONTR IS NULL
                     UNION ALL
                    SELECT D.NOMBRE
                      FROM DIRECTOR D, AEROPUERTOS AE, PROGRAMA_VUELO PR
                      WHERE D.COD_AEROPUERTO=AE.CODIGO
                      AND AE.CODIGO=COD_AERO_DESPEGAR
                      AND (D.PAIS='ESTADOS UNIDOS' OR D.PAIS='USA')
                      GROUP BY AE.CODIGO, D.NOMBRE
                      HAVING COUNT(*)>3
                      UNION ALL                        
                    SELECT NOMBRE
                      FROM DIRECTOR 
                      WHERE NOMBRE LIKE '___E%'
                    )
                    GROUP BY PAIS);