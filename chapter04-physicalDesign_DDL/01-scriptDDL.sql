-- ALUMNOS: DNI, NOMBRE Y EDAD
-- ASIGNATURAS: CODIGO, NOMBRE
-- MATRICULAR: FECHA
-- EXAMENES: CODIGO, FECHA, NUMERO_PREGUNTAS
-- EXAMINAR: NOTAS

-- EJERCICIO 1. Una relación llamada MATRICULAR con tipo
-- de correspondencia 1:1 y  cardinalidades (0,1) (0,1)
-- entre ALUMNOS y ASIGNATURA

CREATE TABLE ALUMNOS
(
    DNI VARCHAR2(10) NOT NULL,
    NOMBRE VARCHAR2(60),
    EDAD NUMBER,
    CONSTRAINT PK_ALUMNOS PRIMARY KEY (DNI)
);

CREATE TABLE ASIGNATURAS
(
    CODIGO VARCHAR2(2) NOT NULL,
    NOMBRE VARCHAR2(60),
    CONSTRAINT PK_ASIGNATURAS PRIMARY KEY (CODIGO)
);

CREATE TABLE MATRICULAR
(
    DNI_ALU VARCHAR2(10) NOT NULL,
    COD_ASIG VARCHAR2(2) NOT NULL,
    FECHA DATE,
    CONSTRAINT PK_MATRICULAR PRIMARY KEY (DNI_ALU),
    CONSTRAINT UK_CODASIG UNIQUE (COD_ASIG),
    CONSTRAINT FK_MATRICULAR_ALUMNOS FOREIGN KEY (DNI_ALU)
    REFERENCES ALUMNOS (DNI),
    CONSTRAINT FK_MATRICULAR_ASIGNATURAS FOREIGN KEY (COD_ASIG)
    REFERENCES ASIGNATURAS (CODIGO)
);

-- EJERCICIO 2. Una relación llamada MATRICULAR con tipo de
-- correspondencia 1:1 y  cardinalidades (1,1) (1,1)  entre 
-- ALUMNOS y ASIGNATURA

DROP TABLE MATRICULAR;

ALTER TABLE ASIGNATURAS ADD
(
    DNI_ALU VARCHAR2(10) NOT NULL,
    FECHA DATE
);

ALTER TABLE ASIGNATURAS ADD CONSTRAINT UK_ALUMNOS_DNI 
UNIQUE (DNI_ALU);

ALTER TABLE ASIGNATURAS ADD CONSTRAINT FK_ASIGNATURAS_ALUMNOS
FOREIGN KEY (DNI_ALU) REFERENCES ALUMNOS (DNI);

-- EJERCICIO 3. Una relación llamada MATRICULAR con tipo de
-- correspondencia 1:M y  cardinalidades (0,1) en el lado
-- del 1 entre ALUMNOS y ASIGNATURA (1 Alumno Muchas asignaturas,
-- 1 asignatura 1 alumno)

ALTER TABLE ASIGNATURAS MODIFY DNI_ALU NULL;

ALTER TABLE ASIGNATURAS DROP CONSTRAINT UK_ALUMNOS_DNI;

-- EJERCICIO 4. Una relación llamada MATRICULAR con tipo
-- de correspondencia 1:M y  cardinalidades (1,1) entre 
-- ALUMNOS y ASIGNATURA (1 Alumno Muchas asignaturas,
-- 1 asignatura 1 alumno)

ALTER TABLE ASIGNATURAS MODIFY DNI_ALU NOT NULL;

-- EJERCICIO 5. Una relación llamada MATRICULAR con tipo de
-- correspondencia 1:M y  entre ALUMNOS y ASIGNATURA con
-- DEBILIDAD de IDENTIDAD de ASIGNATURAS sobre ALUMNOS
-- (1 Alumno Muchas asignaturas, 1 asignatura 1 alumno)

ALTER TABLE ASIGNATURAS DROP CONSTRAINT PK_ASIGNATURAS;

ALTER TABLE ASIGNATURAS ADD CONSTRAINT PK_ASIGNATURAS
PRIMARY KEY (CODIGO, DNI_ALU);

-- EJERCICIO 6. Una relación llamada MATRICULAR con tipo
-- de correspondencia M:M entre ALUMNOS y ASIGNATURA

ALTER TABLE ASIGNATURAS DROP CONSTRAINT PK_ASIGNATURAS;

ALTER TABLE ASIGNATURAS ADD CONSTRAINT PK_ASIGNATURAS PRIMARY KEY (CODIGO);

ALTER TABLE ASIGNATURAS DROP COLUMN DNI_ALU;

ALTER TABLE ASIGNATURAS DROP COLUMN FECHA;

CREATE TABLE MATRICULAR
(
    DNI_ALU VARCHAR2(10) NOT NULL,
    COD_ASI VARCHAR2(2) NOT NULL,
    FECHA DATE,
    CONSTRAINT PK_MATRICULAR PRIMARY KEY (DNI_ALU, COD_ASI),
    CONSTRAINT FK_MATRICULAR_ALUMNOS FOREIGN KEY (DNI_ALU)
    REFERENCES ALUMNOS (DNI),
    CONSTRAINT FK_MATRICULAR_ASIGNATURAS FOREIGN KEY (COD_ASI)
    REFERENCES ASIGNATURAS (CODIGO)
);

-- EJERCICIO 7. Una relación ternaria M:M:M entre ALUMNOS,
-- ASIGNATURAS y EXAMENES

CREATE TABLE EXAMENES
(
    CODIGO VARCHAR2(2) NOT NULL,
    FECHA DATE,
    NUMERO_PREGUNTAS VARCHAR2(3),
    CONSTRAINT PK_EXAMENES PRIMARY KEY (CODIGO)
);

CREATE TABLE EXAMINAR
(
    DNI_ALU VARCHAR2(10) NOT NULL,
    COD_ASI VARCHAR2(2) NOT NULL,
    COD_EX VARCHAR2(2) NOT NULL,
    NOTAS VARCHAR2(2),
    CONSTRAINT PK_EXAMINAR PRIMARY KEY (DNI_ALU, COD_ASI, COD_EX),
    CONSTRAINT FK_EXAMINAR_ALUMNOS FOREIGN KEY (DNI_ALU)
    REFERENCES ALUMNOS (DNI),
    CONSTRAINT FK_EXAMINAR_ASIGNATURAS FOREIGN KEY (COD_ASI)
    REFERENCES ASIGNATURAS (CODIGO),
    CONSTRAINT FK_EXAMINAR_EXAMENES FOREIGN KEY (COD_EX)
    REFERENCES EXAMENES (CODIGO)
);

-- EJERCICIO 8. Una relación ternaria M:M:1 entre ALUMNOS, ASIGNATURAS
-- y EXAMENES, el lado del 1 a EXAMENES

ALTER TABLE EXAMINAR DROP CONSTRAINT PK_EXAMINAR;

ALTER TABLE EXAMINAR ADD CONSTRAINT PK_EXAMINAR PRIMARY KEY (DNI_ALU, COD_ASI);

-- EJERCICIO 9. Una relación ternaria M:1:1 entre ALUMNOS, ASIGNATURAS y
-- EXAMENES, el lado del M a ALUMNOS

ALTER TABLE EXAMINAR MODIFY COD_EX NULL;

ALTER TABLE EXAMINAR ADD CONSTRAINT UK_DNIALU_CODEX UNIQUE (DNI_ALU, COD_EX);

-- EJERCICIO 10. Una agregación a una relación MATRICULAR M:M entre ALUMNOS
-- y ASIGNATURAS, y esta agregación se une a EXAMENES con otra relación
-- M:M llamada EXAMINAR.

ALTER TABLE EXAMINAR DROP CONSTRAINT PK_EXAMINAR;

ALTER TABLE EXAMINAR DROP CONSTRAINT UK_DNIALU_CODEX;

ALTER TABLE EXAMINAR DROP CONSTRAINT FK_EXAMINAR_ALUMNOS;

ALTER TABLE EXAMINAR DROP CONSTRAINT FK_EXAMINAR_ASIGNATURAS;

ALTER TABLE EXAMINAR ADD CONSTRAINT PK_EXAMINAR
PRIMARY KEY (DNI_ALU, COD_ASI, COD_EX);

ALTER TABLE EXAMINAR ADD CONSTRAINT FK_EXAMINAR_MATRICULAR
FOREIGN KEY (DNI_ALU, COD_ASI) REFERENCES MATRICULAR (DNI_ALU, COD_ASI);

