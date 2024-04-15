select * from flights_updated limit 5; 

/*
View of flights_updated table (f) joined with:

- airlines (al) on f.airline = al.iata_code
- airports (ap1) on f.origin_airport = ap1.iata_code
- airports (ap2) on f.destination_airport = ap2.iata_code
- cancellation_codes (cc) on f.cancellation_reason = cc.cancellation_reason
*/

select f.year,
		f.month,
		f.day,
		f.flight_date,
		f.day_of_week,
        f.day_of_week_name,
        f.airline,
        al.airline as airline_name,
        f.flight_number,
        f.tail_number,
        f.origin_airport,
        ap1.airport as origin_airport_name,
        f.destination_airport,
        ap2.airport as destination_airport_name,
        f.scheduled_departure_time,
        f.actual_departure_time,
        f.departure_delay,
        f.taxi_out,
        f.wheels_off_time,
        f.scheduled_time,
        f.elapsed_time,
        f.air_time,
        f.distance,
        f.wheels_on_time,
        f.taxi_in,
        f.scheduled_arrival_time,
        f.actual_arrival_time,
        f.arrival_delay,
        f.diverted,
        f.cancelled,
        f.cancellation_reason,
        cc.cancellation_description,
        f.air_system_delay,
        f.security_delay,
        f.airline_delay,
        f.late_aircraft_delay,
        f.weather_delay
from flights_updated f
left join airlines al
	on f.airline = al.iata_code
left join airports ap1
	on f.origin_airport = ap1.iata_code
left join airports ap2
	on f.destination_airport = ap2.iata_code
left join cancellation_codes cc
	on f.cancellation_reason = cc.cancellation_reason
limit 5;

/* 
How does the overall flight volume vary by month?

July had the most number of flights, followed by August, March, and June, in that order. 
June, July, and August are summer months, so we can expect many people to vacation during this time, whereas March tends to be when most students have spring break.

By day of week?

The days with the most flights are Thursday, Monday, and Friday. All of these days occur around the weekend, which is when we may expect most people to either start or end their vacation.
With the same logic, we can understand Saturday as being a low travel day, as many people are in the middle of their vacations on this day.
*/
select case 
			when month = 1 then 'January'
            when month = 2 then 'February'
            when month = 3 then 'March'
            when month = 4 then 'April'
            when month = 5 then 'May'
            when month = 6 then 'June'
            when month = 7 then 'July'
            when month = 8 then 'August'
            when month = 9 then 'September'
            when month = 10 then 'October'
            when month = 11 then 'November'
            else 'December'
		end as month_name, 
		count(*) as total_flights 
from flights_updated
group by month
order by month asc;

select case 
			when day_of_week = 1 then 'Monday'
            when day_of_week = 2 then 'Tuesday'
            when day_of_week = 3 then 'Wednesday'
            when day_of_week = 4 then 'Thursday'
            when day_of_week = 5 then 'Friday'
            when day_of_week = 6 then 'Saturday'
            else 'Sunday'
		end as day_of_week_name, 
		count(*) as total_flights 
from flights_updated
group by day_of_week
order by day_of_week asc;

/* 
What percentage of flights experienced a departure delay in 2015? 

Total # of flights = 5,819,079
Total # of flights with departure_delay > 0 = 2,125,618

% of flights experiencing a departure delay = 36.53%

Among those flights, what was the average delay time, in minutes?

Average departure_delay time = 32.67 mins
*/

select count(*) 
from flights_updated;

select count(*)
from flights_updated
where departure_delay > 0;

select count(*) / (select count(*) from flights) as departure_delay_percentage
from flights_updated
where departure_delay > 0;

select avg(departure_delay) 
from flights_updated
where departure_delay > 0;

/* 
How does the % of delayed flights vary throughout the year? What about for flights leaving from Los Angeles (LAX) specifically?

The summer months experienced the highest proportion of delayed flights, with June being the highest overall.
The same is also true for LAX, as well as December having the 3rd highest proportion for the airport.
*/

select case 
			when month = 1 then 'January'
            when month = 2 then 'February'
            when month = 3 then 'March'
            when month = 4 then 'April'
            when month = 5 then 'May'
            when month = 6 then 'June'
            when month = 7 then 'July'
            when month = 8 then 'August'
            when month = 9 then 'September'
            when month = 10 then 'October'
            when month = 11 then 'November'
            else 'December'
		end as month_name,
		count(*) as total_flights,
        sum(if(departure_delay > 0, 1, 0)) as late_departure_count,
        (sum(if(departure_delay > 0, 1, 0)) / count(*)) as late_departure_percentage
from flights_updated
group by month;

select month,
		count(*) as delayed_count
from flights_updated
where departure_delay > 0 and origin_airport = 'LAX'
group by month;

select case 
			when month = 1 then 'January'
            when month = 2 then 'February'
            when month = 3 then 'March'
            when month = 4 then 'April'
            when month = 5 then 'May'
            when month = 6 then 'June'
            when month = 7 then 'July'
            when month = 8 then 'August'
            when month = 9 then 'September'
            when month = 10 then 'October'
            when month = 11 then 'November'
            else 'December'
		end as month_name,
		count(*) as total_flights,
        sum(if(departure_delay > 0, 1, 0)) as late_departure_count,
        (sum(if(departure_delay > 0, 1, 0)) / count(*)) as late_departure_percentage
from flights_updated
where origin_airport = 'LAX'
group by month;

/* 
How many flights were cancelled in 2015? What % of cancellations were due to weather? What % were due to the Airline/Carrier?

Total # of cancelled flights = 89,884

Total # of cancelled flights were by weather = 48,851
% of flights cancelled by weather = 54.35%

Total # of cancelled flights were by airline/carrier = 25,262
% of flights cancelled by airline/carrier = 28.11%
*/

select count(*) as total_cancelled
from flights_updated
where cancelled = 1;

select cc.cancellation_description,
		count(*) as cancellation_count,
        (count(*) / (select count(*) from flights where cancelled = 1)) as cancellation_percentage
from flights f
left join cancellation_codes cc
	on f.cancellation_reason = cc.cancellation_reason
where cancelled = 1
group by cc.cancellation_description;

/* 
Which airlines seem to be most and least reliable, in terms of on-time departure? 

When comparing the average departure delays of airline flights, we can see that Hawaiian Airlines has the lowest average departure delay of 0.48 mins whereas Spirit Airlines has an average departure delay of 15.68 mins.
When comparing the proportion of flights with ontime/early departures, about 74.75% of Alaska Airlines flights are ontime/early, while only 50.25% of United Airlines flights are ontime/early.
*/

select f.airline,
		al.airline as airline_name,
		avg(departure_delay) as avg_departure_delay
from flights_updated f 
left join airlines al
	on f.airline = al.iata_code
group by f.airline, al.airline
order by avg_departure_delay asc;

select f.airline,
		al.airline as airline_name,
        count(*) as total_flights,
        sum(if(departure_delay > 0, 1, 0)) as late_departure_count,
        sum(if(departure_delay <= 0, 1, 0)) as ontime_departure_count,
        (sum(if(departure_delay <= 0, 1, 0)) / count(*)) as ontime_proportion
from flights_updated f
left join airlines al
	on f.airline = al.iata_code
group by f.airline, al.airline
order by ontime_proportion desc;

/* 
Which airport experienced the most delays in 2015? 

Hartsfield-Jackson Atlanta International Airport has the highest count of delayed flights at 129,846 flights, which is 37.44% of its total flights.
However, Guam International Airport has the highest proportion of delayed flights at 67.66%.
*/

select f.origin_airport,
		ap.airport as origin_airport_name,
        count(*) as delayed_count
from flights_updated f 
left join airports ap
	on f.origin_airport = ap.iata_code
where departure_delay > 0
group by f.origin_airport, ap.airport
order by delayed_count desc;

select f.origin_airport,
	ap.airport as origin_airport_name,
	count(*) as total_flights,
	sum(if(f.departure_delay > 0, 1, 0)) as delayed_count,
    (sum(if(f.departure_delay > 0, 1, 0)) / count(*)) as delayed_proportion
from flights_updated f
left join airports ap
	on f.origin_airport = ap.iata_code
where origin_airport not like '1%'
group by origin_airport, ap.airport
order by delayed_proportion desc;

/* 
What is the average flight delay for each airline? 

The overall average departure delay is 9.23 mins.
The lowest departure delay average comes from Hawaiian Airlines with an avg_departure_delay of 0.48 mins, whereas the highest comes from Spirit Airlines with 15.68 mins.
*/

select avg(departure_delay)
from flights_updated;

select f.airline,
		al.airline as airline_name,
		avg(f.departure_delay) as avg_departure_delay
from flights_updated f
left join airlines al
	on f.airline = al.iata_code
group by f.airline, al.airline
order by avg_departure_delay;

/* 
Which airport has the most flight routes? 

Hartsfield-Jackson Atlanta International Airport has the most flight routes with flights travelling to 169 different airports.
*/

select f.origin_airport,
	ap.airport as origin_airport_name,
	count(distinct f.destination_airport) as routes_count
from flights_updated f
join airports ap
	on f.origin_airport = ap.iata_code
group by f.origin_airport, ap.airport
order by routes_count desc;
