function displayHistogram(handle,data)


    rangeAndMean = handle.userdata{1}     % Extract range and mean data for display
    hist3([rangeAndMean(:,1),rangeAndMean(:,2)]);            % Create 3D histogram
    xlabel('Range'); ylabel('Mean'); zlabel('Cycles');   % Label axes
end