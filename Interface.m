function Interface 

dataType = ['1)Open File  ';...
            '2)Random Data'];
n = size(dataType,1);
    for i = 1:n
        fprintf('%s\n',dataType(i,:));
    end
option = input('What is the type of data to be used?\n');
    switch option
        case 1
            data = openFile;
        case 2
            data = randomnumberfactory;
    end
cycleOption=['1)Simple Range        ';... % Updated
             '2)Peak Valley Counting';... % Undetermined
             '3)Level Crossing      ';... % NEEDS WORK FOR HISTOGRAM
             '4)3-Point Rainflow    ';... % Updated 
             '5)4-Point Rainflow    ';... % Updated  
             '6)Racetrack           ';... % Updated 
             '7)Hayes Method        ';... % Updated 
             '8)Range Pair          ';... % Updated 
             '9)RMS Method          ';];  % NEED TO UPDATE
n = size(cycleOption,1);
    for i = 1:n
        fprintf('%s\n',cycleOption(i,:));
    end
option = input('What technique of cycle counting will be used?\n');
    switch option
        case 1
            cycle = simpleRange(data);
        case 2 
            cycle = peakValleyCounting(data);
        case 3
            lvl = .1;%NOTE: change for UI
            output = levelCrossing(data,lvl);
            n = length(output);
            cycle = [zeros(n,2),output];
        case 4
            cycle = rainflow3p(data);
        case  5
            cycle = rainflow4p(data);
        case  6
            width = 5;%NOTE: change for UI
            cycle = racetrack(data,width);
        case  7
            cycle = hayes(data);
        case  8
            cycle = rangePair(data);
        case  9
            cycle = rmsMethod(data);
    end
displayHistogram(cycle);
end