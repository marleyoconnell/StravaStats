% On strava, downlaod the original (.fit)
% Use online converter (i.e. GOTOES) to convert to CSV
% Delete first column (added by GOTOES)

%% Load the Activity File of Interest

% Load CSV File
data = readtable('Toronto_Marathon.csv');

%% Preliminary analysis

% Extract out relevant columns
time = datetime(data.timestamp);
% data.Properties.VariableNames

lat = data.position_lat;
long = data.position_long;
altitude = data.altitude;
hr = data.heart_rate;
distance_raw = data.distance;
speed_kph = data.speed;
power = data.power;
