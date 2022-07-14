% Simulate data as a list of 2d points
% Q: True data points 
% P: Transfromed true data points 

clc; clear; close all; 
addpath('utls/') % path to utility functions 

% Data generation parameters 
nPoints         = 30; 
angle           = pi/4;
trueRotation    = [cos(angle), -sin(angle); sin(angle), cos(angle)]; % true rotation
trueTranslation = [-2; 5]; % true translation 
clear angle 

% simulate true data (Q) 
Q      = zeros(2, nPoints); 
Q(1,:) = 0:1:(nPoints-1); 
Q(2,:) = 0.2.*Q(1,:).*sin(0.5.*Q(1,:));  

% Transformed version of the true data (P)
P = trueRotation*Q + trueTranslation; 

% plot points 
figure(Name='Before ICP')
plot_2Dpoints(P, Q) 


