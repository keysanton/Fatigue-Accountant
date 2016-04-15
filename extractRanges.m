function [positiveInfo, negativeInfo] = extractRanges(array)
% Requires array of peak and valley values

n = size(array,1) % Determine size of array
posCount = 0;
negCount = 0;

    for i=2:n   % Loop through entire array and extract positve and negative ranges
        currentRange = [array(i-1),array(i)];                                    % Get value for current index
        rangeData = [currentRange,range(currentRange),mean(currentRange),0.5];  % Store the values and range between them
        
        if currentRange(2) > currentRange(1)        % If the current range is positive...
            posCount = posCount + 1;                % ... add to the postive range count
            positiveInfo(posCount,:) = rangeData;   % ... store the rangeData and mean of range
            
        else                                        % ...otherwise, the range is negative
            negCount = negCount + 1;                % Add to the negative range count
            negativeInfo(negCount,:) = rangeData;   % Store the rangeData and mean of range
        end
    end
end

