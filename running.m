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

% Do relevant conversions
distance_km = distance_raw / 1e3;

% Issue with placeholder values in csv file.
% Assume the activity is not greater than 1000 km for now.

distance_km(distance_km > 1000) = NaN;
pace_mpk = 60 ./ speed_kph;             % min per km

pace_mpk(speed_kph < 1 | speed_kph > 20) = NaN;

% Calculate summary stats
total_distance_km = max(distance_km);
total_time = time(end) - time(1);
avg_speed_kph = mean(speed_kph, 'omitnan');
avg_pace_mpk = mean(pace_mpk, 'omitnan');
hr(hr == 255) = NaN;
avg_hr = mean(hr, 'omitnan'); %% need to also digure out how to omit 255 as i got a lot of those
elevation_gain = sum(max(diff(altitude), 0), 'omitnan'); %% for some reason this is saying 0 

fprintf('\n--- ACTIVITY SUMMARY ---\n');
fprintf('Total distance: %.2f km\n', total_distance_km);
fprintf('Total time: %s\n', datestr(total_time, 'HH:MM:SS'));
fprintf('Average speed: %.2f km/h\n', avg_speed_kph);
fprintf('Average pace: %.2f min/km\n', avg_pace_mpk);
fprintf('Average HR: %.0f bpm\n', avg_hr);
fprintf('Total elevation gain: %.0f m\n', elevation_gain);


%% Plot Geo Map of Route

figure;
geoplot(lat, long, 'r')
title("Route Map")

%% Plot Pace vs Time

% Using median instead of mean for large increases (i.e. bathroom stops) to
% not skew the pace.
smoothed_pace = movmedian(pace_mpk, 1000, 'omitnan'); 

figure;
plot(time, smoothed_pace, 'b', LineWidth=1.5);
xlabel("Time of Day")
ylabel("Pace (min/km)")
title("Pace vs Time for Activity")


%%

% Lot of NaNs in HR so have to filter out just the numbers (or else it just
% plots as dots)

valid_idx = ~isnan(hr);
time_valid = time(valid_idx);
hr_valid = hr(valid_idx);

filtered_hr = movmedian(hr_valid, 10); % filter out some of the noise

figure;
plot(time_valid, filtered_hr, '-r', LineWidth=1.2);
ylabel('Heart Rate (bpm)');
xlabel('Time');
title('Heart Rate Profile');
grid on;

