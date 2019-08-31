-- EJERCICIO 1
-- ¿Es correcta la siguiente sintaxis General de la sentencia IF-THEN ELSE?,
-- ¿Por qué?, ¿Cómo la escribirías?

-- El begin de dentro del if no está cerrado y endif se escribe separado.
BEGIN
    IF condicion1 THEN
        BEGIN
            secuencia_de_instrucciones1;
        END;
    ELSE
            secuencia_de_instrucciones2;
    END IF;
END;

-- EJERCICIO 2
-- ¿Qué resultado nos daría la siguiente comparación?

-- Resultado: TRUE

DECLARE
    identificador1 VARCHAR2(10):='Hola Pepe';
    identificador2 VARCHAR2(10):='Hola pepe';
BEGIN
    IF identificador1<>identificador2 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;

-- EJERCICIO 3
-- Indicar que errores existen en el siguiente código fuente:

-- 'TRUE' y 'FALSE' están escritos como cadenas en lugar de como booleanos.
-- El begin de dentro del bucle no tiene end.

DECLARE
    a NUMBER:=1;
    b NUMBER:=6;
    salida_bucle BOOLEAN;
BEGIN
    salida_bucle:=FALSE;
    WHILE NOT salida_bucle
    LOOP
        BEGIN
            IF a>=b THEN
                salida_bucle:=TRUE;
            ELSE
                a:=(a+1);
            END IF;
        END;
    END LOOP;
END;

-- EJERCICIO 4
-- ¿Qué valor contendrá la variable 'sumador' al salir del bucle?, ¿por qué?

-- sumador será NULL porque no está inicializado en la declaración
DECLARE
    sumador NUMBER;
BEGIN
    FOR i IN 1..100 LOOP
        sumador:=sumador+i;
    END LOOP;
END;

-- EJERCICIO 5
-- ¿Qué resultado dará la ejecución del siguiente código?

-- Resultado: valor -> NULL

DECLARE
    temp NUMBER(1,0);
    SUBTYPE numero IS temp%TYPE;
    valor numero;
BEGIN
    WHILE valor<20 LOOP
        valor:=valor+1;
    END LOOP;
END;

-- EJERCICIO 6
-- ¿Funcionaría el siguiente trozo de código?, ¿por qué?, ¿cómo arreglarlo?

-- mi_valor=NULL es incorrecto, es mi_valor IS NULL
-- EXIT WHEN cierto; sobra

DECLARE
    mi_valor NUMBER;
    cierto BOOLEAN:=FALSE;
BEGIN
    WHILE NOT cierto
    LOOP
        IF mi_valor IS NULL THEN
            mi_valor:=1;
        ELSE
            mi_valor:=mi_valor+1;
        END IF;
        IF mi_valor>100 THEN cierto:=TRUE; END IF;
    END LOOP;
END;

-- EJERCICIO 7
-- Escribir la sintaxis General de un código que evalúe si se cumple una
-- condición, en caso de cumplirse que ejecute una serie de sentencias,
-- en caso contrario que evalúe otra, que de cumplirse ejecute otras
-- instrucciones, si ésta no se cumple que evalúe una tercera condición.. y
-- así N veces. En caso de existir varias soluciones, comentarlas y escribir la
-- más óptima o clara.

DECLARE
    X NUMBER:=1;
BEGIN
    FOR I IN 1..20 LOOP
        IF MOD(X,2) = 0 THEN
            DBMS_OUTPUT.PUT_LINE(X||' ES PAR');
        ELSE
            DBMS_OUTPUT.PUT_LINE(X||' ES IMPAR');
        END IF;
        X:=X * I + 1;
    END LOOP;
END;

-- EJERCICIO 8
-- Implementar en PL/SQL un bucle infinito que vaya sumando valores en una
-- variable de tipo NUMBER.

DECLARE
    A NUMBER:=10;
BEGIN
    LOOP
        X:= X * 3;
        DBMS_OUTPUT.PUT_LINE(X);
    END LOOP;
END;

-- EJERCICIO 9
-- En base al bucle anterior, añadirle la condición de que salga cuando
-- la variable sea mayor que 10.000, usa el bucle WHILE.

DECLARE
    X NUMBER:=10;
BEGIN
    WHILE X <= 10000 LOOP
        X:= X * 3;
        DBMS_OUTPUT.PUT_LINE(X);
    END LOOP;
END;

-- EJERCICIO 10
-- Implementar un bucle en PL/SQL en el cual vayamos sumando
-- valores a una variable mientras ésta sea menor que 10, asegurándonos
-- de que el bucle se ejecuta por lo menos una vez.

DECLARE
    X NUMBER:=1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(X);
        X:= X + 2;
        EXIT WHEN X > 10;
    END LOOP;
END;

-- EJERCICIO 11
-- Implementar en PL/SQL, el código necesario de un programa que
-- al final de su ejecución haya almacenado en una variable llamada 'cadena',
-- el siguiente valor:
-- cadena:='10*9*8*7*6*5*4*3*2*1'

DECLARE
    CADENA VARCHAR2(50);
BEGIN
    FOR I IN REVERSE 1..10 LOOP
        CADENA := CADENA || I;
        IF I <> 1 THEN
            CADENA := CADENA || '*';
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(CADENA);
END;

