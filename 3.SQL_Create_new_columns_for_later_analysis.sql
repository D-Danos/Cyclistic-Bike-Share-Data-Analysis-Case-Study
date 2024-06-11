--We are going to create columns, that we are going to use for our analysis. Those are:
	--ride_duration (total ride_duration of ride in min)
	--day_of_the_week (in "Mon","Tue",... format)
	--month ('Jan','Feb',... format)

--ADD ride_duration column (total ride_duration of ride in min):
	--ALTER TABLE - ADD COLUMN:
	ALTER TABLE bike_pre
	ADD COLUMN ride_duration DECIMAL(10, 2);
	--UPDATE SET, calculate duration in minutes with 2 decimal points:
	UPDATE bike_pre
	SET ride_duration = EXTRACT(EPOCH FROM (ended_at - started_at)) / 60.0;

	--Check - Clean ride_duration:

		--Find all rows with negative durations
		--Query:
		SELECT * 
		FROM bike_pre
		WHERE ride_duration<0;
		--Result:272 rows with negative durations. Will set the to NULL

		--SET ride_duration<0 to NULL:
		--UPDATE:
		UPDATE bike_pre
		SET ride_duration=NULL
		WHERE ride_duration<0;
		--Result: Have been set to null no longer negative durations.


	--DONE.

--First we gonna index start_at so we can make the following quicker:
CREATE INDEX started_at_index
ON bike_pre (started_at);

--Create day_of_the_week (in "Mon","Tue",... format):
	--ALTER TABLE - ADD COLUMN:
	ALTER TABLE bike_pre
	ADD COLUMN day_of_the_week VARCHAR(3);

	--UPDATE - SET:
	UPDATE bike_pre
	SET day_of_the_week = TO_CHAR(started_at, 'Dy');
	--DONE.


--Create month column ('Jan','Feb',... format)
	--ALTER TABLE - ADD COLUMN:
	ALTER TABLE bike_pre
	ADD COLUMN month VARCHAR(3);

	--UPDATE - SET:
	UPDATE bike_pre
	SET month = TO_CHAR(started_at, 'Mon');
	--DONE. Column month
	
--CREATE bike_data table from bike_pre:
CREATE TABLE bike_data AS
SELECT *
FROM bike_pre;
--DONE. We created bike_data table. Bike data is going to imported in python for further data analysis.


--SUMMARY - Issues found:
-- There are negative ride durations, which is an indication for wrong inputs. Those inputs have been set to NULL.

--Next, move to Python_Cyclistic_bike-share_data_analysis.ipynb.