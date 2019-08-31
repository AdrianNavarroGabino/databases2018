

-- 1- Crear una función pl/sql que duplica la cantidad recibida como parámetro.

CREATE OR REPLACE FUNCTION DUPLICAR (NUM IN NUMBER)
RETURN NUMBER
IS
BEGIN
    RETURN NUM * 2;
END DUPLICAR;



-- 2- Crear una función pl/sql llamada factorial que devuelva el factorial de un
-- número (sin usar recursividad), por ejemplo 5! = 1 * 2 * 3 * 4 * 5 = 120.

CREATE OR REPLACE FUNCTION FACTORIAL (NUM IN NUMBER)
RETURN NUMBER
IS
    RESULT NUMBER := 1;
BEGIN
    IF NUM < 0 THEN
        RESULT := -1;
    ELSIF NUM = 0 THEN
        RESULT := 1;
    ELSE
        FOR I IN 1..NUM LOOP
            RESULT := RESULT * I;
        END LOOP;
    END IF;
    
    RETURN RESULT;
END FACTORIAL;



-- 3- Crear un procedimiento pl/sql que muestra los números desde el 1 hasta el
-- valor pasado como parámetro.

CREATE OR REPLACE PROCEDURE MUESTRA_NUMEROS(NUM IN NUMBER)
IS
    C VARCHAR2(50):= '1';
BEGIN
    FOR i IN 2..NUM LOOP
        C := C||' '||i;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(C);
END MUESTRA_NUMEROS;



-- 4- Modificar el procedimiento del Ejercicio anterior para que muestre números
-- desde un valor inferior hasta uno superior con cierto salto, que por defecto
-- será 1.

CREATE OR REPLACE PROCEDURE MUESTRA_NUMEROS2
(INF IN NUMBER, SUP IN NUMBER, SALTO IN NUMBER:=1)
IS
    C VARCHAR2(50):= INF;
BEGIN
    FOR i IN (INF+SALTO)..SUP LOOP
        IF MOD(i - INF - SALTO, SALTO) = 0 THEN
            C := C||' '||i;
        END IF;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(C);
END MUESTRA_NUMEROS2;



-- 5- Modificar el procedimiento del Ejercicio anterior para que inserte los
-- números en una tabla.

CREATE TABLE TABLA_EJ5 (
    NUMERO NUMBER(4) NOT NULL,
    CONSTRAINT PK_TABLA_EJ5 PRIMARY KEY (NUMERO)
);

CREATE OR REPLACE PROCEDURE ANYADE_NUMEROS
(INF IN NUMBER, SUP IN NUMBER, SALTO IN NUMBER:=1)
IS
    V_NUMERO NUMBER;
    INDICES NUMBER := (SUP - INF) / SALTO - 1;
BEGIN
    FOR I IN 0..INDICES LOOP
        V_NUMERO := INF + SALTO * I;
        INSERT INTO TABLA_EJ5 (NUMERO)
        VALUES
        (V_NUMERO);
    END LOOP;
END ANYADE_NUMEROS;

-- 6- Crea una función llamada, PVP que toma como argumento un código de producto,
-- una descripción y un coste del producto, y realice una inserción en una
-- tabla PRODUCTOS si el código de producto (PK) no existe y en caso de existir
-- actualice los datos de descripción y coste y devuelva el precio de venta al
-- público, que resulta de aplicarle a ese precio de coste un margen comercial
-- del 20%.

CREATE OR REPLACE FUNCTION PVP
(CODIGO IN VARCHAR2, DESCRIPCION IN VARCHAR2, COSTE NUMBER)
RETURN NUMBER
IS
    PRECIO_FINAL NUMBER;
BEGIN
    RETURN PRECIO_FINAL;
END PVP;


-- 7- Dado este PL/SQL:

CREATE OR REPLACE PROCEDURE modificar_precio_producto (codigoprod NUMBER,
nuevoprecio NUMBER)
AS
    Precioant NUMBER(5);
BEGIN
    SELECT precio_uni INTO precioant
    FROM productos
    WHERE cod_producto = codigoprod;
    IF (precioant * 0.20) > ABS(precioant - nuevoprecio) then
        UPDATE productos
        SET precio_uni = nuevoprecio
        WHERE cod_producto = codigoprod;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Error, modificación superior a 20%');
    END IF;
EXCEPTION
WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE ('No encontrado el producto ' || codigoprod);
END modificar_precio_producto;

-- Responde a las siguientes preguntas:
-- a) ¿Se trata de una función o de un procedimiento, por qué?, ¿Qué
-- habría que cambiar para que fuera lo otro?

-- Se trata de un procedimiento porque no devuelve nada y tiene procedure en vez
-- de function.
-- Habría que cambiar procedure por function y añadir el return.


-- b)¿Cuál es la cabecera del procedimiento?

-- CREATE OR REPLACE PROCEDURE modificar_precio_producto (codigoprod NUMBER,
-- nuevoprecio NUMBER)


-- c) ¿Qué es el precioant?

-- Una variable numerica de 5 dígitos.


-- d)¿Qué es el nuevoprecio?

-- Un parámetro numérico que se le pasa al procedimiento.


-- e) ¿Qué es el precio_uni?

-- Una columna de la tabla productos.


-- f) ¿Cuáles son los parámetros del procedimiento?

-- codigoprod y nuevoprecio


-- g)¿Qué es NO_DATA_FOUND?

-- Un tipo de excepción.

-- h)¿Cuál es el nombre del procedimiento?

-- modificar_precio_producto


-- i) ¿Dónde comienza el bloque?

-- En el begin.


-- j) ¿Qué hace la cláusula into?

-- Almacenar en la variable precioant el resultado de la select.


-- k)¿qué hace la condición del IF?

-- Comprobar si el 20% de precioant es mayor que el valor absoluto de precioant
-- menos nuevoprecio.


-- l) ¿Porque no tiene la cláusula declare?¿Qué tiene en su lugar?

-- En los procedimientos, para la declaración de variables se utiliza IS/AS, no
-- DECLARE.



-- 8- Corregir los errores de sintaxis en esta función Esta función PL/SQL devuelve el
-- número PI (3,141592653589793238462...). Calculado mediante el algoritmo que ideó
-- John Wallis en 1665

CREATE OR REPLACE FUNCTION piWallis(pIteraciones in number)
return number
IS
    vCont number;
    vRet number;
BEGIN
    vCont := 0;
    vRet := 1;
    
    loop
        vCont := vCont + 1;
        
        if mod(vCont,2) = 0 then
            vRet := vRet * vCont / (vCont + 1);
        else
            vRet := vRet * (vCont + 1) / vCont;
        end if;
        exit when vCont > pIteraciones;
    end loop;
    return (2 * vRet);
END piWallis;



-- 9- Introduces todas las funciones y procedimentos de
-- los ejercicios anteriores en un PACKAGE llamado
-- FUNCIONES_PROCE

CREATE OR REPLACE PACKAGE FUNCIONES_PROCE IS
    PROCEDURE MUESTRA_NUMEROS(NUM IN NUMBER);
    
    PROCEDURE MUESTRA_NUMEROS2
    (INF IN NUMBER, SUP IN NUMBER, SALTO IN NUMBER:=1);
    
    PROCEDURE ANYADE_NUMEROS
    (INF IN NUMBER, SUP IN NUMBER, SALTO IN NUMBER:=1);
    
    FUNCTION DUPLICAR (NUM IN NUMBER)
    RETURN NUMBER;
    
    FUNCTION FACTORIAL (NUM IN NUMBER)
    RETURN NUMBER;
    
    FUNCTION PVP
    (CODIGO IN VARCHAR2, DESCRIPCION IN VARCHAR2, COSTE NUMBER)
    RETURN NUMBER;
    
    FUNCTION piWallis(pIteraciones in number)
    return number;
END FUNCIONES_PROCE;

-- 10- Ejecuta los procedimientos y funciones del nuevo
-- Paquete desde un bloque anónimo.

DECLARE
    PRUEBA NUMBER;
BEGIN
    PRUEBA := FUNCIONES_PROCE.PVP('AAAA', 'AAAA', 25);
    DBMS_OUTPUT.PUT_LINE(PRUEBA);
    
    FUNCIONES_PROCE.MUESTRA_NUMEROS(8);
END;

