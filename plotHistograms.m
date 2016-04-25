function plotHistograms(input,hist3D,hist2D)

    data = input(:,3:4)

    % Plot on the histogram3DPlot and label the axes
    subplot(hist3D)
    hist3(hist3D,data);
    xlabel('Range'); ylabel('Mean'); zlabel('Cycles');
    
    % Plot on the histogram2DPlot
    
    subplot(hist2D)
    hist3(data)
    n = hist3(data); % default is to 10x10 bins
    n1 = n';
    n1(size(n,1) + 1, size(n,2) + 1) = 0;
    xb = linspace(min(data(:,1)),max(data(:,1)),size(n,1)+1);
    yb = linspace(min(data(:,2)),max(data(:,2)),size(n,1)+1);
    h = pcolor(xb,yb,n1);
    h.ZData = ones(size(n1)) * -max(max(n));
    colormap(hot) % heat map
end