% Simulate data as a list of 2d points
% Q: Fixed scan data points 
% P: Moving true data points 

clc; clear; close all; 
addpath('utls/'); % path to utility functions
addpath('data/'); % path to lidar data

% Lidar preprocessing
fileName = 'scans.mat';
Lidar    = Lidar(fileName); % read lidar scans
startIdx = 1;
step     = 2;
stopIdx  = Lidar.nScans;
Lidar    = Lidar.down_sample(startIdx, step, stopIdx);
clear startIdx step stopIdx

% Select any scans for scan matching 
Pscan = 101; % moving scan
Qscan = 100; % fixed scan
P     = Lidar.polar_to_cartesian(Lidar.ranges(Pscan,:), Lidar.angle);
Q     = Lidar.polar_to_cartesian(Lidar.ranges(Qscan,:), Lidar.angle);

% Plot raw data
figure(Name='Before ICP');
plot_2Dpoints(P,Q, strcat('P: scan - ', num2str(Pscan)), ...
                    strcat('Q: scan - ', num2str(Qscan)))

