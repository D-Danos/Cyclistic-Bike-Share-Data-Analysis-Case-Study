--We are going to create columns, that we are going to use for our analysis. Those are:
	--duration (total duration of ride in min)
	--day_of_the_week (in "Mon","Tue",... format)
	--month ('JAN','FEB',... format)

--Create duration column (total duration of ride in min):
	--ALTER TABLE - ADD:

	--Check if duration >0:
	
	--Result:
	
	--UPDATE:
	
	--Result:	
	--DONE
	
--Create day_of_the_week (in "Mon","Tue",... format)
	--ALTER TABLE - ADD:

	--Check unique values, to see if all values are formatted correctly:
	
	--DONE.
	
--Create month column ('JAN','FEB',... format)
	--ALTER TABLE - ADD:

	--Check unique values, to see if all values are formatted correctly:

	--DONE.
	
--SUMMARY - Issues found:
-- There are negative durations, which is an indication for wrong inputs in the data as, cannot return before renting.