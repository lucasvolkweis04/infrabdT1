--CONSULTAS SQL E SINTONIA DE DESEMPENHO (SQL TUNNING):
/*CONSULTA A: istar o nome completo (primeiro nome + último nome), a idade e a cidade
de todos os passageiros do sexo feminino (sex='w') com mais de 40 anos, residentes no
país 'BRAZIL'. [resposta sugerida = 141 linhas]; */

SELECT
p.FIRSTNAME || ' ' || p.LASTNAME AS full_name,
FLOOR(MONTHS_BETWEEN(SYSDATE, pd.BIRTHDATE) / 12) AS age,
pd.CITY
FROM
AIR_PASSENGERS p
JOIN
AIR_PASSENGERS_DETAILS pd ON p.PASSENGER_ID = pd.PASSENGER_ID
WHERE
pd.SEX = 'w'
AND pd.BIRTHDATE <= ADD_MONTHS(SYSDATE, -40 * 12)
AND pd.COUNTRY = 'BRAZIL';

/*Consulta B: Listar o nome da companhia aérea, o identificador da aeronave, o nome do
tipo de aeronave e o número de todos os voos operados por essa companhia aérea
(independentemente de a aeronave ser de sua propriedade) que saem E chegam em
aeroportos localizados no país 'BRAZIL'. [resposta sugerida = 8 linhas]*/

SELECT
al.AIRLINE_NAME,
ap.AIRPLANE_ID,
at.NAME AS airplane_type_name,
f.FLIGHTNO
FROM
AIR_FLIGHTS f
JOIN
AIR_AIRPLANES ap ON f.AIRPLANE_ID = ap.AIRPLANE_ID
JOIN
AIR_AIRLINES al ON ap.AIRLINE_ID = al.AIRLINE_ID
JOIN
AIR_AIRPLANE_TYPES at ON ap.AIRPLANE_TYPE_ID = at.AIRPLANE_TYPE_ID
JOIN
AIR_AIRPORTS_GEO dep_geo ON f.FROM_AIRPORT_ID = dep_geo.AIRPORT_ID
JOIN
AIR_AIRPORTS_GEO arr_geo ON f.TO_AIRPORT_ID = arr_geo.AIRPORT_ID
WHERE
dep_geo.COUNTRY = 'BRAZIL'
AND arr_geo.COUNTRY = 'BRAZIL';

/*Consulta C: Listar o número do voo, o nome do aeroporto de saída e o nome do
aeroporto de destino, o nome completo (primeiro e último nome) e o assento de cada
passageiro, para todos os voos que partem no dia do seu aniversário (do seu mesmo,
caro aluno, e não o do passageiro) neste ano (caso a consulta não retorna nenhuma
linha, faça para o dia subsequente até encontrar uma data que retorne alguma linha).
[resposta sugerida = 106 linhas para o dia 25/03/2024]
// Com a inserção do dia do meu aniversário, 21/03/2024, näo obtive nenhuma linha, então
utilizei o dia 22/03/2024; */

SELECT
f.FLIGHTNO,
dep_airport.NAME AS FROM_AIRPORT,
to_airport.NAME AS TO_AIRPORT,
p.FIRSTNAME || ' ' || p.LASTNAME AS PASSENGER_NAME,
b.SEAT
FROM
AIR_FLIGHTS f
JOIN
AIR_AIRPORTS dep_airport ON f.FROM_AIRPORT_ID = dep_airport.AIRPORT_ID
JOIN
AIR_AIRPORTS to_airport ON f.TO_AIRPORT_ID = to_airport.AIRPORT_ID
JOIN
AIR_BOOKINGS b ON f.FLIGHT_ID = b.FLIGHT_ID
JOIN
AIR_PASSENGERS p ON b.PASSENGER_ID = p.PASSENGER_ID
WHERE
TO_CHAR(f.DEPARTURE, 'DD/MM/YYYY') = '22/03/2024';

/*Consulta D: Listar o nome da companhia aérea bem como a data e a hora de saída de
todos os voos que chegam para a cidade de 'NEW YORK' que partem às terças,
quartas ou quintas-feiras, no mês do seu aniversário (caso a consulta não retorne
nenhuma linha, faça para o mês subsequente até encontrar um mês que retorne alguma
linha). [resposta sugerida = 1 linha para o mês de março de 2024]; */

SELECT
al.AIRLINE_NAME,
f.DEPARTURE
FROM
AIR_FLIGHTS f
JOIN
AIR_AIRPLANES ap ON f.AIRPLANE_ID = ap.AIRPLANE_ID
JOIN
AIR_AIRLINES al ON ap.AIRLINE_ID = al.AIRLINE_ID
JOIN
AIR_AIRPORTS to_airport ON f.TO_AIRPORT_ID = to_airport.AIRPORT_ID
JOIN
AIR_AIRPORTS_GEO geo ON to_airport.AIRPORT_ID = geo.AIRPORT_ID
WHERE
UPPER(geo.CITY) = 'NEW YORK'
AND EXTRACT(MONTH FROM f.DEPARTURE) = 1
AND EXTRACT(YEAR FROM f.DEPARTURE) = 2024
AND TO_CHAR(f.DEPARTURE, 'D') IN (3, 4, 5); -- Terça = 3, Quarta = 4, Quinta = 5

/*Consulta E: Crie uma consulta que seja resolvida adequadamente com um acesso
hash em um cluster com pelo menos duas tabelas. A consulta deve utilizar todas as
tabelas do cluster e pelo menos outra tabela fora dele.*/

CREATE CLUSTER CLUSTER_AIRPORTS_GEO (AIRPORT_ID NUMBER) HASHKEYS
100;
CREATE INDEX IDX_AIRPLANE_ID ON AIR_AIRPLANES(AIRPLANE_ID);
CREATE INDEX IDX_FLIGHT_ID ON AIR_FLIGHTS(FLIGHT_ID);
CREATE INDEX IDX_BOOKING_ID ON AIR_BOOKINGS(BOOKING_ID);
SELECT
a.NAME AS AIRPORT_NAME,
g.CITY,
f.FLIGHT_ID,
p.FIRSTNAME || ' ' || p.LASTNAME AS PASSENGER_NAME
FROM
AIR_AIRPORTS a
JOIN
AIR_AIRPORTS_GEO g ON a.AIRPORT_ID = g.AIRPORT_ID
JOIN
AIR_FLIGHTS f ON f.TO_AIRPORT_ID = a.AIRPORT_ID
JOIN
AIR_BOOKINGS b ON b.FLIGHT_ID = f.FLIGHT_ID
JOIN
AIR_PASSENGERS p ON p.PASSENGER_ID = b.PASSENGER_ID
WHERE
UPPER(g.CITY) = 'NEW YORK';




