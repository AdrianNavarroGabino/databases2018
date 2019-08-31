-- Adrián Navarro Gabino


-- SELECTS


-- EJERCICIO 1

-- Obtén el nombre de los pueblos, población, extensión y densidad de población
-- (la densidad se ha de calcular).

SELECT NOM, POBLACIO, EXTENSIO, POBLACIO/EXTENSIO AS DENSITAT
FROM POBLACIONS;

-- EJERCICIO 2

-- Saca las distintas localidades donde haya institutos (cada localidad solo
-- ha de salir una vez).

SELECT DISTINCT LOCALITAT
FROM INSTITUTS;

-- EJERCICIO 3

-- Saca las poblaciones de habla valenciana que estén a más de 1.000 de altura.

SELECT *
FROM POBLACIONS
WHERE LLENGUA='V'
  AND ALTURA>1000;
  
-- EJERCICIO 4

-- Saca las poblaciones de una densidad de población de más de 200 h/Km2 y
-- una altura de más de 500 m.

SELECT *
FROM POBLACIONS
WHERE POBLACIO/EXTENSIO>200 AND ALTURA>500;

-- EJERCICIO 5

-- Saca el número de comarcas de cada provincia.

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

-- Calcular el número de Institutos de cada población.

SELECT LOCALITAT, COUNT(NOM)
FROM INSTITUTS
GROUP BY LOCALITAT;

-- EJERCICIO 2

-- Saca las comarcas de más de 100.000 habitantes.

SELECT NOM_C, SUM(POBLACIO) TOTAL_HABITANTS
FROM POBLACIONS
GROUP BY NOM_C
HAVING SUM(POBLACIO)>100000;

-- EJERCICIO 3

-- Saca la densidad de población de cada comarca, ordenada por esta de forma
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
-- provincia por comarca, y dentro de cada comarca por nombre de la población.

SELECT NOM, CO.NOM_C, PROVINCIA
FROM POBLACIONS PO, COMARQUES CO
WHERE PO.NOM_C=CO.NOM_C
ORDER BY PROVINCIA, CO.NOM_C, NOM;

-- EJERCICIO 2

-- Saca el número de habitantes de cada población y el número de los institutos
-- (incluyendo los que no tienen).

SELECT PO.NOM NOM_POBLACIO, POBLACIO NUM_HABITANTS, COUNT(INS.NOM) NUM_INSTITUTS
FROM POBLACIONS PO, INSTITUTS INS
WHERE PO.NOM=INS.LOCALITAT(+)
GROUP BY PO.NOM, POBLACIO
ORDER BY PO.NOM;

-- EJERCICIO 3

-- Saca el número de habitantes por instituto de aquellas poblaciones que
-- tienen instituto.

SELECT PO.NOM, ROUND(PO.POBLACIO/COUNT(INS.NOM),2) HAB_POR_INSTITUTO
FROM POBLACIONS PO, INSTITUTS INS
WHERE PO.NOM=INS.LOCALITAT
GROUP BY PO.NOM, POBLACIO
ORDER BY PO.NOM;

-- EJERCICIO 4

-- Saca cuátos pueblos hablan valenciano en cada comarca, indicando también
-- la provincia.
-- Saca únicamente aquellas que tengan alguna población que hable valenciano.

SELECT CO.NOM_C, COUNT(LLENGUA), PROVINCIA
FROM POBLACIONS PO, COMARQUES CO
WHERE PO.NOM_C=CO.NOM_C
  AND LLENGUA='V'
GROUP BY CO.NOM_C, PROVINCIA
ORDER BY CO.NOM_C;

-- EJERCICIO 5

-- Saca las comarcas y el número de los institutos de cada comarca, incluyento
-- aquellos que no tienen ninguno.

SELECT NOM_C, COUNT(INS.NOM)
FROM POBLACIONS PO, INSTITUTS INS
WHERE PO.NOM=INS.LOCALITAT(+)
GROUP BY NOM_C;


-- SUBCONSULTAS


-- EJERCICIO 1

-- Saca los pueblos con más habitantes que la media.

SELECT NOM, POBLACIO
FROM POBLACIONS
WHERE POBLACIO > (SELECT AVG(POBLACIO)
                  FROM POBLACIONS)
ORDER BY NOM;

-- EJERCICIO 2

-- Saca toda la información del pueblo con menos habitantes que tenga instituto.

SELECT *
FROM POBLACIONS PO, INSTITUTS INS
WHERE POBLACIO = (SELECT MIN(POBLACIO)
                  FROM POBLACIONS PO, INSTITUTS INS
                  WHERE PO.NOM=INS.LOCALITAT)
  AND PO.NOM=INS.LOCALITAT;

-- EJERCICIO 3

-- Saca los pueblos de más de 2.000 h. que no tengan instituto.

SELECT *
FROM POBLACIONS
WHERE NOM NOT IN (SELECT LOCALITAT FROM INSTITUTS)
  AND POBLACIO>2000
ORDER BY NOM;

-- EJERCICIO 4

-- Saca cuántos pueblos hablan valenciando en cada Comarca, incluso aquellos
-- que no tienen ninguno.

-- Realizala de dos maneras:
-- a) Sin subconsultas con outer join 
-- b) Con una select simple de Comarques y usando una subconsulta en la propia
--    línea de la select.

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

-- Saca las comarcas que tienen más institutos que la media.

SELECT CO.NOM_C, COUNT(*) NUM_INSTITUTS
FROM COMARQUES CO, INSTITUTS INS, POBLACIONS PO
WHERE PO.NOM_C=CO.NOM_C AND PO.NOM=INS.LOCALITAT
GROUP BY CO.NOM_C
HAVING COUNT(*) > (SELECT AVG(COUNT(*))
                   FROM COMARQUES CO, INSTITUTS INS, POBLACIONS PO
                   WHERE PO.NOM_C=CO.NOM_C AND PO.NOM=INS.LOCALITAT
                   GROUP BY CO.NOM_C)
ORDER BY CO.NOM_C;
