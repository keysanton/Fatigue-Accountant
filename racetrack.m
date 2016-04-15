function [rangeData] = racetrack(array,width)

history = findReversals(array)
n = size(history,1);
val = zeros(n,1)
val([1,n]) = 1
counter = 2;
s = width;
lowHist = [history(:,2) - (0.5*s)]
highHist = [history(:,2) + (0.5*s)]
plot(history(:,1),history(:,2),history(:,1),lowHist,history(:,1),highHist);

if history(2,2)>history(1,2)
    dir = 1;
else
    dir = -1;
end

while counter<n-1
    if dir == 1
        if lowHist(counter) < highHist(counter+1)
            counter = counter + 2;
        else
            dir = -1;
            val(counter) = 1;
            counter = counter + 1;
        end
    
    else
        if highHist(counter) > lowHist(counter+1)
            counter = counter + 2;
        else
            dir = 1;
            val(counter) = 1;
            counter = counter + 1;
        end
    end
end

val = logical(val);
newHist = history(val,:)
extractedHist = history(~val,:)
n = size(newHist,1);

plot(newHist(:,1),newHist(:,2))
rangeData = [newHist(1:n-1,2),newHist(2:n,2), ...
                minus(newHist(2:n,2),newHist(1:n-1,2)),...
                plus(newHist(1:n-1,2),newHist(2:n,2))/2,...
                getRates(newHist)]

end