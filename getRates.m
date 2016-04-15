function  rates1 = getRates(reversals)
%getRates Summary of this function goes here
%   Column 1 : Time
%   Column 2 : Values

% Generate random load history
%history = randomnumberfactory

% Finite Difference on reversal points
%reversals = findReversals(history);

    % Get difference between entries and compute rates
    numNdim = diff(reversals);
    rates1 = numNdim(:,2) ./ numNdim(:,1);
%{    
% Central Finite Difference (CFD) on original history
    
    % Determine size of time step and extract values for CFD
    step = 1;
    stepSize = step*2;
    CFDMatrix = history(1:stepSize:end,2)
    
    % Get difference between entries and compute rates
    rates2 = diff(CFDMatrix) / stepSize

% Least Squares Regression Rate

    % X and Y constant
    n = size(reversals,1)
    Xavg = sum(reversals(:,1))/n
    Yavg = sum(reversals(:,2))/n
    slope = sum((reversals(:,1)-Xavg).*(reversals(:,2)-Yavg))./sum((reversals(:,1)-Xavg).^2)
    Yint = Yavg - slope*Xavg
    %}
end

