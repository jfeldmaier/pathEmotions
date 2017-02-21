function [ average ] = movingAverage( actual_value, average )
%MOVINGAVERAGE Summary of this function goes here
%   Detailed explanation goes here

if isempty(average)
    average = actual_value;
else
    average = (average + actual_value) / 2;
end


end

