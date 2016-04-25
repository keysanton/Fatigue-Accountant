function newHistory = DefinedWaveforms(numCycles,data)

%TimeHistory = [time, randonValues]
TimeHistory = data
               %{ 
               [0,0 ;...
               6, 9;...
               0, 0]
                %}

           plot(TimeHistory(:,1),TimeHistory(:,2))

Points = TimeHistory(:,100)
n = size(Points,1)

    for i = (1:numCycles)
       x = (i-1)*n 
       time = [1:n]+x
      
      newHistory(x+1:x+n,:) = [time(:),Points]
      newHistory
    end
    
    plot(newHistory(:,1),newHistory(:,2))
    
end    