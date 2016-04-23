function [rangeData] = levelCrossing(array,lvl)


history = findReversals(array);
lvlSize = lvl;

n = length(history);

high = floor(max(history(:,2))/lvlSize);  % Build lvlCount matrix
low = floor(min(history(:,2))/lvlSize);
x = low:high;
lvlCount = [x(:),zeros(high-low+1,1)];

for i = 2:n   % Iterate from the first number to the 2nd to last

    start = floor(history(i-1,2)/lvlSize);  % Determine where to start counting levels
    
    if history(i,2) > 0     % If the current value is positive...
        finish = floor(history(i,2)/lvlSize);   % ... determine the highest level that is crossed
        if history(i-1,2) < 0           % If the range starts at a negative number
            count = 0;          % ... begin the count at 0
        else
            count = start + 1;  % ... otherwise start at the first level that was crossed
        end
        while count <= finish   % Loop until all positive levels in range are counted
            lvlCount(lvlCount(:,1) == count,2) = lvlCount(lvlCount(:,1) == count,2) + 1;    % Find the level in the lvlCount martix and add 1 to it
            count = count + 1;  % Continue to next highest level
        end
    else            % ... otherwise, it is negative
        finish = ceil(history(i,2)/lvlSize); % ... determine the lowest level that is crossed
        if history(i-1,2) > 0           % If the range starts at a positive number
            count = -1;         % ... begin the count at -i
        else
            count = start;      % ... otherwise start at the first level that was crossed
        end
        while count >= finish   % Loop until all negative levels in range are counted
            lvlCount(lvlCount(:,1) == count,2) = lvlCount(lvlCount(:,1) == count,2) + 1;	% Find the level in the lvlCount martix and add 1 to it
            count = count - 1;  % Continue to next lowest level
        end
    end
end

lvlCount(lvlCount(:,2)==0,:) = [];  % Remove zeros from lvlCount matrix
reconstruct = lvlCount;             % Copy lvlCount into reconstruction matrix


n = max(reconstruct(:,2));  % Preallocate rangeData
rangeData = zeros(n,2);

m = sum(reconstruct(:,2));  % Preallocate newHistory
newHistory = zeros(m,2);

    index = 0;  % Start index at zero
    for i = 1:n


        rPos = sum(reconstruct(:,1)>0,1);
        high = reconstruct(reconstruct(:,1)>0,1);
        for j = 1:rPos
            index = index + 1;
            newHistory(index,:) = [index,high(j)];
        end

        rNeg = sum(reconstruct(:,1)<=0);
        low = reconstruct(reconstruct(:,1)<=0,1);
        for j = 1:rNeg
            index = index + 1;
            newHistory(index,:) = [index,low(j)];
        end
        reconstruct(:,2) = reconstruct(:,2) - 1;
        reconstruct(reconstruct(:,2)==0,:) = [];
        
        rangeData(i,:) = [range(reconstruct(:,1)),mean(reconstruct(:,1))];


    end
    
end