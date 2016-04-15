function extracted = rangePair(data) %Input: nx2 matrix
                                     %Output: mx5 matrix of range data
                                     
history = findReversals(data);        %Find the reversals of the data
extracted = zeros(size(history,1),5); %Set the size of the extracted matrix
count = 0;                            %Set counter for matrix indexing

    while size(history,1) >= 3            %Data must have at least three points to compare
        currentIndex = 1;                 %Set the starting index
        lastIndex = size(history,1) - 1;  %Set the last index to compare
        
        while currentIndex < lastIndex       %Loop through the history and compare points
            currentIndex = currentIndex + 1;    %Increase the index
            R1 = history([currentIndex-1,currentIndex],:);    %Define the first range
            R2 = history([currentIndex,currentIndex+1],:);    %Define the second range
            
            if range(R2(:,2)) >= range(R1(:,2))       %If the second range is larger than the first range...
                count = count + 1;          %...increase the counter                    
                extracted(count,:) = [transpose(R1(:,2)),range(R1(:,2)),mean(R1(:,2)),getRates(R1)];  %...store the values for the first range
                history([currentIndex-1,currentIndex],:) = [];    %...discard the first range from the history
                lastIndex = size(history,1) - 1;    %...reset the last index for the new matrix
                currentIndex = 1;           %...continue comparing from the beginning of the matrix
            end
        end
        
        currentIndex = length(history);     %Start from the end of the data
        
        while currentIndex > 2              %If there are points left, loop through the data backwards
            currentIndex = currentIndex - 1;    %Lower the index
            R1 = history([currentIndex+1,currentIndex],:);    %Define the first range
            R2 = history([currentIndex,currentIndex-1],:);    %Define the second range
            
            if range(R2(:,2)) >= range(R1(:,2))       %If the second range is larger than the first range...
                count = count + 1;          %...increase the counter
                extracted(count,:) = [transpose(R1(:,2)),range(R1(:,2)),mean(R1(:,2)),getRates(R1)];  %...store the values for the first range
                history([currentIndex+1,currentIndex],:) = []    %...discard the first range
                currentIndex = length(history);     %...reset the current index to the end of the matrix
            end
        end

    end
    
    if size(history,1) == 2     %If two points still remain in the history...
        count = count + 1;      %...increase the counter
        R1 = history    %...define the range
        extracted(count,:) = [transpose(R1(:,2)),range(R1(:,2)),mean(R1(:,2)),getRates(R1)];  %...store the values for the range
    end
    
extracted(extracted(:,1)==0,:) = []    %Remove any extra zeros in the extrated matrix
end
