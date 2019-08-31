-- Adrián Navarro Gabino


-- EJERCICIO 1

-- Realiza el ejercicio 6 de funciones, usando
-- excepciones.

CREATE OR REPLACE FUNCTION PVP
(CODIGO_PROD IN VARCHAR2, DESCRIPCION_PROD IN VARCHAR2, COSTE_PROD NUMBER)
RETURN NUMBER
AS
BEGIN
    INSERT INTO PRODUCTOS
    (CODIGO, DESCRIPCION, COSTE)
    VALUES
    (CODIGO_PROD, DESCRIPCION_PROD, COSTE_PROD * 1.2);
    
    RETURN COSTE_PROD * 1.2;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        UPDATE PRODUCTOS
        SET DESCRIPCION = DESCRIPCION_PROD,
            COSTE = COSTE_PROD,
            PVP = COSTE_PROD * 1.2
        WHERE CODIGO = CODIGO_PROD;
        
        RETURN COSTE_PROD * 1.2;
END;

-- EJERCICIO 2

-- Realiza el ejercicio anterior dando un mensaje de
-- error en caso de que ya exista. (Sin hacer el update)

CREATE OR REPLACE FUNCTION PVP
(CODIGO_PROD IN VARCHAR2, DESCRIPCION_PROD IN VARCHAR2, COSTE_PROD NUMBER)
RETURN NUMBER
AS
BEGIN
    INSERT INTO PRODUCTOS
    (CODIGO, DESCRIPCION, COSTE)
    VALUES
    (CODIGO_PROD, DESCRIPCION_PROD, COSTE_PROD * 1.2);
    
    RETURN COSTE_PROD * 1.2;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(-20200, 'El producto ya existe');
        
        RETURN -1;
END;

-- EJERCICIO 3

-- Realiza el ejercicio anterior dando un mensaje de
-- error en caso de que no existe. (Sin hacer el insert)

CREATE OR REPLACE FUNCTION PVP
(CODIGO_PROD IN VARCHAR2, DESCRIPCION_PROD IN VARCHAR2, COSTE_PROD NUMBER)
RETURN NUMBER
AS
NOT_UPDATED_PRODUCT EXCEPTION;
BEGIN
    UPDATE PRODUCTOS
    SET DESCRIPCION = DESCRIPCION_PROD,
        COSTE = COSTE_PROD,
        PVP = COSTE_PROD * 1.2
    WHERE CODIGO = CODIGO_PROD;
    IF SQL%NOTFOUND THEN
        RAISE NOT_UPDATED_PRODUCT;
    ELSE
        RETURN COSTE_PROD * 1.2;
    END IF;
EXCEPTION
    WHEN NOT_UPDATED_PRODUCT THEN
        RAISE_APPLICATION_ERROR(-20220, 'El producto no existe');
        
        RETURN -1;
END;

-- EJERCICIO 4

-- Provoca un error para que salte una excepción y
-- captúrala antes de salir de la función.

CREATE OR REPLACE FUNCTION PVP
(CODIGO_PROD IN VARCHAR2, DESCRIPCION_PROD IN VARCHAR2, COSTE_PROD NUMBER)
RETURN NUMBER
AS
MY_EXCEPTION EXCEPTION;
BEGIN
    INSERT INTO PRODUCTOS
    (CODIGO, DESCRIPCION, COSTE)
    VALUES
    (CODIGO_PROD, DESCRIPCION_PROD, COSTE_PROD * 1.2);
    
    IF 2 / 2 = 1 THEN
        ROLLBACK;
        RAISE MY_EXCEPTION;
    ELSE
        RETURN COSTE_PROD * 1.2;
    END IF;
EXCEPTION
    WHEN MY_EXCEPTION THEN
        RAISE_APPLICATION_ERROR(-20234, 'Excepción provocada por mí');
        
        RETURN -1;
END;

-- EJERCICIO 5

-- Anida todas las excepciones posibles de los
-- ejercicios anteriores en la misma función.

CREATE OR REPLACE FUNCTION PVP
(CODIGO_PROD IN VARCHAR2, DESCRIPCION_PROD IN VARCHAR2, COSTE_PROD NUMBER)
RETURN NUMBER
AS
NOT_UPDATED_PRODUCT EXCEPTION;
MY_EXCEPTION EXCEPTION;
BEGIN
    INSERT INTO PRODUCTOS
    (CODIGO, DESCRIPCION, COSTE)
    VALUES
    (CODIGO_PROD, DESCRIPCION_PROD, COSTE_PROD * 1.2);
    
    RETURN COSTE_PROD * 1.2;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        UPDATE PRODUCTOS
        SET DESCRIPCION = DESCRIPCION_PROD,
            COSTE = COSTE_PROD,
            PVP = COSTE_PROD * 1.2
        WHERE CODIGO = CODIGO_PROD;
        
        RETURN COSTE_PROD * 1.2;
    WHEN NOT_UPDATED_PRODUCT THEN
        RAISE_APPLICATION_ERROR(-20229, 'El producto no existe');
        
        RETURN -1;
    WHEN MY_EXCEPTION THEN
        RAISE_APPLICATION_ERROR(-20232, 'Excepción provocada por mí');
        
        RETURN -1;
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-2089, 'Error fatal');
        
        RETURN -1;
END;

-- EJERCICIO 6

-- Muestra el número de productos, de forma que
-- indique “No hay productos” en vez de “Hay 0
-- productos”.

DECLARE
    PRODUCTOS_GUARDADOS PRODUCTOS%ROWTYPE;
    NUMERO_PRODUCTOS NUMBER;
BEGIN
    SELECT * INTO PRODUCTOS_GUARDADOS
    FROM PRODUCTOS;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No hay productos');
    WHEN TOO_MANY_ROWS THEN
        SELECT COUNT(*) INTO NUMERO_PRODUCTOS
        FROM PRODUCTOS;
        
        DBMS_OUTPUT.PUT_LINE('Hay '||NUMERO_PRODUCTOS||' productos');
END;

-- EJERCICIO 7

-- Crea un bloque PL/SQL en el que insertas un
-- producto con código 3, ya existente. Haz el control de
-- excepciones de forma que un error de clave primaria
-- duplicada se ignore (no se inserta el producto pero el
-- bloque PL/SQL se ejecuta correctamente). Si
-- intentamos insertar un producto con precio negativo,
-- debe aparecer un error.

DECLARE
    NEGATIVE_PRICE EXCEPTION;
    PRICE NUMBER := -2;
BEGIN
    IF PRICE < 0 THEN
        RAISE NEGATIVE_PRICE;
    END IF;
      
    INSERT INTO PRODUCTOS
    (CODIGO, COSTE)
    VALUES
    ('3', PRECIO * 1.2);
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        NULL;
    WHEN NEGATIVE_PRICE THEN
        RAISE_APPLICATION_ERROR(-2081, 'No se puede insertar un precio negativo');
END;

-- EJERCICIO 8

-- Escribe un bloque PL/SQL donde usas un registro
-- para almacenar los datos de un producto. El bloque
-- insertará ese producto, pero si el precio no es positivo
-- generará una excepción de tipo precio_prod_invalido,
-- que deberás declarar previamente, en vez de realizar
-- la inserción.

DECLARE
    PRODUCTO PRODUCTOS%ROWTYPE;
    precio_prod_invalido EXCEPTION;
BEGIN
    PRODUCTO.CODIGO := '1234A';
    PRODUCTO.DESCRIPCION := 'Camiseta';
    PRODUCTO.COSTE := -4;
    
    IF PRODUCTO.COSTE <= 0 THEN
        RAISE precio_prod_invalido;
    END IF;
    
    INSERT INTO PRODUCTOS
    (CODIGO, DESCRIPCION, COSTE)
    VALUES
    (PRODUCTO.CODIGO, PRODUCTO.DESCRIPCION, PRODUCTO.COSTE);
EXCEPTION
    WHEN precio_prod_invalido THEN
        RAISE_APPLICATION_ERROR(-20198, 'El precio debe ser positivo');
END;

-- Modifica el ejercicio anterior, de forma que ahora
-- captures la excepción elevada y produces otra, con
-- SQLCODE y mensaje de error espífico, usando
-- RAISE_APPLICATION_ERROR

DECLARE
    PRODUCTO PRODUCTOS%ROWTYPE;
    precio_prod_invalido EXCEPTION;
BEGIN
    PRODUCTO.CODIGO := '1234A';
    PRODUCTO.DESCRIPCION := 'Camiseta';
    PRODUCTO.COSTE := -4;
    
    IF PRODUCTO.COSTE <= 0 THEN
        RAISE_APPLICATION_ERROR(-20198, 'El precio debe ser positivo');
    END IF;
    
    INSERT INTO PRODUCTOS
    (CODIGO, DESCRIPCION, COSTE)
    VALUES
    (PRODUCTO.CODIGO, PRODUCTO.DESCRIPCION, PRODUCTO.COSTE);
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -20198 THEN
            RAISE_APPLICATION_ERROR(SQLCODE, SQLERRM);
        END IF;
END;