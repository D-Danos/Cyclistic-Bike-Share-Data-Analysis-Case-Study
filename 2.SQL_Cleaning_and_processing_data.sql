--We are going to preprocess the data of bike_pre table we created. We are going check-clean the data.
--Reminder - the columns are:
    --ride_id: A unique identifier for each ride.
    --rideable_type: Type of rideable vehicle used for the trip (classic_bike,electric_bike,docked_bike).
    --started_at: The date and time when the ride started. (datetime data)
    --ended_at: The date and time when the ride ended. (datetime data)
    --start_station_name: The name of the station where the ride started.
    --start_station_id: The unique identifier of the station where the ride started.
    --end_station_name: The name of the station where the ride ended.
    --end_station_id: The unique identifier of the station where the ride ended.
    --start_lat: The latitude coordinate of the starting station.
    --start_lng: The longitude coordinate of the starting station.
    --end_lat: The latitude coordinate of the ending station.
    --end_lng: The longitude coordinate of the ending station.
    --member_casual: Indicates whether the rider is a member or a casual user of the service. (member,casual)

--Check for NULL values for ALL columns: 
--Query:
SELECT COUNT(*)
FROM bike_pre
WHERE ride_id IS NULL;
-- By running the above query for all columns:
    --start_station_name:875716 NULL values
    --start_station_id:875848 NULL values
    --end_station_name:929202 NULL values
    --end_station_id:929343 NULL values
    --end_lat:6990 NULL values
    --end_lng:6990 NULL values
-- Note: Enough rows seem to have incomplete records.

--Next we are going to check-clean the columns if neccessary. This process will be done in steps. Simiral columns will be dealt in groups.

--Check - Clean ride_id: Confirm as unique identifier,of length 16,and HEX:
	--Check if unique:
		--Query:
        SELECT
            ride_id,
            COUNT(ride_id) AS count_of_ride_id
        FROM bike_pre
        GROUP BY ride_id
        HAVING COUNT(ride_id) <> 1
        ORDER BY count_of_ride_id DESC;
        --Result: 0 results, they all unique. All ride_id values have COUNT(ride_id)=1

	--Check if length 16:
		--Query:
        SELECT
            ride_id,
            LENGTH(ride_id) AS length_of_ride_id
        FROM bike_pre
        GROUP BY ride_id
        HAVING LENGTH(ride_id) <> 16
        ORDER BY length_of_ride_id DESC;
		--Result: 0 results, they all of length 16. All ride_id values have LENGTH(ride_id)=16

	--Check if HEX:
		--Query - Return all non HEX ride_id:
        SELECT
            ride_id
        FROM
            bike_pre
        WHERE
            ride_id ~ '[^0-9a-fA-F]'; --we use regular expressions. Pattern for HEX is 0-9 and a-f or A-F. ^ is for any characters NOT matching the 0-9a-fA-F pattern.
		--Result: 0 results, they all contain HEX characters.

	--Alter the Datatype: Set as primary and VARCHAR(16)	
        ALTER TABLE bike_pre
        ALTER COLUMN ride_id TYPE VARCHAR(16),
        ADD PRIMARY KEY (ride_id);
	--Result: Has been set to Varchar(16) as they all have LENGTH 16, and have set it as a primary key
	
    --DONE. ride_id has been checked: no issues found. (Confirmed as unique identifier,of length 16,and HEX)

--Check - Clean rideable_type: Confirm the options (classic_bike,electric_bike,docked_bike).
	--Query:
        SELECT DISTINCT
            rideable_type
        FROM bike_pre;
	--Result: 3 types of rideable_types: classic_bike,docked_bike,electric_bike

--QUERY counts of rideable_type
SELECT 
	rideable_type,
	COUNT(rideable_type) as count_of_rideable_type
FROM bike_pre
GROUP BY rideable_type
ORDER BY count_of_rideable_type;
--Result: docked_bike:78287,classic_bike:2696011,electric_bike:2945579

--Check - Clean started_at,ended_at: Confirm Start be within 2023 (datetime data)
	--Query:
        SELECT
            MIN(started_at) AS min_stated_at,
            MAX(started_at) AS max_started_at,
            MIN(ended_at) AS min_ended_at,
            MAX(ended_at) AS max_ended_at
        FROM bike_pre;

	--Result:"2023-01-01 00:01:58"	"2023-12-31 23:59:38"	"2023-01-01 00:02:41"	"2024-01-01 23:50:51"

	--DONE. No issues with the ranged of datetime data as start_at is within 2023. Max of ended at can be from 2024: the records are for when ride started.

--Check - Clean start_station_name,end_station_name: Unique, The name of the station where the ride started 
	--Query:
	--Result:
		
	--UPDATE:
	--Result:
	--DONE.

--Check - Clean start_station_id,end_station_id: Should be unique identifiers for the station NAMES where the ride started 
	--We are going to check possible spaces within names:
	--Query:
	--Result:	
	
	--We are checking for abnormalities in station names with the following query:
	--Query:
	--Result:
	
	--UPDATE:
	--Result:
	
	--We have cases where the names need cleaning. We will tackle those cases one by one:
		--Name contains "sta":	
			--Query
			--UPDATE:
			--Result:
		--Name contains "*":	
			--Query
			--UPDATE:
			--Result:
	--DONE.

--Check - Clean start_lat,start_lng,end_lat,end_lng: non 0.0, within chicago area 
	--Check if non 0.0:
		--Query:
		--Result:
		
		--UPDATE:
		--Result:
	--Check if within Chicago area:
		--Query:
		--Result:
	--DONE.
--Check - Clean member_casual: Indicates whether the rider is a member or a casual user of the service. (member,casual)
 	--Query:
        SELECT DISTINCT
            member_casual
        FROM bike_pre
	--Result: Only 2 results: member,casual
	--DONE. member_casual has been checked: no issues found. 

--SUMMARY 
    --ride_id: No issues found.
    --rideable_type: Type of rideable vehicle used for the trip (classic_bike,electric_bike,docked_bike).
    --started_at: No issues found.
    --ended_at: No issues found.
    --start_station_name: 
    --start_station_id:
    --end_station_name:
    --end_station_id: 
    --start_lat: Has NULL,0.0 values.
    --start_lng: The longitude coordinate of the starting station.
    --end_lat: Has NULL, 0.0 values.
    --end_lng: Has NULL, 0.0 values.
    --member_casual: No issues found.
-- Issues found:
	--Incomplete:
		--Rows are some times incomplete: start or end information sometimes are missing
	--Reliability issues:
		--Some rides seem to end before starting which seems unreliable. We going to tackle this issue in the next file 3.SQL_Create_new_columns_for_later_analysis where we going to create durations
	--No actual station name were provided to validate. Names of stations had errors 
	--Some station ids are not unique because they are in different formats (some had 3 numbers some had 5)
	--Locations had 0.0 values
	
--The data seem to be incomplete some times and not as reliable as we would have wanted.
--Reliable: the datatime data seem to have start time after end time.
--Original: we are obtaining them from a first party source. They are original
--Comprehensive:
--Current:
--Cited:  