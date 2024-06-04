--We are going to create columns, that we are going to use for our analysis. Those are:
	--ride_duration_min (total ride_duration_min of ride in min)
	--day_of_the_week (in "Mon","Tue",... format)
	--month ('JAN','FEB',... format)

--ADD ride_ride_duration_min column (total ride_duration_min of ride in min):
	--ALTER TABLE - ADD COLUMN:
	ALTER TABLE bike_pre
	ADD COLUMN ride_duration DECIMAL(10, 2);
	--UPDATE SET, calculate duration in minutes with 2 decimal points:
	UPDATE bike_pre
	SET ride_duration = EXTRACT(EPOCH FROM (ended_at - started_at)) / 60.0;

	--Check - Clean ride_duration_min:
		--Check ride_duration_min MIN-MAX:
		--Query:
		SELECT
			MIN(ride_duration) AS min_duration,
			MAX(ride_duration) AS max_duration
		FROM bike_pre;
		--Result:
		
		--Find all rows with negative durations
		--Query:
		SELECT * 
		FROM bike_pre
		WHERE ride_duration<0;
		--Result:272 rows with negative durations. Will set the to NULL

		--SET ride_duration_min<0 to NULL:
		--UPDATE:
		UPDATE bike_pre
		SET ride_duration=NULL
		WHERE ride_duration<0;
		--Result: Have been set to null no longer negative durations.

		--Check longest duration values by - SORT BY ride_duration DESC:
		--Query:
		SELECT *
		FROM bike_pre
		WHERE ride_duration IS NOT NULL
		ORDER BY ride_duration DESC
		LIMIT 1000;

		--SET outlier to NULL:
		--UPDATE:
		--Result:
	
		--Result:	

	--DONE

--First we gonna index start_at so we can make the following quicker:
CREATE INDEX started_at_index
ON bike_pre (started_at);

--Create day_of_the_week (in "Mon","Tue",... format)
	--ALTER TABLE - ADD COLUMN:
	ALTER TABLE bike_pre
	ADD COLUMN day_of_the_week VARCHAR(3);
	--Check unique values, to see if all values are formatted correctly:
	--Query:
	UPDATE bike_pre
	SET day_of_the_week = TO_CHAR(started_at, 'Dy');
	--DONE.


--Create month column ('JAN','FEB',... format)
	--ALTER TABLE - ADD COLUMN:
	ALTER TABLE bike_pre
	ADD COLUMN month_abbr VARCHAR(3);
	--Check unique values, to see if all values are formatted correctly:
	--Query:
	UPDATE bike_pre
	SET month_abbr = TO_CHAR(started_at, 'Mon');
	--DONE.
	
--CREATE bike_data table from bike_pre:
CREATE TABLE bike_data AS
SELECT *
FROM bike_pre;
--DONE. We created bike_data table. Bike data is going to imported in python for further data analysis.


--SUMMARY - Issues found:
-- There are negative ride durations, which is an indication for wrong inputs. Those inputs have been set to NULL.

