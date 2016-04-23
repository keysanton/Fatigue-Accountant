function CycleCountingUI
%CycleCountingUI Easy to use interface for Users
%   Detailed explanation goes here

% Begin by closing the previous figure windows
    close all

% Build UI Home screen
    % Location and Size
    fLoc = [.25,.075]
    fSize = [.5,.5]
    
    % Load window properties
    f = figure('tag','CycWin',...
            'Visible','off',...
            'Name','Fatigue Accountant',...
            'Position',[fLoc,fSize],...
            'NumberTitle','Off');
    % ADD THIS LATER TO HIDE UI --> 'Visible','off'
    f.Visible = 'off'
    get(f,'Name')

    WinPos = f.Parent.MonitorPositions
    f.Position = [WinPos(3:4)*.25,WinPos(3:4)*.5]

% Build Panels for layout
    inputPanel = uipanel(f,...
                    'Position', [0,0,.25,1])
    OutputFileLocationPanel = uipanel(f,...
                    'Position', [.25,0,.75,.2])
    inputControlPanel = uipanel('Parent',inputPanel,...
                    'Position', [.10,.4,.80,.25],...
                    'Visible','off')

                
% Position the plots used in the figure
    timeHistoryPlot = axes('OuterPosition', [.25,.6,.5,.4])
    frequencyResponsePlot = axes('OuterPosition', [.25,.2,.5,.4])
    histogram3DPlot = axes('OuterPosition', [.75,.6,.25,.4])
    histogram2DPlot = axes('OuterPosition', [.75,.2,.25,.4])
    

% Construct the components
    % Text
        % Text Size and Location
            TextSize = [1,.2]
            TextLoc = [0,.8]

        % Load text properties
        Text = uicontrol(inputPanel,'Style','text',...
                'Units','normalize',...
             	'Position',[TextLoc,TextSize],...
                'String','Input Type',...
               	'FontSize',12);
    % Drop-down Menus
        DropSize = [.75,.2]
        
        % Input Options
            inputOp = uicontrol(inputPanel,'Style','popupmenu',...
                'Units','normalize',...
                'Position',[.15,.7,DropSize],...
                'String',{'Input Options','----------',...
                        'Example Waveforms',...
                        'From File',...
                        'Waveform Generator'})

            
        % Waveform Options
            waveOp = uicontrol(inputPanel,'Style','popupmenu',...
                'Units','normalize',...
                'Position',[.15,inputOp.Position(2)-.1,DropSize],...
                'String',{'Waveforms','----------'},...
                'Enable','Off')
            
         % Cycle Counting Options
            cycleOp = uicontrol(inputPanel,'Style','popupmenu',...
                'Units','normalize',...
                'Position',[.15,waveOp.Position(2)-.1,DropSize],...
                'String',{'Counting Method','----------',...
                        'Simple Range',...
                        'Peak Valley Counting',...
                        'Level Crossing',...
                        '3-Point Rainflow',...
                        '4-Point Rainflow',...
                        'Racetrack',...
                        'Hayes Method',...
                        'Range Pair',...
                        'RMS Method'},...
                'Enable','Off')
            
        % File Input field and button
            filePanel = uicontrol(inputPanel,'Style','edit',...
                'Units','pixels',...
                'Position',[15,0,DropSize],...
                'Enable','Off')
            filePanel.Units = 'normalize'
            filePanel.Position(2) = .3
            filePanel.Units = 'pixels'
            
            broswerButton = uicontrol(inputPanel,'Style','pushbutton',...
                'Units','pixels',...
                'String','O',...
                'Position',[140 filePanel.Position(2) filePanel.Position(4) filePanel.Position(4)],...
                'Enable','off')
        
        % Set Callbacks
        inputOp.Callback = {@inputOp_Callback,{cycleOp,timeHistoryPlot,filePanel,broswerButton,waveOp}}
        cycleOp.Callback = {@cycleOp_Callback,{inputControlPanel,histogram3DPlot}}
        broswerButton.Callback = {@fileSelection_Callback,filePanel}
        
% Make the UI visible.
    f.Visible = 'on';
end

% Callback Functions
    % Input Option Callback
    function inputOp_Callback(handle,data,CBPara)
        
        % Enable all Cycle Counting Options 
        cycleOp = CBPara{1}
        timeHistoryPlot = CBPara{2}
        filePanel = CBPara{3}
        broswerButton = CBPara{4}
        waveOp = CBPara{5}
        
        
        % Determine which button was pressed
        selection = handle.Value
        selected = handle.String{selection}
        
    if selection > 2
        
        filemenu = [CBPara{3},CBPara{4}]
        
        if strcmp(selected,'From File')
            filemenu.Enable = 'on'
            filePanel.Enable = 'on'
            broswerButton.Enable = 'on'
        else
            set(filemenu,'Enable','off')
            filePanel.Enable = 'off'
            broswerButton.Enable = 'off'
        end
        
        switch selected
            case 'Example Waveforms'
                % Load Options and turn on Waveform Selection
                    % Extract Heading from Waveform File
                    file = 'C:\Users\Anton Keys\Desktop\Focus Group\MATLAB\ExWaveData'
                    [num,header,~] = xlsread(file)
                    
                    % Load waveform headings Wave Options
                    empty = cellfun('isempty',header)
                    waveTitles = header(~empty)
                    waveOp.String = [waveOp.String;waveTitles(:)]
               
                    % Turn the WaveForm Options on
                    waveOp.Enable = 'on'
                
                    % Setup Callback
                    waveOp.Callback = {@waveOp_Callback,{num,header,timeHistoryPlot}}
                    
            case 'Waveform Generator' 
                % Create random data and store it in the
                % Userdata of cycle options
                ranData = randomnumberfactory
                cycleOp.UserData = ranData
                cycleOp.Enable = 'on'
            %    filePanel.Enable = 'off'
             %   broswerButton.Enable = 'off'
            case 'From File'
                cycleOp.Enable = 'on'
                % Enable the file controls
             %   filePanel.Enable = 'on'
              %  broswerButton.Enable = 'on'
        end
    end
    
        % Create random data and store it in the
        % Userdata of cycle options
        ranData = randomnumberfactory
        cycleOp.UserData = ranData
        
        % Plot the time history
        subplot(timeHistoryPlot)
        plot(ranData(:,1),ranData(:,2))
        
    end
    
    % Cycle Option Callback
function cycleOp_Callback(handle,data,CBPara)

    % Create random data and store it in the RandomNumB Userdata
    inputControlPanel = CBPara{1}
    histogram3DPlot = CBPara{2}
    data = handle.UserData

    % Determine which button was pressed
    selection = handle.Value
    selected = handle.String{selection}
    
                    

    if selection > 2
        
        if any([5,8] == selection)
            inputControlPanel.Visible = 'on'
        else
            inputControlPanel.Visible = 'off'
        end
        
        switch selected
            case 'Simple Range'
                cycle = simpleRange(data);
            case 'Peak Valley Counting' 
                cycle = peakValleyCounting(data);
            case 'Level Crossing'
                slider = uicontrol(inputControlPanel,'Style', 'slider',...
                            'Min',0,'Max',50,'Value',5,...
                            'SliderStep',[0.02,0.1],...
                            'Position', [0 0 60 20])
                sliderTxt = uicontrol(inputControlPanel,'Style', 'edit',...
                            'String','5',...
                            'Position', [60 0 40 20])
                
                slider.Callback = {@slideNumber,{sliderTxt,data}}
                sliderTxt.Callback = {@slideNumber,{slider,data}}
                
               % axes('Parent',histogram3DPlot,...
                %    'OuterPosition',[0,0,1,1])
                lvl = slider.Value;
                output = levelCrossing(data,lvl);
                n = length(output);
                cycle = [zeros(n,2),output];
                
            case '3-Point Rainflow'
                cycle = rainflow3p(data);
            case '4-Point Rainflow'
                cycle = rainflow4p(data);
            case 'Racetrack'
                width = 5;%NOTE: change for UI
                cycle = racetrack(data,width);
            case 'Hayes Method'
                cycle = hayes(data);
            case 'Range Pair'
                cycle = rangePair(data);
            case 'RMS Method'
                cycle = rmsMethod(data);
        end
    end
    
    % Extract range and mean data for display
    rangeAndMean = cycle(:,3:4)
    
    % Plot on the histogram3DPlot and label the axes
    subplot(histogram3DPlot)
    hist3(histogram3DPlot,[rangeAndMean(:,1),rangeAndMean(:,2)]);
    xlabel('Range'); ylabel('Mean'); zlabel('Cycles');
end
    
function slideNumber(handle,data,otherObject)

    % Determine if the handle is to the slider or the text box
    controlType = handle.Style
    
    % Change the value of the slide to that of the text box
    switch controlType
        case 'slider'
            slider = handle
            otherObject{1}.String = num2str(slider.Value)
            
        case 'edit'
            slider = otherObject{1}
            if str2num(handle.String) > slider.Max
                slider.Value = slider.Max
                handle.String = num2str(slider.Value)
            else
                slider.Value = str2num(handle.String)
            end
    end
                    lvl = slider.Value;
                output = levelCrossing(otherObject{2},lvl);
                n = length(output);
                cycle = [zeros(n,2),output];
                displayHistogram(cycle);

end

function fileSelection_Callback(handle,data,CBPara)

    % Extract UIcontrols
    filePanel = CBPara

    % Open the file navigation system to look for Excel file
        [filename,path] = uigetfile({'*.xls;*.xlsx;*.xlsm;*.xltx;*.xltm',...
                        'Excel Files (*.xls,*.xlsx,*.xlsm,*.xltx,*.xltm)'},'File Selector');
                    
    % Combine the filename and path into one string
        file = strcat(path,filename);
    
    % Extract the data from the file
        [num,header,data] = xlsread(file);
        
    % Input file name in filePanel field   
        filePanel.String = file
end

function waveOp_Callback(handle,data,CBPara)
    
    % Determine which button was pressed
    selection = handle.Value;
    selected = handle.String{selection};
    
    % Extract the spreedsheet data
    numbers = CBPara{1};
    header = CBPara{2};
    timeHistoryPlot = CBPara{3};
    
    % Find the location of the selected option
    [row,col] = find(strcmp(header,selected));
    
    % Extract the columns from the data & remove entries that are NaN
    columnOfValues = numbers(:,col:col+1);
    isF = isfinite(columnOfValues);
    finiteValues = columnOfValues(isF(:,1),:);
    
    % Store the data in UserData of the dropdown
    handle.UserData = finiteValues;
    
    % Plot the time history
        subplot(timeHistoryPlot);
        plot(finiteValues(:,1),finiteValues(:,2));
end

function plotWindow(handle,data,CBPara)

    figure
    handle

end
