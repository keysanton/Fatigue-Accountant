function [extracted, rearrangedHistory] = hayes(array)
%HAYES Summary of this function goes here
%   Detailed explanation goes here

rev = findReversals(array)     % Find the reversals in the history
cycleHist = rev
histSize = size(cycleHist,1)
plot(cycleHist(:,1),cycleHist(:,2))
extracted = zeros(histSize,5);             % Set the size of the extracted martix
removal = zeros(histSize,1)

currentIndex = 1                           % Set the starting index
lastIndex = histSize-2    % Set the last index to compare
count = 0;                                  % Set counter for matrix indexing
oldHistSize = 0;
    
    % If the history can be reduced
    while histSize ~= oldHistSize
        
        % Set oldHistSize
        oldHistSize = histSize
        
        % Loop through the history and compare the three points
        while currentIndex < lastIndex
            
            % Increase the value of the index
            currentIndex = currentIndex + 1;   	

            % Get the value to determine peak or valley
            compVals = cycleHist([currentIndex - 1 , currentIndex + 1],2)
            currentValue = cycleHist(currentIndex,2)
            
            % Get next peak or valley
            nextPV = cycleHist(currentIndex + 2,2);

            % If the current number is a peak & it's less than the next peak
            % ... OR a valley & it's more than the next valley
            if or(and(compVals < currentValue,nextPV > currentValue),...
                  and(compVals > currentValue,nextPV < currentValue))
                % Increase the counter
                count = count + 1;  
                
                % Store the range info
                PVRange = cycleHist([currentIndex,currentIndex+1],2)
                extracted(count,:) = [transpose(PVRange),range(PVRange),mean(PVRange),getRates(cycleHist([currentIndex,currentIndex+1],:))]
                
                % Set the range to be removed from history
                removal(currentIndex:currentIndex+1) = 1;
                
                % Reset the value for the lastIndex
               % lastIndex = size(cycleHist,1) - 2
                % Increase current index to skip next index
                currentIndex = currentIndex + 1;         
            end
        end

        % Remove all extracted ranges from cycleHist
        cycleHist(removal==1,:) = [];
        plot(cycleHist(:,1),cycleHist(:,2))
        % Reset the size of the history and removal matrix
        histSize = size(cycleHist,1)
        removal = zeros(histSize,1);
        % Reset starting index and lastIndex
        currentIndex = 1
        lastIndex = histSize-2
    end
    
extracted(extracted(:,1)==0,:) = []    % Remove any extra zeros in the extracted matrix
end

