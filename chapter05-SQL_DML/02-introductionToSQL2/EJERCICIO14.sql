-- Adrián Navarro Gabino

-- EJERCICIO 14

-- JUGADORES que sean mayores de edad y con teléfono que no sea NULO

SELECT NOMBRE
FROM JUGADOR
WHERE EDAD>=18 AND TELEFONO IS NOT NULL;