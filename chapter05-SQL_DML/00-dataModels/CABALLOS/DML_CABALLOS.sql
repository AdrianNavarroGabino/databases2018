-- Caballos

INSERT INTO caballos (codcaballo, nombre, peso, fechanacimiento, propietario, nacionalidad)
VALUES('1','Ariza',245,'03/06/2004','Sir Archibald Bradley','Brit�nica');
INSERT INTO caballos (codcaballo, nombre, peso, fechanacimiento, propietario, nacionalidad)
VALUES('2','Duncan De Ran',267,'02/07/2006','Lali Montijo','Espa�ola');
INSERT INTO caballos (codcaballo, nombre, peso, fechanacimiento, propietario, nacionalidad)
VALUES('3','Giraldilla',241,'03/10/2005','Ali Rahid','�rabe');
INSERT INTO caballos (codcaballo, nombre, peso, fechanacimiento, propietario, nacionalidad)
VALUES('4','Danirrah',287,'12/11/2004','John Smith','Brit�nica');
INSERT INTO caballos (codcaballo, nombre, peso, fechanacimiento, propietario, nacionalidad)
VALUES('5','Persicus',275,'03/10/2004','Ali Rahid','Espa�ola');
INSERT INTO caballos (codcaballo, nombre, peso, fechanacimiento, propietario, nacionalidad)
VALUES('6','Mia''s Choice',250,'07/07/2005','Miriam Belluci', 'Brit�nica');
INSERT INTO caballos (codcaballo, nombre, peso, fechanacimiento, propietario, nacionalidad)
VALUES('7','Comanche Trail',296,'22/11/2005','John Smith', 'Brit�nica');
INSERT INTO caballos (codcaballo, nombre, peso, fechanacimiento, propietario, nacionalidad)
VALUES('8','Chulapo',260,'10/07/2006','Lali Montijo','Espa�ola');
INSERT INTO caballos (codcaballo, nombre, peso, fechanacimiento, propietario, nacionalidad)
VALUES('9','Bucefalo',260,'10/01/2001','Alejandro Magno','Macedonia');


-- Carreras

ALTER SESSION SET NLS_DATE_FORMAT='DD/MM/YYYY HH24:MI';

INSERT INTO carreras(codcarrera, fechahora, importepremio, apuestalimite)
VALUES('C1', '12/07/2009 09:30',50000, 2000);
INSERT INTO carreras(codcarrera, fechahora, importepremio, apuestalimite)
VALUES('C2', '12/07/2009 10:30', 12000, 1300);
INSERT INTO carreras(codcarrera, fechahora, importepremio, apuestalimite)
VALUES('C3', '12/07/2009 11:30', 4000, 500 );
INSERT INTO carreras(codcarrera, fechahora, importepremio, apuestalimite)
VALUES('C4', '19/07/2009 09:30', 24000, 900);
INSERT INTO carreras(codcarrera, fechahora, importepremio, apuestalimite)
VALUES('C5', '19/07/2009 10:30', 3000, 350);
INSERT INTO carreras(codcarrera, fechahora, importepremio, apuestalimite)
VALUES('C6', '21/10/2009 11:00', 5000, 400);
INSERT INTO carreras(codcarrera, fechahora, importepremio, apuestalimite)
VALUES('C7', '21/10/2008 12:00', 25000, 2400);


-- Clientes

INSERT INTO clientes (dnicliente, nombre, nacionalidad)
VALUES ('111A', 'Ronald McDonald', 'Estadounidense');
INSERT INTO clientes (dnicliente, nombre, nacionalidad)
VALUES ('222B', 'Douglas O''Connors', 'Escocesa');
INSERT INTO clientes (dnicliente, nombre, nacionalidad)
VALUES ('333C', 'Juanita de Alba', 'Espa�ola');
INSERT INTO clientes (dnicliente, nombre, nacionalidad)
VALUES ('444D', 'Sid Vicious', 'Estadounidense');
INSERT INTO clientes (dnicliente, nombre, nacionalidad)
VALUES ('555E', 'Rob Halford', 'Brit�nica');
INSERT INTO clientes (dnicliente, nombre, nacionalidad)
VALUES ('666F', 'Dioni P�rez', 'Espa�ola');
INSERT INTO clientes (dnicliente, nombre, nacionalidad)
VALUES ('777G', 'Hamed Karim Aizam', '�rabe');
INSERT INTO clientes (dnicliente, nombre, nacionalidad)
VALUES ('888H', 'John H. Bonham', 'Brit�nica');
INSERT INTO clientes (dnicliente, nombre, nacionalidad)
VALUES ('999I', 'Manuel S�nchez', 'Espa�ola');


-- Apuestas

INSERT INTO apuestas (dnicliente, codcaballo, codcarrera, importe, tantoporuno)
VALUES('111A','1','C1',400,25);
INSERT INTO apuestas (dnicliente, codcaballo, codcarrera, importe, tantoporuno)
VALUES('111A','2','C1',300,4);
INSERT INTO apuestas (dnicliente, codcaballo, codcarrera, importe, tantoporuno)
VALUES('222B','3','C1',500,5.5 );
INSERT INTO apuestas (dnicliente, codcaballo, codcarrera, importe, tantoporuno)
VALUES('333C','4','C2',1200,6 );
INSERT INTO apuestas (dnicliente, codcaballo, codcarrera, importe, tantoporuno)
VALUES('333C','5','C2',1800,10);
INSERT INTO apuestas (dnicliente, codcaballo, codcarrera, importe, tantoporuno)
VALUES('444D','6','C2',3000,2);
INSERT INTO apuestas (dnicliente, codcaballo, codcarrera, importe, tantoporuno)
VALUES('444D','7','C3',350,10);
INSERT INTO apuestas (dnicliente, codcaballo, codcarrera, importe, tantoporuno)
VALUES('555E','8','C3',400,6 );
INSERT INTO apuestas (dnicliente, codcaballo, codcarrera, importe, tantoporuno)
VALUES('777G','9','C3',300,1.8 );
INSERT INTO apuestas (dnicliente, codcaballo, codcarrera, importe, tantoporuno)
VALUES('111A','1','C4',400,3 );
INSERT INTO apuestas (dnicliente, codcaballo, codcarrera, importe, tantoporuno)
VALUES('888H','3','C4',600,2.5 );
INSERT INTO apuestas (dnicliente, codcaballo, codcarrera, importe, tantoporuno)
VALUES('999I','5','C4',800,5 );
INSERT INTO apuestas (dnicliente, codcaballo, codcarrera, importe, tantoporuno)
VALUES('222B','2','C5',300,5 );
INSERT INTO apuestas (dnicliente, codcaballo, codcarrera, importe, tantoporuno)
VALUES('333C','2','C5',310,5 );
INSERT INTO apuestas (dnicliente, codcaballo, codcarrera, importe, tantoporuno)
VALUES('555E','4','C5',325,3 );

-- Participaciones

INSERT INTO participaciones(codcaballo, codcarrera,dorsal, jockey, posicionfinal)
VALUES('1','C1',3,'Claudio Carudel', 1);
INSERT INTO participaciones(codcaballo, codcarrera,dorsal, jockey, posicionfinal)
VALUES('2','C1',1,'Charlie Rivel', 3);
INSERT INTO participaciones(codcaballo, codcarrera,dorsal, jockey, posicionfinal)
VALUES('3','C1',2,'Jes�s Navas', 2);
INSERT INTO participaciones(codcaballo, codcarrera,dorsal, jockey, posicionfinal)
VALUES('4','C2',2,'Claudio Carudel', 1);
INSERT INTO participaciones(codcaballo, codcarrera,dorsal, jockey, posicionfinal)
VALUES('5','C2',3,'Sara Montiel', 3);
INSERT INTO participaciones(codcaballo, codcarrera,dorsal, jockey, posicionfinal)
VALUES('6','C2',2,'Lucas Grijander', 2);
INSERT INTO participaciones(codcaballo, codcarrera,dorsal, jockey, posicionfinal)
VALUES('7','C3',8,'Claudio Carudel', 2);
INSERT INTO participaciones(codcaballo, codcarrera,dorsal, jockey, posicionfinal)
VALUES('8','C3',5,'Luis Parrales', 1);
INSERT INTO participaciones(codcaballo, codcarrera,dorsal, jockey, posicionfinal)
VALUES('9','C3',12,'Matthew Tuck', 3);
INSERT INTO participaciones(codcaballo, codcarrera,dorsal, jockey, posicionfinal)
VALUES('1','C4',1,'Luis Parrales', 2);
INSERT INTO participaciones(codcaballo, codcarrera,dorsal, jockey, posicionfinal)
VALUES('3','C4',6,'Janis Joplin', 3);
INSERT INTO participaciones(codcaballo, codcarrera,dorsal, jockey, posicionfinal)
VALUES('5','C4',4,'Claudio Carudel', 1);
INSERT INTO participaciones(codcaballo, codcarrera,dorsal, jockey, posicionfinal)
VALUES('7','C4',2,'Josue Monge', 4);
INSERT INTO participaciones(codcaballo, codcarrera,dorsal, jockey, posicionfinal)
VALUES('2','C5',3,'Jes�s Lucas', 1);
INSERT INTO participaciones(codcaballo, codcarrera,dorsal, jockey, posicionfinal)
VALUES('6','C5',6,'Monica Naranjo', 3);
INSERT INTO participaciones(codcaballo, codcarrera,dorsal, jockey, posicionfinal)
VALUES('8','C5',2,'Marilyn Manson', 4);
INSERT INTO participaciones(codcaballo, codcarrera,dorsal, jockey, posicionfinal)
VALUES('5','C5',1,'Karl Heinz', 2);