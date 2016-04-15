function [extracted, rearrangedHistory] = rainflow3p(array)

reversals = findReversals(array)     % Find the reversals in the history
extracted = zeros(length(reversals),5);             % Set the size of the extracted martix
[~,maxIndex] = max(abs(reversals(:,2)))                 % Find the largest value in the history

rearrangedHistory = vertcat(reversals(maxIndex:end,:),reversals(1:maxIndex,:))    % Rearrange history by placing every thing before 
                                                                        % ... the largest value at the end of the history
currentIndex = 0;                           % Set the starting index
lastIndex = size(rearrangedHistory,1)-2    % Set the last index to compare
count = 0;                                  % Set counter for matrix indexing

    while currentIndex < lastIndex      % Loop through the history and compare the three points
        currentIndex = currentIndex + 1   	% Increase the value of the index
        R1 = rearrangedHistory([currentIndex,currentIndex+1],:)      % Get the first range
        R2 = rearrangedHistory([currentIndex+1,currentIndex+2],:)    % Get the second range

        if range(R1(:,2)) <= range(R2(:,2))   % If the first range is smaller than the second
            count = count + 1                                          % ... increase the counter
            
            extracted(count,:) = [transpose(R1(:,2)),range(R1(:,2)),mean(R1(:,2)),getRates(R1)]	% ... store the values for the first range
            rearrangedHistory([currentIndex,currentIndex+1],:) = []      % ... remove the first range from the history
            lastIndex = size(rearrangedHistory,1) - 2                 % ... reset the lastIndex value for the newMatrix
            currentIndex = currentIndex - 1;                            % ... decrease count to check index again
        end
    end
    
extracted(extracted(:,1)==0,:) = []    % Remove any extra zeros in the extracted matrix
end
