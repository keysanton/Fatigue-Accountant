function peaksAndValleys = findReversals(matrix) 
% Required Matrix Form: nX2

peaksAndValleys = matrix;               % Copy original matrix

currentIndex = 1;                       % Set the starting index
lastIndex = size(peaksAndValleys,1)-1;  % Set the last index to compare

    while currentIndex < lastIndex          % Loop through the martix and compare slopes to find peaks or valleys
        currentIndex = currentIndex + 1;   	% Increase the value of the index

        previous = peaksAndValleys(currentIndex-1,2); % Get value for previous index
        current = peaksAndValleys(currentIndex,2);    % Get value for current index
        next = peaksAndValleys(currentIndex+1,2);     % Get value for next index

        if or(sign(current-previous)==sign(next-current),current == previous)   % The values are still increasing or decreasing...
            peaksAndValleys(currentIndex,:) = [];       % ... remove the current entry
            lastIndex = size(peaksAndValleys,1) - 1;    % ... reset the lastIndex value for the newMatrix
            currentIndex = currentIndex - 1;            % ... decrease count to check index again
        end 
    end
end