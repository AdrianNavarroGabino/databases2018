-- Adri�n Navarro Gabino


-- SELECTS


-- EJERCICIO 1

-- Obt�n el nombre de los pueblos, poblaci�n, extensi�n y densidad de poblaci�n
-- (la densidad se ha de calcular).

SELECT NOM, POBLACIO, EXTENSIO, POBLACIO/EXTENSIO AS DENSITAT
FROM POBLACIONS;

-- EJERCICIO 2

-- Saca las distintas localidades donde haya institutos (cada localidad solo
-- ha de salir una vez).

SELECT DISTINCT LOCALITAT
FROM INSTITUTS;

-- EJERCICIO 3

-- Saca las poblaciones de habla valenciana que est�n a m�s de 1.000 de altura.

SELECT *
FROM POBLACIONS
WHERE LLENGUA='V'
  AND ALTURA>1000;
  
-- EJERCICIO 4

-- Saca las poblaciones de una densidad de poblaci�n de m�s de 200 h/Km2 y
-- una altura de m�s de 500 m.

SELECT *
FROM POBLACIONS
WHERE POBLACIO/EXTENSIO>200 AND ALTURA>500;

-- EJERCICIO 5

-- Saca el n�mero de comarcas de cada provincia.

SELECT PROVINCIA, COUNT(*)
FROM COMARQUES CO
GROUP BY PROVINCIA;

-- EJERCICIO 6

-- Saca todas las poblaciones, ordenadas por comarca, y dentro de la misma
-- comarca por nombre.

SELECT NOM, NOM_C
FROM POBLACIONS
ORDER BY NOM_C, NOM;

-- EJERCICIO 7

-- Saca las poblaciones de la comarca de l'Alt Maestrat, ordenadas por altura
-- de forma descendente.

SELECT NOM
FROM POBLACIONS
WHERE UPPER(NOM_C) = 'ALT MAESTRAT'
ORDER BY ALTURA DESC;


-- AGRUPACIONES


-- EJERCICIO 1

-- Calcular el n�mero de Institutos de cada poblaci�n.

SELECT LOCALITAT, COUNT(NOM)
FROM INSTITUTS
GROUP BY LOCALITAT;

-- EJERCICIO 2

-- Saca las comarcas de m�s de 100.000 habitantes.

SELECT NOM_C, SUM(POBLACIO) TOTAL_HABITANTS
FROM POBLACIONS
GROUP BY NOM_C
HAVING SUM(POBLACIO)>100000;

-- EJERCICIO 3

-- Saca la densidad de poblaci�n de cada comarca, ordenada por esta de forma
-- descendente.

SELECT NOM_C, SUM(POBLACIO)/SUM(EXTENSIO) DENSITAT
FROM POBLACIONS
GROUP BY NOM_C
ORDER BY DENSITAT DESC;

-- EJERCICIO 4

-- Cuenta cuantas lenguas son originarias de cada comarca.

SELECT NOM_C, COUNT(DISTINCT LLENGUA)
FROM POBLACIONS
GROUP BY NOM_C;


-- INNER/OUTER JOIN


-- EJERCICIO 1

-- Saca todas las poblaciones, ordenadas por provincia, dentro de la misma
-- provincia por comarca, y dentro de cada comarca por nombre de la poblaci�n.

SELECT NOM, CO.NOM_C, PROVINCIA
FROM POBLACIONS PO, COMARQUES CO
WHERE PO.NOM_C=CO.NOM_C
ORDER BY PROVINCIA, CO.NOM_C, NOM;

-- EJERCICIO 2

-- Saca el n�mero de habitantes de cada poblaci�n y el n�mero de los institutos
-- (incluyendo los que no tienen).

SELECT PO.NOM NOM_POBLACIO, POBLACIO NUM_HABITANTS, COUNT(INS.NOM) NUM_INSTITUTS
FROM POBLACIONS PO, INSTITUTS INS
WHERE PO.NOM=INS.LOCALITAT(+)
GROUP BY PO.NOM, POBLACIO
ORDER BY PO.NOM;

-- EJERCICIO 3

-- Saca el n�mero de habitantes por instituto de aquellas poblaciones que
-- tienen instituto.

SELECT PO.NOM, ROUND(PO.POBLACIO/COUNT(INS.NOM),2) HAB_POR_INSTITUTO
FROM POBLACIONS PO, INSTITUTS INS
WHERE PO.NOM=INS.LOCALITAT
GROUP BY PO.NOM, POBLACIO
ORDER BY PO.NOM;

-- EJERCICIO 4

-- Saca cu�tos pueblos hablan valenciano en cada comarca, indicando tambi�n
-- la provincia.
-- Saca �nicamente aquellas que tengan alguna poblaci�n que hable valenciano.

SELECT CO.NOM_C, COUNT(LLENGUA), PROVINCIA
FROM POBLACIONS PO, COMARQUES CO
WHERE PO.NOM_C=CO.NOM_C
  AND LLENGUA='V'
GROUP BY CO.NOM_C, PROVINCIA
ORDER BY CO.NOM_C;

-- EJERCICIO 5

-- Saca las comarcas y el n�mero de los institutos de cada comarca, incluyento
-- aquellos que no tienen ninguno.

SELECT NOM_C, COUNT(INS.NOM)
FROM POBLACIONS PO, INSTITUTS INS
WHERE PO.NOM=INS.LOCALITAT(+)
GROUP BY NOM_C;


-- SUBCONSULTAS


-- EJERCICIO 1

-- Saca los pueblos con m�s habitantes que la media.

SELECT NOM, POBLACIO
FROM POBLACIONS
WHERE POBLACIO > (SELECT AVG(POBLACIO)
                  FROM POBLACIONS)
ORDER BY NOM;

-- EJERCICIO 2

-- Saca toda la informaci�n del pueblo con menos habitantes que tenga instituto.

SELECT *
FROM POBLACIONS PO, INSTITUTS INS
WHERE POBLACIO = (SELECT MIN(POBLACIO)
                  FROM POBLACIONS PO, INSTITUTS INS
                  WHERE PO.NOM=INS.LOCALITAT)
  AND PO.NOM=INS.LOCALITAT;

-- EJERCICIO 3

-- Saca los pueblos de m�s de 2.000 h. que no tengan instituto.

SELECT *
FROM POBLACIONS
WHERE NOM NOT IN (SELECT LOCALITAT FROM INSTITUTS)
  AND POBLACIO>2000
ORDER BY NOM;

-- EJERCICIO 4

-- Saca cu�ntos pueblos hablan valenciando en cada Comarca, incluso aquellos
-- que no tienen ninguno.

-- Realizala de dos maneras:
-- a) Sin subconsultas con outer join 
-- b) Con una select simple de Comarques y usando una subconsulta en la propia
--    l�nea de la select.

SELECT CO.NOM_C, COUNT(NOM) PARLEN_VLC, PROVINCIA
FROM POBLACIONS PO, COMARQUES CO
WHERE LLENGUA(+)='V'
  AND PO.NOM_C(+)=CO.NOM_C
GROUP BY CO.NOM_C, PROVINCIA
ORDER BY CO.NOM_C;

SELECT CO.NOM_C,
            NVL((SELECT COUNT(LLENGUA)
            FROM POBLACIONS PO
            WHERE LLENGUA='V'
            AND CO.NOM_C=PO.NOM_C
            GROUP BY NOM_C, CO.PROVINCIA), 0) PARLEN_VLC,
       PROVINCIA
FROM COMARQUES CO
ORDER BY NOM_C;

-- EJERCICIO 5

-- Saca las comarcas que tienen m�s institutos que la media.

SELECT CO.NOM_C, COUNT(*) NUM_INSTITUTS
FROM COMARQUES CO, INSTITUTS INS, POBLACIONS PO
WHERE PO.NOM_C=CO.NOM_C AND PO.NOM=INS.LOCALITAT
GROUP BY CO.NOM_C
HAVING COUNT(*) > (SELECT AVG(COUNT(*))
                   FROM COMARQUES CO, INSTITUTS INS, POBLACIONS PO
                   WHERE PO.NOM_C=CO.NOM_C AND PO.NOM=INS.LOCALITAT
                   GROUP BY CO.NOM_C)
ORDER BY CO.NOM_C;
