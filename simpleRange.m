function [rangeData,rangeCount,cycleCount] = simpleRange(array)

reversals = findReversals(array);  % Find the reversals in the history

n = size(reversals,1);   % Determine the size of the history

rangeData = [reversals(1:n-1),reversals(2:n), ...           % Load range values...
                minus(reversals(2:n),reversals(1:n-1)),...  % ... the range
                plus(reversals(1:n-1),reversals(2:n))/2];    % ... and the mean

rangeTab = tabulate(rangeData(:,3));	% Store range frequencies
rangeCount = rangeTab(:,1:2);          	% Store range counts

cycleTab = tabulate(abs(rangeData(:,3)));       % Store absoulte values of range frequencies
cycleCount = [cycleTab(:,1),cycleTab(:,2)/2];   % Store cycle counts 
cycleCount(cycleCount(:,2)==0,:) = [];           % Remove zeros from count
end