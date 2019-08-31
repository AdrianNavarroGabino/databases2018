-- 1.- ¿Funcionaria el siguiente código?. Explicar por qué y como
-- solucionarlo (si se os ocurren varias formas de arreglarlo,
-- explicarlas todas).
-- DECLARE
-- base NUMBER:=100;
-- BEGIN
-- FOR dept IN 1..10 LOOP
-- UPDATE dept SET nom_dept=base+dept
-- WHERE cod_dept=base+dept;
-- END LOOP;
-- END;

-- En el set, si base es una columna de la tabla dept, coge la columna y pasa de
-- la variable y, si existe una columna dept dentro de la tabla dept, coge la
-- columna y pasa del índice.



-- 2- ¿Qué ocurriría al ejecutar el siguiente código?, ¿Por
-- qué?, ¿Cómo arreglarlo? (Si existen varias
-- posibilidades, comentarlas e indicar cual sería más
-- eficiente).
-- DECLARE
-- ap1_emp VARCHAR2(40):='Fernandez';
-- BEGIN
-- DELETE FROM empWHERE ap1_emp=ap1_emp;
-- COMMIT;
-- END;

-- Se borraría todo porque ap1_emp siempre va a ser igual a sí mismo, tanto si
-- coge la variable como si coge una columna ap1_emp (si existe).
-- Además hace commit, por lo que no se podría deshacer.



-- 3.- ¿Es correcto el siguiente código en PL/SQL?, ¿Por qué?
-- Nota:Ignorar el funcionamiento del código (no hace nada), ceñirse
-- exclusivamente a la sintaxis válida en PL/SQL.
-- FOR ctr IN 1..10 LOOP
-- IF NOT fin THEN
-- INSERT INTO temp
-- VALUES (ctr, 'Hola');
-- COMMIT;
-- factor:=ctr*2;
-- ELSE
-- ctr:=10;
-- END IF;
-- END LOOP;

-- En el if not fin, la tabla temp solo puede tener 2 columnas.
-- En el else, no se puede reasignar el índice del for.



-- 4.- ¿Qué resultado provoca la ejecución del siguiente código PL/SQL?
-- DECLARE
-- variable NUMBER:=1;
-- almacenamos NUMBER:=1;
-- BEGIN
-- FOR i IN 5..variable LOOP
-- almacenamos:=almacenamos+i;
-- END LOOP;
-- INSERT INTO traza VALUES(TO_CHAR(almacenamos));
-- COMMIT;
-- END;

-- No se entra al bucle for porque 5 es mas grande que variable.
-- El resultado será 1.



-- 5- ¿Qué da este bloque?
-- DECLARE
-- V_num NUMBER;
-- BEGIN
-- SELECT COUNT(*) INTO V_num
-- FROM productos;
-- DBMS_OUTPUT.PUT_LINE(V_num);
-- END;

-- Saca la cantidad de productos por pantalla.



-- 6- Crea una tabla MENSAJES con un solo campo
-- VALOR, de tipo VARCHAR2(5). Crea un bloque que
-- inserte 8 elementos en la tabla con valores del 1 al 10,
-- excepto el 4 y 5.

CREATE TABLE MENSAJES
(
    VALOR VARCHAR2(5),
    CONSTRAINT PK_MENSAJES PRIMARY KEY (VALOR)
);

BEGIN
    FOR I IN 1..10 LOOP
        IF I != 4 AND I != 5 THEN
            INSERT INTO MENSAJES
                (VALOR)
            VALUES
                (I);
        END IF;
    END LOOP;
END;



-- 7- Vuelve a usar la tabla anterior con los datos ya
-- rellenos, y realizar un bucle que mande los 10
-- primeros números. Si el número que viene es menor
-- que 4 entonces debes sacar un mensaje de error si ya
-- existe, si el número es mayor o igual que 4, debes
-- insertarlo en la tabla si no existe y actualizarlo
-- sumándole 1 si ya existe.

DECLARE
    APARICIONES_PK NUMBER;
BEGIN
    FOR I IN 1..10 LOOP
        SELECT COUNT(VALOR)
        INTO APARICIONES_PK
        FROM MENSAJES
        WHERE VALOR = I;
        
        IF I < 4 AND APARICIONES_PK = 1 THEN
            DBMS_OUTPUT.PUT_LINE('ERROR');
        ELSE
            IF APARICIONES_PK = 0 THEN
                INSERT INTO MENSAJES
                    (VALOR)
                VALUES
                    (I);
            ELSE
                UPDATE MENSAJES
                    SET VALOR = VALOR + 1;
            END IF;
        END IF;
    END LOOP;
END;

-- 8- Crea una tabla PRODUCTO(CODPROD, NOMPROD,
-- PRECIO), usando SQL (no uses un bloque PL/SQL).
-- Añade un producto a la tabla usando una sentencia insert
-- dentro de un bloque PL/SQL.

CREATE TABLE PRODUCTOS
(
    CODPROD NUMBER,
    NOMPROD VARCHAR2(20),
    PRECIO NUMBER,
    CONSTRAINT PK_PRODUCTOS PRIMARY KEY (CODPROD)
);

BEGIN
    INSERT INTO PRODUCTOS
        (CODPROD, NOMPROD, PRECIO)
    VALUES
        (1, 'CAMISETA', 10.99);
END;

-- 9. Añade otro producto, ahora utilizando una lista de variables
-- en la sentencia insert.

DECLARE
    CODIGO PRODUCTOS.CODPROD%TYPE := 2;
    NOMBRE PRODUCTOS.NOMPROD%TYPE := 'PANTALON';
    PVP PRODUCTOS.PRECIO%TYPE := 20;
BEGIN
    INSERT INTO PRODUCTOS
        (CODPROD, NOMPROD, PRECIO)
    VALUES
        (CODIGO, NOMBRE, PVP);
END;



-- 10. Añade, ahora usando un registro PL/SQL, dos produtos más.

DECLARE
    NOMBRE PRODUCTOS.NOMPROD%TYPE;
    PVP PRODUCTOS.PRECIO%TYPE;
BEGIN
    SELECT MAX(LENGTH(NOMPROD))
    INTO PVP
    FROM PRODUCTOS;
    
    INSERT INTO PRODUCTOS
        (CODPROD, NOMPROD, PRECIO)
    VALUES
        (3, 'GORRA', PVP);
    
    SELECT NOMPROD
    INTO NOMBRE
    FROM PRODUCTOS
    WHERE NOMPROD LIKE 'C%';
    
    INSERT INTO PRODUCTOS
        (CODPROD, NOMPROD, PRECIO)
    VALUES
        (4, NOMBRE, 15);
END;

-- 11. Borra el producto de código más pequeño, e incrementa el
-- precio de los demás en un 5%.

BEGIN
    DELETE FROM PRODUCTOS
    WHERE CODPROD = (SELECT MIN(CODPROD)
                    FROM PRODUCTOS);
            
    UPDATE PRODUCTOS
        SET PRECIO = PRECIO * 1.05;
END;


-- 12. Obtén y muestra por pantalla el número de productos que
-- hay almacenados, usando select ... Into y el mensaje “Hay n
-- productos”.

DECLARE
    NUM_PROD NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO NUM_PROD
    FROM PRODUCTOS;
    
    DBMS_OUTPUT.PUT_LINE('Hay '||NUM_PROD||' productos');
END;


-- 13. Obtén y muestra todos los datos de un producto (busca a
-- partir de la clave primaria), Si el producto existe obtén todos los
-- datos del mismo en un registro PL/SQL e imprímelos, si no
-- existe saca un mensaje de error.

DECLARE
    CODIGO_BUSCAR PRODUCTOS.CODPROD%TYPE := 3;
    NOMBRE PRODUCTOS.NOMPROD%TYPE;
    PVP PRODUCTOS.PRECIO%TYPE;
    APARICIONES_PK NUMBER;
BEGIN
    SELECT COUNT(CODPROD)
    INTO APARICIONES_PK
    FROM PRODUCTOS
    WHERE CODPROD = CODIGO_BUSCAR;

    IF APARICIONES_PK = 1 THEN
        SELECT NOMPROD, PRECIO
        INTO NOMBRE, PVP
        FROM PRODUCTOS
        WHERE CODPROD = CODIGO_BUSCAR;
        
        DBMS_OUTPUT.PUT_LINE('CODIGO: '||CODIGO_BUSCAR);
        DBMS_OUTPUT.PUT_LINE('NOMBRE: '||NOMBRE);
        DBMS_OUTPUT.PUT_LINE('PRECIO: '||PVP);
    ELSE
        DBMS_OUTPUT.PUT_LINE('CODIGO NO ENCONTRADO');
    END IF;
END;

-- 14- Haz un bloque PL/SQL, de forma que se indique que no hay
-- productos, que hay pocos (si hay entre 1 y 3) o el número exacto
-- de produtos existentes (si hay más de 3).

DECLARE
    NUMERO NUMBER;
    RESULTADO VARCHAR2(10);
BEGIN
    SELECT COUNT(*)
    INTO NUMERO
    FROM PRODUCTOS;
    
    IF NUMERO = 0 THEN
        RESULTADO := 'NO HAY';
    ELSIF NUMERO >= 1 AND NUMERO <= 3 THEN
        RESULTADO := 'HAY POCOS';
    ELSE
        RESULTADO := NUMERO;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(RESULTADO);
END;