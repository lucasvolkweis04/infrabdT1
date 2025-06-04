/*Consulta A:
Utilizei índices para a otimização, e os seguintes foram utilizados.
Índice em AIR_PASSENGERS_DETAILS (pd.SEX, pd.COUNTRY, pd.BIRTHDATE):
Indice para otimizar a junção entre AIR_PASSENGERS e AIR_PASSENGERS_DETAILS.*/

CREATE INDEX idx_pd_details ON AIR_PASSENGERS_DETAILS (SEX, COUNTRY,
BIRTHDATE);
CREATE INDEX idx_passenger_id ON AIR_PASSENGERS_DETAILS
(PASSENGER_ID);


/*Consulta B:
Na consulta B, tentei inúmeras vezes otimizar o custo, com indexação e até mesmo um
cluster. Porém nenhuma delas obteve resultado satisfatório na baixa do custo. Então foi
pelo uso do hash join que a consulta foi otimizada, nested loops pesavam muito o custo e
com o hash isso não ocorreu mais.*/

SELECT /*+ USE_HASH(f ap al at dep_geo arr_geo) */
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
AIR_AIRPLANE_TYPES at ON ap.AIRPLANE_TYPE_ID =
at.AIRPLANE_TYPE_ID
JOIN
AIR_AIRPORTS_GEO dep_geo ON f.FROM_AIRPORT_ID =
dep_geo.AIRPORT_ID
JOIN
AIR_AIRPORTS_GEO arr_geo ON f.TO_AIRPORT_ID = arr_geo.AIRPORT_ID
WHERE
dep_geo.COUNTRY = 'BRAZIL'
AND arr_geo.COUNTRY = 'BRAZIL';

/*Consulta C:
Índice em AIR_FLIGHTS (DEPARTURE):
Um índice na coluna DEPARTURE, otimizando a filtragem dos voos por data.
Índice em AIR_BOOKINGS (FLIGHT_ID):
Índice para otimizar a junção de reservas com os voos.*/

CREATE INDEX idx_flight_departure ON AIR_FLIGHTS (DEPARTURE);
CREATE INDEX idx_booking_flight_id ON AIR_BOOKINGS (FLIGHT_ID);

/*Consulta D:
Índices utilizados para otimização;
IDX_AIRPORTS_CITY: Este índice é utilizado na operação de INDEX RANGE SCAN para a
tabela AIR_AIRPORTS_GEO, permitindo uma busca eficiente pela cidade "NEW YORK".
IDX_AIR_FLIGHTS_TO_AIRPORT: Esse índice é utilizado na operação de INDEX RANGE
SCAN para a tabela AIR_FLIGHTS, onde é utilizado para acessar os dados do aeroporto de
destino.
PK_AIR_AIRPLANES: Um índice único que é acessado na tabela AIR_AIRPLANES para
identificar um avião específico baseado no seu AIRPLANE_ID.
PK_AIR_AIRLINES: Um índice único que é acessado na tabela AIR_AIRLINES para
identificar uma companhia aérea específica baseada no seu AIRLINE_ID.
Plano de execução utilizado;
HASH JOIN entre AIR_FLIGHTS e AIR_AIRPLANES: Os dados de voos são combinados
com os dados dos aviões.
HASH JOIN entre AIR_AIRPLANES e AIR_AIRLINES: A tabela de aviões é combinada
com a tabela de companhias aéreas.
HASH JOIN entre os resultados do join acima e a tabela filtrada de aeroportos
(FilteredAirports): Os dados finais são combinados com as informações de aeroportos
filtrados pela cidade*/

WITH FilteredAirports AS (
SELECT AIRPORT_ID
FROM AIR_AIRPORTS_GEO
WHERE UPPER(CITY) = 'NEW YORK'
)
SELECT /*+ USE_HASH(f ap al geo) */
al.AIRLINE_NAME,
f.DEPARTURE
FROM
AIR_FLIGHTS f
JOIN
AIR_AIRPLANES ap ON f.AIRPLANE_ID = ap.AIRPLANE_ID
JOIN
AIR_AIRLINES al ON ap.AIRLINE_ID = al.AIRLINE_ID
JOIN
FilteredAirports geo ON f.TO_AIRPORT_ID = geo.AIRPORT_ID
WHERE
EXTRACT(MONTH FROM f.DEPARTURE) = 1
AND EXTRACT(YEAR FROM f.DEPARTURE) = 2024;
