function [rangeData,newHistory] = peakValleyCounting(array)

% OUTPUT
% Column 1,2 - Range Bounds
% Column 3 - Range Value
% Column 4 - Mean of Range
% Column 5 - NEED TO FIND A WAY TO RELATE --> Rate of Range

reversals = findReversals(array)

pos = reversals(reversals>0)
neg = reversals(reversals<=0)

% Sort range from largest to smallest
posSorted = sort(pos,'descend');    % largest postive 
negSorted = sort(neg);              % largest negative

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
    
    for i = 1:n     % Loop through and pair the numbers
        newHistory(2*i-1,:) = first(i,:);
        newHistory(2*i,:) = second(i,:);
    end

    if length(pos) ~= length(neg)           % If the bins are NOT the same size...
        newHistory(2*n+1) = first(n+1)     % ...add the last entry of the first bin...
    end
    
    rangeData = [newHistory(1:n-1),newHistory(2:n), ...           % Load range values...
                minus(newHistory(2:n),newHistory(1:n-1)),...  % ... the range
                plus(newHistory(1:n-1),newHistory(2:n))/2],...    % ... and the mean

            %{    
rangeTab = tabulate(newHistory)	% Store range frequencies
rangeCount = rangeTab(:,1:2)     	% Store range counts
%}
%{
cycleTab = tabulate(abs(newHistory));           % Store absoulte values of range frequencies
cycleCount = [cycleTab(:,1),cycleTab(:,2)/2];   % Store cycle counts 
cycleCount(cycleCount(:,2)==0,:) = [];           % Remove zeros from count
%}
end