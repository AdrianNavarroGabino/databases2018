-- Adri�n Navarro Gabino

-- EJERCICIO 13

-- JUGADORES que hayan metido goles en partidos que el equipo local no sea
-- ni ESPA�A ni ARGENTINA ni BRASIL.

SELECT JUGADOR_GOL
FROM GOL
WHERE EQUIPO_L_GOL!='ESPA�A'
    AND EQUIPO_L_GOL!='ARGENTINA'
    AND EQUIPO_L_GOL!='BRASIL';