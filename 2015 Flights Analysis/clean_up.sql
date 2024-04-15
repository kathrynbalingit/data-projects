/*
Quick Observations

- date of flights are separated into year, month, and day columns
- numerical values assigned for day of week
- times are represented as 4 character strings (scheduled_departure, departure_time, wheels_off, wheels_on, scheduled_arrival, arrival_time)
*/

select *
from flights
limit 5;

/*
Check if all airlines in flights table are present in airlines table.
*/

select count(distinct airline)
from flights;

select count(*)
from airlines;

select count(*)
from flights
left join airlines 
	on flights.airline = airlines.iata_code
where airlines.iata_code is null;

/* 
There are an unmatched number of airports between the flights table and the aiports table.

# of distinct origin_airport from flights table: 628
# of distinct destination_airport from flights table: 629

# of distinct iata_code from airports table: 322
*/

select count(distinct origin_airport)
from flights;

select count(distinct destination_airport)
from flights;

select count(distinct iata_code)
from airports;

/* List of origin_airports and destination_airports that do not exist in the airports table. */

select distinct origin_airport
from flights
where not exists (select * from airports where flights.origin_airport = airports.iata_code);

select distinct destination_airport
from flights
where not exists (select * from airports where flights.destination_airport = airports.iata_code);

/*
# of rows in flights table: 5,819,079

# of rows that do not have origin_airport in airports table: 486,165
# of rows that do not have destination_airport in airports table: 486,165

8.35% of flights table does not have available airport information
*/

select count(*)
from flights;

select count(*)
from flights
left join airports 
	on flights.origin_airport = airports.iata_code
where airports.iata_code is null;

select count(*)
from flights
left join airports 
	on flights.destination_airport = airports.iata_code
where airports.iata_code is null;

select count(*)
from flights
left join airports a
	on flights.origin_airport = a.iata_code
left join airports b
	on flights.destination_airport = b.iata_code
where a.iata_code is null and b.iata_code is null;

select count(*)/(select count(*) from flights)
from flights
left join airports  a
	on flights.origin_airport = a.iata_code
left join airports b
	on flights.destination_airport = b.iata_code
where a.iata_code is null and b.iata_code is null;

/*
Although the unknown airport information contains <10% of the data, how does it this impact the data if removed? Is there anything to note about the unknown data?

From the below query, we can see that all unknown airport data is associated with data in October. We should not remove the data to keep a more accurate month-to-month level of detail.
*/

select month, count(*)
from flights
where origin_airport like '1%'
group by month;

/*
OPTIONAL:
Create new flights table making the following changes:

- add column flight_date - combining year, month, and day columns in format YYYY-MM-DD
- add column day_of_week_name
- change times from 4-character string to a time value

NOTE:
Times were written using 24-hour time notation. However, midnight was represented by '2400' instead of '0000'. 
Str_to_date considers H from values 0-23, and does not consider '2400' as a valid time. I needed to replace '2400' to '0000' in order to change times into time values.
*/

select *
from flights
where arrival_time = '2400';

create table flights_updated as (
select f.year,
		f.month,
        f.day,
		str_to_date(concat_ws('',f.year, '-', f.month, '-', f.day), '%Y-%m-%d') as flight_date,
        f.day_of_week,
        case 
			when day_of_week = 1 then 'Monday'
            when day_of_week = 2 then 'Tuesday'
            when day_of_week = 3 then 'Wednesday'
            when day_of_week = 4 then 'Thursday'
            when day_of_week = 5 then 'Friday'
            when day_of_week = 6 then 'Saturday'
            else 'Sunday'
		end as day_of_week_name,
        f.airline,
        f.flight_number,
        f.tail_number,
        f.origin_airport,
        f.destination_airport,
        str_to_date(replace(f.scheduled_departure, '2400', '0000'), '%H%i') as scheduled_departure_time,
        str_to_date(replace(f.departure_time, '2400', '0000'), '%H%i') as actual_departure_time,
        f.departure_delay,
        f.taxi_out,
        str_to_date(replace(f.wheels_off, '2400', '0000'), '%H%i') as wheels_off_time,
        f.scheduled_time,
        f.elapsed_time,
        f.air_time,
        f.distance,
        str_to_date(replace(f.wheels_on, '2400', '0000'), '%H%i') as wheels_on_time,
        f.taxi_in,
        str_to_date(replace(f.scheduled_arrival, '2400', '0000'), '%H%i') as scheduled_arrival_time,
        str_to_date(replace(f.arrival_time, '2400', '0000'), '%H%i') as actual_arrival_time,
        f.arrival_delay,
        f.diverted,
        f.cancelled,
        f.cancellation_reason,
        f.air_system_delay,
        f.security_delay,
        f.airline_delay,
        f.late_aircraft_delay,
        f.weather_delay
from flights f
);