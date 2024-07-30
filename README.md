<h1>Cyclistic Bike-Share Data Analysis Case Study</h1>
<u><b>Tools:</b>PostgreSQL,Python libraries: numpy,pandas,matplotlib,os, Other libraries supplementary used:sqlalchemy (import data),scipy.stats (trimmed mean)<u><br>
<br>
Contains: 
<ol>
<li><b>powerpoint</b> with the <em>results of the analysis.</em></li>
<li><b>.ipynb file</b> with the <em>python code.</em></li>
<li><b>.sql files</b> for the <em>postgreSQL database setup and data cleaning</em></li>
<li><b>.csv file</b>, in case you want to <em> jump straight to the python code without creating the SQL database - datacleaning steps.</em></li>
<h2>Introduction</h2>
Cyclistic is a bike-sharing program in Chicago, offering various types of bicycles and docking stations. This case study focuses on analyzing Cyclistic bike-share data to improve marketing strategies and <span style="color:red"><b>increase the number of annual members by converting casual members into annual members</b></span>.
<h3>People Involved</h3>
<ul>
<li><b>Director of Marketing - Lily Moreno:</b> Develops campaigns and initiatives to promote the program through email, social media, etc.</li>
<li><b>Cyclistic Marketing Analytics Team:</b> Our team of data analysts working to guide the marketing strategy.</li>
<li><b>Cyclistic Executive Team:</b> The executive team responsible for deciding whether to approve the recommended marketing program.</li>
</ul>
<h3>Ride Options Available:</h3>
<ul>
<li>Single ride passes (<em>casual members</em>)</li>
<li>Full-day passes (<em>casual members</em>)</li>
<li>Annual memberships (<em>annual members</em>)</li>
</ul>
<h2>Goals</h2>
<div class="alert alert-block alert-success">
<ul>
<li><em><b>Maximize the number of annual members by converting casual riders to annual members</b></em>, as annual members are much more profitable than casual riders.</li>
<li><em><b>Understand how casual riders and annual members use Cyclistic bikes differently.</b></em></li>
</ul>
</div>
<h3>Guiding Questions</h3>
<ol>
<li>How do casual riders use Cyclistic bikes differently compared to annual members?</li>
<li>Why would casual riders buy a membership?</li>
<li>How can Cyclistic use digital media to influence casual riders to become members?</li>
</ol>

<h3>Deliverables</h3>
<ol>
<li>Statement of Business Task: Clearly define the business task at hand.</li>
<li>Description of Data Sources: Provide a detailed description of all data sources used.</li>
<li>Data Cleaning and Manipulation Documentation: Document any cleaning or manipulation of data performed.</li>
<li>Summary of Analysis: Summarize the key findings from the data analysis.</li>
<li>Supporting Visualizations and Key Findings: Include visualizations that support the analysis and highlight key findings.</li>
<li>Top Three Recommendations: Provide the top three recommendations based on our analysis.</li>
</ol>
<h2>The Data</h2>
<p>The data has been made available by Motivate International Inc. under this <a href="https://divvybikes.com/data-license-agreement">license</a>.</p>

<b>Data Availability:</b>
<p>Data is available in <code>CSV</code> files. For the analysis, data from all months of 2023 has been chosen to ensure a comprehensive dataset and to identify patterns and trends throughout the year. To follow along, <em>download all files from <code>202301-divvy-tripdata.zip</code> to <code>202312-divvy-tripdata.zip</code> (12 months)</em> <a href="https://divvy-tripdata.s3.amazonaws.com/index.html">here</a>.</p>
<p>I suggest creating a folder and extracting the CSV files from the ZIP archives into it; we will path towards that folder later when importing into SQL.</p>

<h6> <em><b>Data: Column descriptions</b></em> 
<ul>
<li>ride_id: A unique identifier for each ride.</li>
<li>rideable_type: Type of rideable vehicle used for the trip (classic_bike,electric_bike,docked_bike).</li>
<li>started_at: The date and time when the ride started. (datetime data)</li>
<li>ended_at: The date and time when the ride ended. (datetime data)</li>
<li>start_station_name: The name of the station where the ride started.</li>
<li>start_station_id: The unique identifier of the station where the ride started.</li>
<li>end_station_name: The name of the station where the ride ended.</li>
<li>end_station_id: The unique identifier of the station where the ride ended.</li>
<li>start_lat: The latitude coordinate of the starting station.</li>
<li>start_lng: The longitude coordinate of the starting station.</li>
<li>end_lat: The latitude coordinate of the ending station.</li>
<li>end_lng: The longitude coordinate of the ending station.</li>
<li>member_casual: Indicates whether the rider is a member or a casual user of the service. (member,casual)</li>
</ul></h6>

<h1>Execution</h1>
<h2>Part 1: SQL</h2>
<p>The SQL part will be completed in the following <code>.sql</code> files. <em>(See repository)</em>:</p>
<ul>
<li>1.SQL_Create_Database_from_CSV_files</li>
<li>2.SQL_Cleaning_and_processing_data</li>
<li>3.SQL_Create_new_columns_for_later_analysis</li>
</ul>
<p><em>Note: We will be creating new tables along the way to check our progress.</em></p>
<h3><b>Tables</b></h3>
<ul>
<li><code>bike_raw</code>: Table saved as imported from CSV files.</li>
<li><code>bike_pre</code>: Created from <code>bike_raw</code> - table to be preprocessed and cleaned. After cleaning and preprocessing, new columns will be created for later analysis.</li>
<li><code>bike_data</code>: Created from <code>bike_pre</code> after all cleaning is done and needed columns have been added. - data ready to be imported for analysis in Python.</li>
</ul>
<h2>Part 2: Python</h2>
<p>The python code is contained within <code>Python_Cyclistic_bike-share_data_analysis.ipynb</code> notebook. Includes a brief recap of the data and cleaning process done, a table of contents, importing the data in a Dataframe, and the Exploratory Data Analysis (EDA).<em>(See repository)</em>.</p>
<p><mark>Note:</mark> <em><b>If you want to jump straight to the analysis without doing the SQL part, there is an alternative version using an already cleaned CSV within the repository.
<h2>Part 3: Results</h2>
<p>Share key findings, conclusion and suggestions:<code>Cyclistic_Bikes_Results_Powerpoint.pptx</code> <em>(See repository)</em>.</p>
