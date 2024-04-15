show global variables like 'local_infile';

show variables like 'secure_file_priv';

set global local_infile = true;

/*
Flights Table Details

YEAR = year of flight trip
MONTH = month of flight trip
DAY = day of flight trip
DAY_OF_WEEK = day of week of flight trip (1 = Monday, 2 = Tuesday,...)
AIRLINE = name of airline
FLIGHT_NUMBER = assigned flight identifier
TAIL_NUMBER = aircraft identifier
ORIGIN_AIRPORT = starting airport
DESTINATION_AIRPORT = ending airport
SCHEDULED_DEPARTURE = planned departure time
DEPARTURE_TIME = time plane leaves airport gate (WHEELS_OFF - TAXI_OUT)
DEPARTURE_DELAY = total delay on departure in mins
TAXI_OUT = time duration elapsed between departure from gate and take off time in mins
WHEELS_OFF = take off time
SCHEDULED_TIME = planned time amount needed for flight trip in mins
ELAPSED_TIME = actual time amount for flight trip in mins (AIR_TIME + TAXI_IN + TAXI_OUT)
AIR_TIME = total time in air in mins (WHEELS_ON - WHEELS_OFF)
DISTANCE = distance between airports
WHEELS_ON = time aircraft lands on the ground
TAXI_IN = time duration elapsed between aircraft landing and arrival to destination gate
SCHEDULED_ARRIVAL = planned arrival time
ARRIVAL_TIME = time plane arrives to destination gate (WHEELS_ON + TAXI_IN)
ARRIVAL_DELAY = total delay on arrival in mins (ARRIVAL_TIME - SCHEDULED_ARRIVAL)
DIVERTED = 1 if aircraft landed out of schedule, 0 if not
CANCELLED = 1 if flight cancelled, 0 if not
CANCELLATION_REASON = reason for cancellation
AIR_SYSTEM_DELAY = delay caused by air system in mins
SECURITY_DELAY = delay caused by security in mins
AIRLINE_DELAY = delay caused by airline in mins
LATE_AIRCRAFT_DELAY = delay caused by aircraft in mins
WEATHER_DELAY = delay caused by weather in mins
*/

create table airlines.flights
	(YEAR int,
    MONTH int,
    DAY int,
    DAY_OF_WEEK int,
    AIRLINE text,
    FLIGHT_NUMBER text,
    TAIL_NUMBER text,
    ORIGIN_AIRPORT text,
    DESTINATION_AIRPORT text,
    SCHEDULED_DEPARTURE text,
    DEPARTURE_TIME text,
    DEPARTURE_DELAY int, 
    TAXI_OUT int,
    WHEELS_OFF text,
    SCHEDULED_TIME int,
    ELAPSED_TIME int,
    AIR_TIME int,
    DISTANCE int,
    WHEELS_ON text,
    TAXI_IN int,
    SCHEDULED_ARRIVAL text,
    ARRIVAL_TIME text,
    ARRIVAL_DELAY int,
    DIVERTED boolean,
    CANCELLED boolean,
    CANCELLATION_REASON text,
    AIR_SYSTEM_DELAY int, 
    SECURITY_DELAY int,
    AIRLINE_DELAY int,
    LATE_AIRCRAFT_DELAY int,
    WEATHER_DELAY int
    );

load data local infile '/Users/katmaebal/Desktop/Airlines+Airports+Cancellation+Codes+_+Flights/flights.csv'
into table flights
fields terminated by ','
enclosed by '"'
ignore 1 lines;

/*
Airports Table Details

IATA_CODE = airline codes
AIRPORT = name of airport
CITY = city location of airport
STATE = state abbreviation location of airport
COUNTRY = country abbreviation location of airport
LATITUDE = latitude location of airport
LONGITUDE = longitude location of airport
*/

create table airlines.airports (
	IATA_CODE text,
	AIRPORT text,
	CITY text,
	STATE text,
	COUNTRY text,
	LATITUDE decimal,
	LONGITUDE decimal
    );

load data local infile '/Users/katmaebal/Desktop/Airlines+Airports+Cancellation+Codes+_+Flights/airports.csv'
into table airports
fields terminated by ','
enclosed by '"'
ignore 1 lines;

/*
Airlines Table Details

IATA_CODE = airline codes
AIRLINE = name of airline 
*/

create table airlines.airlines (
	IATA_CODE text,
	AIRLINE text
    );

load data local infile '/Users/katmaebal/Desktop/Airlines+Airports+Cancellation+Codes+_+Flights/airplines.csv'
into table airports
fields terminated by ','
enclosed by '"'
ignore 1 lines;

/*
Cancellation_Codes Table Details

CANCELLATION_REASON = cancellation code reference letter
CANCELLATION_DESCRIPTION = reason for cancellation
*/

create table airlines.cancellation_codes (
	CANCELLATION_REASON text,
    CANCELLATION_DESCRIPTION text
    );

load data local infile '/Users/katmaebal/Desktop/Airlines+Airports+Cancellation+Codes+_+Flights/cancellation_codes.csv'
into table airports
fields terminated by ','
enclosed by '"'
ignore 1 lines;




