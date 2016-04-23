function displayHistogram(data)


    rangeAndMean = data(:,3:4)     % Extract range and mean data for display
    hist3([rangeAndMean(:,1),rangeAndMean(:,2)]);            % Create 3D histogram
    xlabel('Range'); ylabel('Mean'); zlabel('Cycles');   % Label axes
end