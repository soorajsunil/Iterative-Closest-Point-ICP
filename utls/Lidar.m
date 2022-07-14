classdef Lidar
    % LIDAR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        angle
        ranges 
        angleIncrement
        maxRange
        minRange 
        nScans
        scanLength 
    end
    
    methods
        function obj = Lidar(fileName)
            % read data from .mat file as Lidar struct 
            % ** Note: lidar data has been preprocessed to suit the process 
            data = load(fileName); % load data 
            obj.angle          = data.angles; 
            obj.ranges         = data.ranges;
            obj.angleIncrement = data.angleIncrement; 
            obj.minRange       = min(obj.ranges, [], 'all', 'omitnan'); 
            obj.maxRange       = max(obj.ranges, [], 'all', 'omitnan'); 
            [obj.nScans , obj.scanLength] = size(obj.ranges); 
        end

        function obj = down_sample(obj, startIdx, stepSize, stopIdx)
            % Optional down sampling of data   
            sampleIdx  = startIdx:stepSize:stopIdx;   
            obj.ranges = obj.ranges(sampleIdx,:);         
            % recompute the properties for down sampled data 
            obj.minRange  = min(obj.ranges, [], 'all', 'omitnan'); 
            obj.maxRange  = max(obj.ranges, [], 'all', 'omitnan'); 
            [obj.nScans , obj.scanLength] = size(obj.ranges);  
        end 

        function [scan_xy] = polar_to_cartesian(~, range, angle)       
            scan_xy(1,:)  = range.*cos(angle); 
            scan_xy(2,:)  = range.*sin(angle); 
        end 

    end
end

