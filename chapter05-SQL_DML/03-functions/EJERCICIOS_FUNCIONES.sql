-- Adri�n Navarro Gabino

-- EJERCICIO 1

-- Actualiza la edad de los jugadores que contengan la cadena �MES� en el
-- nombre a vac�o, no puedes usar la cl�usula LIKE. 

ALTER TABLE JUGADOR MODIFY
(
    EDAD NULL
);

UPDATE JUGADOR
    SET EDAD = NULL
    WHERE INSTR(NOMBRE, 'MES') > 0;

-- EJERCICIO 2

-- Obt�n el n�mero de plazas vac�as m�xima y m�nima que tenemos en los vuelos,
-- y la suma de todas las mismas (sin contar escalas). Tambi�n debes obtener
-- a parte la suma de todas las plazas vac�as que dicho campo este vac�o (NULL)
-- (todo en la misma consulta).

SELECT  MAX(AV.CAPACIDAD - V.PLAZAS_OCUPADAS) AS PLAZAS_MAX,
        MIN(AV.CAPACIDAD - V.PLAZAS_OCUPADAS) AS PLAZAS_MIN,
        SUM(AV.CAPACIDAD - V.PLAZAS_OCUPADAS) AS SUMA_PLAZAS,
        COUNT(*) - COUNT(V.PLAZAS_OCUPADAS) AS PLAZAS_VACIAS
FROM VOLAR V, AVIONES AV
WHERE V.COD_AVION=AV.CODIGO;

SELECT COUNT(*)
FROM VOLAR
WHERE PLAZAS_OCUPADAS IS NULL;

-- EJERCICIO 3

-- Consigue el n�mero total de partidos junto con la fecha m�s antigua de los
-- mismos. 

SELECT DISTINCT EQUIPO_L, EQUIPO_V, FECHA
FROM PARTIDO
ORDER BY FECHA;

-- EJERCICIO 4

-- Escribe una cadena de texto de 205 caracteres tecleando una solo �X�, para
-- ello usa una funci�n de cadenas y la tabla maestra de ORACLE DUAL.

SELECT LPAD('X',205,'X') FROM DUAL;

-- EJERCICIO 5

-- Realiza una inserci�n en la tabla DIRECTOR y como nombre del mismo utiliza
-- la cadena del ejercicio anterior, como no cabr� introduce tan solo los
-- caracteres justos que caben en el campo NOMBRE de la tabla, usando una
-- funci�n de ORACLE.

INSERT INTO DIRECTOR
(DNI, COD_AEROPUERTO, NOMBRE)
VALUES
('74154186B','KNH',RPAD(LPAD('X',205,'X'),60,'X'));

-- EJERCICIO 6

-- Actualiza las edad de los jugadores de la siguiente forma: donde alguna de
-- las letras de su nombre tengan el c�digo ASCII 65 a 4,9555555, con c�digo
-- ASCII 67 a 5,9255555 y con 70 a 8,3453634 y el resto a 9,3323423.

ALTER TABLE JUGADOR MODIFY
(
    EDAD VARCHAR2(9)
);

UPDATE JUGADOR
    SET EDAD=4.9555555
WHERE INSTR(NOMBRE, CHR(65)) > 0;

UPDATE JUGADOR
    SET EDAD=5.9255555
WHERE INSTR(NOMBRE, CHR(65)) = 0
  AND INSTR(NOMBRE, CHR(67)) > 0;

UPDATE JUGADOR
    SET EDAD=8.3453634
WHERE INSTR(NOMBRE, CHR(65)) = 0
  AND INSTR(NOMBRE, CHR(67)) = 0
  AND INSTR(NOMBRE, CHR(70)) > 0;
  
UPDATE JUGADOR
    SET EDAD=9.3323423
WHERE INSTR(NOMBRE, CHR(65)) = 0
  AND INSTR(NOMBRE, CHR(67)) = 0
  AND INSTR(NOMBRE, CHR(70)) = 0;
  
-- EJERCICIO 7

-- Realiza una consulta de todas las edades redondeadas y truncadas solo
-- con 2, 3 y ning�n decimal viendo la diferencia entre ellas, todo en 1 sola
-- consulta. 

SELECT ROUND(EDAD,0), ROUND(EDAD,2), ROUND(EDAD,3), TRUNC(EDAD,0),
    TRUNC(EDAD,2), TRUNC(EDAD,3)
FROM JUGADOR;

-- EJERCICIO 8

-- Saca a los modelos de AVION de 4 formas en la misma select, en may�sculas,
-- en min�sculas, con la primera letra may�scula y el resto min�scula y normal.

SELECT DISTINCT UPPER(MODELO) AS MODELO_UPPER,
            LOWER(MODELO) AS MODELO_LOWER,
            REPLACE(
                SUBSTR(MODELO,1,1),SUBSTR(MODELO,1,1),UPPER(SUBSTR(MODELO,1,1)))
                || LOWER(SUBSTR(MODELO,2)) AS MODELO_PRIMERA_MAY,
            MODELO
FROM AVIONES;

-- EJERCICIO 9

-- Introduce los siguientes DIRECTORES en tu base de datos:
-- a. Con DNI 90 y nombre �HHHHHTengo haches a la izquierda�, debes ponerle
-- a esta cadena esas 5 H a la izquierda usando una funci�n de ORACLE.

INSERT INTO DIRECTOR
(DNI, COD_AEROPUERTO, NOMBRE)
VALUES
('90', 'KGK', LPAD('Tengo haches a la izquierda',
                    LENGTH('Tengo haches a la izquierda') + 5, 'H'));
                    
-- b. Con DNI 95 y nombre �Tengo haches a la derechaHHHHH�, usando una funci�n.

INSERT INTO DIRECTOR
(DNI, COD_AEROPUERTO, NOMBRE)
VALUES
('95', 'HLA', RPAD('Tengo haches a la derecha',
                    LENGTH('Tengo haches a la derecha') + 5, 'H'));
                    
-- c. Con DNI 100 y nombre lo debes sacar de una select de un �rbitro que se
-- llame James Bond, y al ins�rtalo debes remplazar el Bon por el c�digo ASCII
-- de la letra A.

INSERT INTO DIRECTOR
(DNI, COD_AEROPUERTO, NOMBRE)
VALUES
('100', 'KUL', REPLACE((SELECT NOMBRE
                FROM MUNDIAL.ARBITRO
                WHERE NOMBRE='JAMES BOND'), 'BON', ASCII('A')));
               
-- d. TODOS LOS DNI deben tener 9 d�gitos, es decir debes rellenar con 0 a la
-- izquierda hasta completar. Si te da error debes ingeni�rtelas para
-- conseguirlo.

SELECT COUNT(*), LPAD(DNI,9,'0')
FROM DIRECTOR
GROUP BY LPAD(DNI,9,'0')
HAVING COUNT(*)>1;

UPDATE DIRECTOR
    SET DNI='123456789'
WHERE DNI='111J';

UPDATE DIRECTOR
    SET DNI=LPAD(DNI,9,'0'),
        DNI_CONTR=LPAD(DNI,9,'0');

-- EJERCICIO 10

-- Actualiza todos las columnas de la tabla JUGADOR que tengan NULOS al valor
-- que quieras, pero no puedes utilizar ni IS NULL ni IS NOT NULL.

UPDATE JUGADOR
    SET DIRECCION=NVL(DIRECCION, '--'),
        PUESTO_HAB=NVL(PUESTO_HAB, '--'),
        FECHA_NAC=NVL(FECHA_NAC, TO_DATE('01/01/1950','DD/MM/YYYY')),
        TELEFONO=NVL(TELEFONO, 0),
        TIPO_JUGADOR=NVL(TIPO_JUGADOR, '--'),
        EDAD=NVL(EDAD, '--');
        
-- EJERCICIO 11

-- CONVERSIONES

-- a. Obt�n cu�ntos d�as, meses y a�os han pasado de cada partido.

SELECT EQUIPO_L, EQUIPO_V, FECHA,
    TRUNC((TO_DATE(SYSDATE, 'DD/MM/YYYY') - TO_DATE(FECHA, 'DD/MM/YYYY')) / 365)
    || ' A�OS, ' ||
    TRUNC(MOD(
       TO_DATE(SYSDATE, 'DD/MM/YYYY') - TO_DATE(FECHA, 'DD/MM/YYYY'), 365) / 12)
    || ' MESES, ' ||
    MOD(MOD(
       TO_DATE(SYSDATE, 'DD/MM/YYYY') - TO_DATE(FECHA, 'DD/MM/YYYY'), 365), 12)
    || 'D�AS.' AS TIEMPO
FROM PARTIDO;

-- b. Actualiza 3 fechas que quieras de matricular, una a 1/1/2012 otra a
-- 1/2/2012 y otra a 10/12/1942, poniendo el orden de dia, mes y a�o con 3
-- ordenes diferentes.

UPDATE JUGADOR
    SET FECHA_NAC=TO_DATE('01/02/1996','DD/MM/YYYY')
WHERE NOMBRE='JUSTO VILLAR';

UPDATE JUGADOR
    SET FECHA_NAC=TO_DATE('1995/12/31','YYYY/MM/DD')
WHERE NOMBRE='KIM KUM IL';

UPDATE JUGADOR
    SET FECHA_NAC=TO_DATE('11231998','MMDDYYYY')
WHERE NOMBRE='LI TIE';

-- EJERCICIO 12

-- CONDICIONALES

-- a. Realiza una actualizaci�n de las edades de los jugadores si es ESPA�A
-- a 18 si es FRANCIA a 20, si ALEMANIA a 25 y si es ESTADOS UNIDOS a 30
-- cualquier otra edad a -1, usa la funci�n pertinente y en una sola update. 

UPDATE JUGADOR
    SET EDAD = DECODE(EQUIPO_JUGADOR, 'ESPA�A', 18,
                                      'FRANCIA', 20,
                                      'ALEMANIA', 25,
                                      'ESTADOS UNIDOS', 30,
                                      -1);
                                      
-- b. Usando la funci�n MOD, haz una select que si el �ltimo car�cter del n�mero
-- de vuelo es par, diga PAR, si es impar diga IMPAR y si no es nada diga
-- IMPOSIBLE. Debes asegurarte que el �ltimo sea n�mero en el WHERE. Debes usar
-- la funci�n que te devuelve el resto.

SELECT CODIGO,
    DECODE(MOD(ASCII(SUBSTR(CODIGO,LENGTH(CODIGO))), 2), 0, 'PAR', 'IMPAR')
FROM AVIONES;

-- EJERCICIO 13

--  Crea una Secuencia con los par�metros por defecto.

CREATE SEQUENCE PARAMETROS_POR_DEFECTO
START WITH 1
INCREMENT BY 1
MAXVALUE 999999
MINVALUE 1;

-- EJERCICIO 14

--  Crea un campo ID NUMBER en la tabla EQUIPOS.

ALTER TABLE EQUIPOS ADD
(
    ID_NUMBER NUMBER
);

-- EJERCICIO 15

-- Inserta 3 EQUIPOS en la tabla haciendo uso de la secuencia, haz una select
-- al final de la secuencia para comprobar en qu� valor se ha quedado
-- (usando DUAL). 

INSERT INTO EQUIPOS
(ID_NUMBER, EQUIPO)
VALUES
(PARAMETROS_POR_DEFECTO.NEXTVAL, 'TAYIKIST�N');

INSERT INTO EQUIPOS
(ID_NUMBER, EQUIPO)
VALUES
(PARAMETROS_POR_DEFECTO.NEXTVAL, 'VANUATU');

INSERT INTO EQUIPOS
(ID_NUMBER, EQUIPO)
VALUES
(PARAMETROS_POR_DEFECTO.NEXTVAL, 'PALAOS');

SELECT PARAMETROS_POR_DEFECTO.CURRVAL FROM DUAL;