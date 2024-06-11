--Now we are going to pre-process the data of bike_pre table we created. We are going check-clean the data.
--Reminder - the columns are:
    --ride_id: A unique identifier for each ride.
    --rideable_type: Type of rideable vehicle used for the trip. (classic_bike,electric_bike,docked_bike).
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

--Next we are going to check-clean the columns if necessary. This process will be done in steps. Simiral columns will be dealt in groups.

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
        --OK.

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
        --OK.

	--Check if HEX:
		--Query - Return all non HEX ride_id:
        SELECT
            ride_id
        FROM
            bike_pre
        WHERE
            ride_id ~ '[^0-9a-fA-F]'; --we use regular expressions. Pattern for HEX is 0-9 and a-f or A-F. ^ is for any characters NOT matching the 0-9a-fA-F pattern.
		--Result: 0 results, they all contain HEX characters.
        --OK

	--Alter the Datatype: Set as primary and VARCHAR(16)	
        ALTER TABLE bike_pre
        ALTER COLUMN ride_id TYPE VARCHAR(16),
        ADD PRIMARY KEY (ride_id);
	--Result: Has been set to VARCHAR(16) as they all have LENGTH 16, and have set it as a primary key
	
    --DONE. ride_id has been checked: no issues found. (Confirmed as unique identifier,of length 16,and HEX, no NULL).



--Check - Clean rideable_type: Confirm the options (classic_bike,electric_bike,docked_bike):
    --Search for all DISTINCT values:
	--Query:
        SELECT DISTINCT
            rideable_type
        FROM bike_pre;
	--Result: 3 types of rideable_types: classic_bike,docked_bike,electric_bike

    --COUNT number of rides for all 3 types classic_bike,docked_bike,electric_bike:
    --Query:
    SELECT 
        rideable_type,
        COUNT(rideable_type) as count_of_rideable_type
    FROM bike_pre
    GROUP BY rideable_type
    ORDER BY count_of_rideable_type;
    --Result: docked_bike:78287,classic_bike:2696011,electric_bike:2945579

    --Query:
        SELECT 
            member_casual,
            COUNT(*)
        FROM bike_pre
        WHERE rideable_type='docked_bike'
        GROUP BY member_casual
    --Result: all docked bikes are from casual members.

    --Note: Some records for casuals, don't describe the type of biked used but just docked_bike.
    --Will keep it in mind for our later analysis for rideable_types.

    --DONE. Are either electric (electric_bike),classic (classic_bike), or undefined (docked_bike). No NULL values.

--Check - Clean started_at,ended_at: Confirm Start be within 2023 (datetime data):
	--Query:
        SELECT
            MIN(started_at) AS min_stated_at,
            MAX(started_at) AS max_started_at,
            MIN(ended_at) AS min_ended_at,
            MAX(ended_at) AS max_ended_at
        FROM bike_pre;

	--Result:"2023-01-01 00:01:58"	"2023-12-31 23:59:38"	"2023-01-01 00:02:41"	"2024-01-01 23:50:51"

	--DONE FOR NOW. No issues with the range of datetime data as start_at is within 2023. Max of ended at can be from 2024: 
    --the records are for when ride started. 
    
    --Some started_at values are before ended_at. We will check for that on part 3 
    --when we are going to create ride_duration.


--Check - Clean start_station_name,end_station_name,start_station_id,end_station_id:
    --station_names: check for typos.
    --ids: Should be unique identifiers for the station names
    
    --Perform some cleaning on station names (start and end stations):
        --TRIM station names:
            --Query:
            WITH trimming_needed AS (
                SELECT
                    *,
                    CASE
                        WHEN start_station_name ~ '^\s|\s$' THEN 'Start Station Name needs trimming'
                        WHEN end_station_name ~ '^\s|\s$' THEN 'End Station Name needs trimming'
                        ELSE 'No trimming needed'
                    END AS trim_check
                FROM
                    bike_pre
            )
            SELECT *
            FROM trimming_needed
            WHERE trim_check <> 'No trimming needed';
            --Results: 409 results rows that need to be trimmed. Will trim all:
            --UPDATE:
            UPDATE
                bike_pre
            SET
                start_station_name = TRIM(start_station_name),
                end_station_name = TRIM(end_station_name),
            --DONE. Station names are trimmed

        -- Check - Clean double spaces '  ' of station names:
            --Query:
            WITH double_space_check AS (
                SELECT
                    *,
                    CASE
                        WHEN start_station_name ~ '\s\s+' THEN 'Start Station Name has double spaces'
                        WHEN end_station_name ~ '\s\s+' THEN 'End Station Name has double spaces'
                        ELSE 'No double spaces'
                    END AS double_space_check
                FROM
                    bike_pre
            )
            SELECT *
            FROM double_space_check
            WHERE double_space_check <> 'No double spaces';
            --Result: 8 results. Gonna remove those '  '.

            --UPDATE:
            UPDATE bike_pre
            SET
                start_station_name = REPLACE(start_station_name, '  ', ' '),
                end_station_name = REPLACE(end_station_name, '  ', ' ')
            WHERE
                start_station_name ~ '\s\s+' OR end_station_name ~ '\s\s+';
            --DONE. By re-running the previous query we see 0 results, double spaces are gone. Note that we may have had to use 
            -- this UPDATE again as this removes only one '  ' from the strings, if it had two we would have to run it a second time.
            
        --Explore DISTINCT station_name,station_id pairs:
            --Query: 
            SELECT DISTINCT
                start_station_name AS station_name,
                start_station_id AS station_id
            FROM bike_pre
            UNION
            SELECT DISTINCT
                end_station_name AS station_name,
                end_station_id AS station_id
            FROM bike_pre;

            --Find all columns for which station ids match to more than one station name by:
                --Identify and lists all distinct station pairs (station name and station ID) 
                --and filter to show only those stations where the station ID appears more than onc., 
            --Query:
                SELECT DISTINCT
                    start_station_name AS station_name,
                    start_station_id AS station_id
                FROM bike_pre
                UNION
                SELECT DISTINCT
                    end_station_name AS station_name,
                    end_station_id AS station_id
                FROM bike_pre
            ),
            station_id_counts AS (
                SELECT
                    station_id,
                    COUNT(*) AS times_id_appeared
                FROM unique_station_pairs
                GROUP BY station_id
                HAVING COUNT(*) > 1
            )
            SELECT 
                sp.station_name,
                sp.station_id,
                sc.times_id_appeared
            FROM unique_station_pairs sp
            JOIN station_id_counts sc ON sp.station_id = sc.station_id
            ORDER BY station_id
            --Result: 184 results that names need to be fixed.
   
            --Fix stations names that have ' (Temp)'
            --UPDATE:
            UPDATE bike_pre
            SET
                start_station_name = REPLACE(start_station_name, '% (Temp)', ''),
                end_station_name = REPLACE(end_station_name, '% (Temp)', '')
            WHERE 
                start_station_name LIKE '% (Temp)' OR
                end_station_name LIKE '% (Temp)';
            --Result: even after doing this cleaning we can see that station_id - station names have matches to different stations. 
            
            --We have no list nor number of stations and their respective ids, to crosscheck the values making it impossible to clean, as even the ids don't match to unique stations. 
            
            --Thankfully, stations names and ids are not a part of our analysis, so don't need to be cleaned further
            --(though still makes the data look less reliable).

--Check - Clean start_lat,start_lng,end_lat,end_lng: within Chicago area: 
	--Query:
    SELECT
        MIN(start_lat) AS min_start_lat,
        MAX(start_lng) AS max_start_lng,
        MIN(end_lat) AS min_end_lat,
        MAX(end_lng) AS max_end_lng
    FROM bike_pre;
    --Result: 41.63	-87.46	0.0	0.0. There are 0.0 values for end_lat and end_lng, which are not valid
    --Explore end_lat and end_lng that are 0:
		--Query:
        SELECT *
        FROM bike_pre
        WHERE 
            end_lat=0 OR 
            end_lng=0
		--Result: 3 results. Will set them to NULL: 
		--UPDATE:
        UPDATE bike_pre
        SET
            end_lat = NULL,
            end_lng = NULL
        WHERE 
            end_lat=0 OR 
            end_lng=0
		--UPDATE: Have been set to null.

    --By rerunning the query:
    SELECT
        MIN(start_lat) AS min_start_lat,
        MAX(start_lng) AS max_start_lng,
        MIN(end_lat) AS min_end_lat,
        MAX(end_lng) AS max_end_lng
    FROM bike_pre;
	--Result:
    --min_start_lat| max_start_lng | min_end_lat  | max_end_lng
    --41.63	       |   -87.46	   |   41.61      |   -87.44
    --Chicago is has lat,lng :(41.881832,-87.623177). So coordinates are indeed within Chicago area.
    --DONE. All coordinates are within the Chicago area.

--Check - Clean member_casual: Indicates whether the rider is a member or a casual user of the service. (member,casual):
 	--Query:
        SELECT DISTINCT
            member_casual
        FROM bike_pre
	--Result: Only 2 results: member,casual
	--DONE. member_casual has been checked: no issues found. 

--SUMMARY for columns: 
    --ride_id: No issues found. Has been set to VARCHAR(16), primary key.
    --rideable_type: Types of rideable vehicle used for the trip (classic_bike,electric_bike,docked_bike).
    --started_at: Within range. Some end before starting. Will check again in 3.SQL_Create_new_columns_for_later_analysis.
    --ended_at: Within range. Some end before starting. Will check again in 3.SQL_Create_new_columns_for_later_analysis.
    --start_station_name: Many typos. Station name can match to more than one id. Has NULL values.
    --start_station_id: Same station id can much to more than one station. Has NULL values.
    --end_station_name: Many typos. Station name can match to more than one id. Has NULL values.
    --end_station_id: same station id can much to more than one station. Has NULL values.
    --start_lat: No issues found.
    --start_lng: No issues found.
    --end_lat: Had three 0.0 values, been fixed. Has 6990+3 NULL values.
    --end_lng: had three 0.0 values, been fixed. Has 6990+3 NULL values.
    --member_casual: No issues found.
-- Issues found:
	--Incomplete:
		--Rows are some times incomplete, and have missing values for end start information.
	--Reliability issues:
		--Some rides seem to end before starting. We going to tackle this issue in the next file 3.SQL_Create_new_columns_for_later_analysis where we going to create ride_duration.
	--Names of stations have errors, and no actual station info was provided to validate.  
	--Station ids are not always unique to the station, and have many different formats (ex. some had 3 numbers some had 5)
	--Locations had three 0.0 values. Cleaned
	

--CONCLUSIONS
    --We need to look further into started_at,ended_at. Will do so in the next part: 3.SQL_Create_new_columns_for_later_analysis.
    --While start_station_name,end_station_name,start_station_id,end_station_id have issues, they are not part of our analysis.

--Next, go to 3.SQL_Create_new_columns_for_later_analysis.sql