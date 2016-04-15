function [extracted, rearrangedHistory] = rainflow4p(array)

reversals = findReversals(array)     % Find the reversals in the history
extracted = zeros(length(reversals),5);             % Set the size of the extracted martix
[~,maxIndex] = max(abs(reversals));                 % Find the largest value in the history

rearrangedHistory = vertcat(reversals(maxIndex:end,:),reversals(1:maxIndex,:))    % Rearrange history by placing every thing before 
                                                                        % ... the largest value at the end of the history
currentIndex = 0;                           % Set the starting index
lastIndex = size(rearrangedHistory,1)-3;    % Set the last index to compare
count = 0;                                  % Set counter for matrix indexing

    while currentIndex < lastIndex      % Loop through the history and compare the three points
        currentIndex = currentIndex + 1;   	% Increase the value of the index
        
        LRange = rearrangedHistory([currentIndex,currentIndex+3],:);      % Get the large range
        SRange = rearrangedHistory([currentIndex+1,currentIndex+2],:);    % Get the small range
        
        if LRange(1,2) > SRange(2,2) && SRange(1,2) > LRange(2,2)
            count = count + 1;                                                      % ... increase the counter
            extracted(count,:) = [transpose(SRange(:,2)),minus(SRange(2,2),SRange(1,2)),mean(SRange(:,2)),getRates(SRange)];  % ... store the values for the small range
            rearrangedHistory([currentIndex+1,currentIndex+2],:) = [];                % ... remove the small range from the history
            lastIndex = length(rearrangedHistory) - 3;                              % ... reset the lastIndex value for the newMatrix
            currentIndex = currentIndex - 1;                                        % ... decrease count to check index again
        end
    end
    
extracted(extracted(:,1)==0,:) = [];    % Remove any extra zeros in the extracted matrix
end
