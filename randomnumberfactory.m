function matrix=randomnumberfactory
% Create matrix to test the cycle counting methods
    highNum = 20;       % Set highest random number
    numValues = 100;    % Set the number of values
    matrix = zeros(numValues,2);    % Initalize martix
    matrix(1,:) = [1,round(rand*highNum,4)];
    
    for i=2:numValues
        matrix(i,:) = [i,round(rand*highNum,4)];	% Load each row as [Index, Random Number]
        
        if (matrix(i,2) == matrix(i-1,2))       % If the current entry is the same as the last...
            matrix(i,2) = round(rand*highNum,4);	% ...replace it with another number
        end
        
        if rand > 0.5                   % Randomly make number positive or negative
            matrix(i,2) = -matrix(i,2);  
        end
    end
end
