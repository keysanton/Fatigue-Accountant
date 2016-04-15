function [newHistory,cycleCounts] = countPeaks(array)

[pos,neg] = extractRanges(array)    % Extract the positive and negative ranges

% Sort range from largest to smallest
posSorted = sortrows(pos,-3);   % largest postive 
negSorted = sortrows(neg,3);    % largest negative

% Reconstruct load history
    if length(pos(:,1)) > length(neg(:,1))  % If the positive bin has more values...
        first = posSorted;                  % ...set it as the first bin
        second = negSorted;
        
    else                                    % ...otherwise
        first = negSorted;                  % ...set the negative bin as the first bin
        second = posSorted;
    end
    
    [n,m] = size(second);       % Determine the number of positive and negative pairs
    newHistory = zeros(n,m);    % Set matrix size
    cycleCounts = n;            % Set number of cycles
    
    for i = 1:n     % Loop through and pair the numbers
        newHistory(2*i-1,:) = first(i,:);
        newHistory(2*i,:) = second(i,:);
    end

    if length(pos(:,1)) ~= length(neg(:,1)) % If the bins are NOT the same size...
        newHistory(2*n+1,:) = first(n+1,:); % ...add the last entry of the first bin...
        cycleCounts = cycleCounts + 0.5;    % ...and add a half cycle to cycleCounts
    end
end