-- Adri�n Navarro Gabino

-- EJERCICIO 15

-- Listado de todos los jugadores que hayan marcado goles ordenando por el
-- equipo local alfab�ticamente y por el vistante al contrario del orden
-- alfab�tico.

SELECT JUGADOR_GOL
FROM GOL
ORDER BY EQUIPO_L_GOL,EQUIPO_V_GOL;