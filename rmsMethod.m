function rangeData = rmsMethod(data)

    history = findReversals(data);
    newHist = zeros(size(history,1),1);
    avg = mean(history(:,2))
    highBin = history(history(:,2) >= avg,2)
    lowBin = history(history(:,2) < avg,2)
    
    rmsHigh = rms(highBin);
    rmsLow = rms(lowBin);
    
    currentIndex = 0;
    while currentIndex < size(history,1)
        currentIndex = currentIndex + 1;
        newHist(currentIndex,1) = rmsHigh;
        currentIndex = currentIndex + 1;
    end
    newHist(newHist == 0) = rmsLow;

    n = length(newHist);
    rangeData = [newHist(1:n-1),newHist(2:n), ...
                abs(minus(newHist(2:n),newHist(1:n-1))),...
                plus(newHist(1:n-1),newHist(2:n))/2];



end