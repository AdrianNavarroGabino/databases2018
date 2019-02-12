-- Adrián Navarro Gabino

-- EJERCICIO 5

-- Partidos (Equipo local, visitante y partido) que se hayan jugado
-- antes del 20/06/2006

SELECT EQUIPO_L, EQUIPO_V, FECHA
FROM PARTIDO
WHERE FECHA < TO_DATE('20/06/2006','DD/MM/YYYY');