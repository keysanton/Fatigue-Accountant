function [cycleCount, rangeCount] = countCycles(array)

[pos,neg] = extractRanges(array);

rangeData = vertcat(pos(:,3),-neg(:,3));

% Count ranges
tb1 = tabulate(rangeData);
tb2 = tabulate(abs(rangeData));

rangeCount = [tb1(:,1),tb1(:,2)/2];

cycleCount = [tb2(:,1),tb2(:,2)/2];
zero = any(cycleCount(:,2),2);
cycleCount(~zero,:) = [];

end