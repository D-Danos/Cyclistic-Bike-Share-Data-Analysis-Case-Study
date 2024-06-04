--Welcome! We are going to start by creating a database in PostgreSQL.
--We are going to:
    --STEP 1: Create a table bike_raw
    --STEP 2: Import the data from the csv files into bike_raw table
    --STEP 3: Create a new table bike_pre, copy of bike_raw, that is going to be use to pre-process and clean the data.

--STEP 1: Creating bike_raw table. Data types are being set accordingly, some will be changed later on after checking the data:

    --CREATE bike_raw table:
    CREATE TABLE bike_raw (
        ride_id VARCHAR(50),
        rideable_type VARCHAR(20), 
        started_at TIMESTAMP, -- datetime value
        ended_at TIMESTAMP, -- datetime value
        start_station_name VARCHAR(100),
        start_station_id VARCHAR(50),
        end_station_name VARCHAR(100),
        end_station_id VARCHAR(50),
        start_lat NUMERIC, 
        start_lng NUMERIC,
        end_lat NUMERIC,
        end_lng NUMERIC,
        member_casual VARCHAR(20);
    )
    --DONE. Table has been created

--STEP 2: Importing Data from CSV files. 
    --Important: For this part remember to change the path/directory to your folder directory that contains all the CSV files.
    --Import all 12 CSVs/months:
    COPY bike_raw (ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual)
    FROM '/0.Sync/Coding/Data/Projects/CyclisticBike-Share/202301-divvy-tripdata.csv'
    DELIMITER ',' CSV HEADER;

    COPY bike_raw (ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual)
    FROM '/0.Sync/Coding/Data/Projects/CyclisticBike-Share/202302-divvy-tripdata.csv'
    DELIMITER ',' CSV HEADER;

    COPY bike_raw (ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual)
    FROM '/0.Sync/Coding/Data/Projects/CyclisticBike-Share/202303-divvy-tripdata.csv'
    DELIMITER ',' CSV HEADER;

    COPY bike_raw (ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual)
    FROM '/0.Sync/Coding/Data/Projects/CyclisticBike-Share/202304-divvy-tripdata.csv'
    DELIMITER ',' CSV HEADER;

    COPY bike_raw (ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual)
    FROM '/0.Sync/Coding/Data/Projects/CyclisticBike-Share/202305-divvy-tripdata.csv'
    DELIMITER ',' CSV HEADER;

    COPY bike_raw (ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual)
    FROM '/0.Sync/Coding/Data/Projects/CyclisticBike-Share/202306-divvy-tripdata.csv'
    DELIMITER ',' CSV HEADER;

    COPY bike_raw (ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual)
    FROM '/0.Sync/Coding/Data/Projects/CyclisticBike-Share/202307-divvy-tripdata.csv'
    DELIMITER ',' CSV HEADER;

    COPY bike_raw (ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual)
    FROM '/0.Sync/Coding/Data/Projects/CyclisticBike-Share/202308-divvy-tripdata.csv'
    DELIMITER ',' CSV HEADER;

    COPY bike_raw (ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual)
    FROM '/0.Sync/Coding/Data/Projects/CyclisticBike-Share/202309-divvy-tripdata.csv'
    DELIMITER ',' CSV HEADER;

    COPY bike_raw (ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual)
    FROM '/0.Sync/Coding/Data/Projects/CyclisticBike-Share/202310-divvy-tripdata.csv'
    DELIMITER ',' CSV HEADER;

    COPY bike_raw (ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual)
    FROM '/0.Sync/Coding/Data/Projects/CyclisticBike-Share/202311-divvy-tripdata.csv'
    DELIMITER ',' CSV HEADER;

    COPY bike_raw (ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual)
    FROM '/0.Sync/Coding/Data/Projects/CyclisticBike-Share/202312-divvy-tripdata.csv'
    DELIMITER ',' CSV HEADER;
    --DONE. Imported data from all csv files. 

    --We successfully created a bike_raw table, that has all the raw data from the csv files

--STEP 3: Creating bike_pre table, a copy of bike_raw table. We want to keep the raw data intact in bike_raw.

    --CREATE bike_pre table from bike_raw:
    CREATE TABLE bike_pre AS
    SELECT *
    FROM bike_raw;
    --DONE. We created bike_pre table. Bike pre is going to be used to pre-process and clean the data.

--The process of importing the data, and creating a new table with all raw values is complete. 

--Next, go to 2.SQL_Cleaning_and_processing_data.sql