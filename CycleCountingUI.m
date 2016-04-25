function CycleCountingUI
%CycleCountingUI Easy to use interface for Users
%   Detailed explanation goes here

% Begin by closing the previous figure windows
    close all

% Build UI Home screen
    % Location and Size
    fLoc = [.25,.075];
    fSize = [.5,.5];
    
    % Load window properties
    f = figure('tag','CycWin',...
            'Visible','off',...
            'Name','Fatigue Accountant',...
            'Position',[fLoc,fSize],...
            'NumberTitle','Off');

    WinPos = f.Parent.MonitorPositions;
    f.Position = [WinPos(3:4)*.25,WinPos(3:4)*.5];

% Build Panels for layout
    inputPanel = uipanel(f,...
                    'Position', [0,0,.25,1]);
    OutputFileLocationPanel = uipanel(f,...
                    'Position', [.25,0,.75,.2]);
    inputControlPanel = uipanel('Parent',inputPanel,...
                    'Position', [.10,.4,.80,.25],...
                    'Visible','off');

                
% Position the plots used in the figure
    timeHistoryPlot = axes('OuterPosition', [.25,.6,.5,.4]);
    FFTPlot = axes('OuterPosition', [.25,.2,.5,.4]);
    histogram3DPlot = axes('OuterPosition', [.75,.6,.25,.4]);
    histogram2DPlot = axes('OuterPosition', [.75,.2,.25,.4]);
    

% Construct the components
    % Text
        % Text Size and Location
            TextSize = [1,.2];
            TextLoc = [0,.8];

        % Load text properties
        Text = uicontrol(inputPanel,'Style','text',...
                'Units','normalize',...
             	'Position',[TextLoc,TextSize],...
                'String','Input Type',...
               	'FontSize',12);
    % Drop-down Menus
        DropSize = [.75,.2];
        
        % Input Options
            inputOp = uicontrol(inputPanel,'Style','popupmenu',...
                'Units','normalize',...
                'Position',[.15,.7,DropSize],...
                'String',{'Input Options','----------',...
                        'Example Waveforms',...
                        'From File',...
                        'Waveform Generator'});

            
        % Waveform Options
            waveOp = uicontrol(inputPanel,'Style','popupmenu',...
                'Units','normalize',...
                'Position',[.15,inputOp.Position(2)-.1,DropSize],...
                'String',{'Waveforms','----------'},...
                'Enable','Off');
            
            % Store Predefined Waveforms in waveOP UserData
            file = strcat(pwd,'\ExWaveData');
            [num,header,~] = xlsread(file);
            waveOp.UserData = {num,header};
            
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
                'Enable','Off');
            
        % File Input field and button
            filePanel = uicontrol(inputPanel,'Style','edit',...
                'Units','normalize',...
                'Position',[[.15 .3],[.75 .05]],...
                'Enable','Off');
            
            broswerButton = uicontrol(inputPanel,'Style','pushbutton',...
                'Units','normalize',...
                'String','Open',...
                'Position',[filePanel.Position(1)+.45 filePanel.Position(2)-.06, [.3 filePanel.Position(4)]],...
                'Enable','off');
        
                outputFileFieldOne = uicontrol(OutputFileLocationPanel,'Style','edit',...
                'Units','pixels',...
                'Position',[115 3 300 20])
            
            outputFileFieldTwo = uicontrol(OutputFileLocationPanel,'Style','edit',...
                'Units','pixels',...
                'Position',[115 28 300 20])
            
            outputFileFieldThree = uicontrol(OutputFileLocationPanel,'Style','edit',...
                'Units','pixels',...
                'Position',[115 53 300 20])
            
            outputBrowserButtonOne = uicontrol(OutputFileLocationPanel,'Style','pushbutton',...
                'Units','pixels',...
                'String','Save Graph',...
                'Position',[10 outputFileFieldOne.Position(2) 100 outputFileFieldOne.Position(4)])
            
            outputBrowserButtonTwo = uicontrol(OutputFileLocationPanel,'Style','pushbutton',...
                'Units','pixels',...
                'String','Save Histogram',...
                'Position',[10 outputFileFieldTwo.Position(2) 100 outputFileFieldTwo.Position(4)])
            
            outputBrowserButtonThree = uicontrol(OutputFileLocationPanel,'Style','pushbutton',...
                'Units','pixels',...
                'String','Save Data',...
                'Position',[10 outputFileFieldThree.Position(2) 100 outputFileFieldThree.Position(4)])
            
            outputBrowserButtonThree = uicontrol(OutputFileLocationPanel,'Style','pushbutton',...
                'Units','pixels',...
                'String','Save All',...
                'Position',[420 3 70 70])
            
            
        % Set Callbacks
        inputOp.Callback = {@inputOp_Callback,{cycleOp,timeHistoryPlot,filePanel,broswerButton,waveOp,FFTPlot}};
        cycleOp.Callback = {@cycleOp_Callback,{inputControlPanel,histogram3DPlot,histogram2DPlot}};
        broswerButton.Callback = {@fileSelection_Callback,{filePanel,cycleOp,timeHistoryPlot,FFTPlot}};
        
% Make the UI visible.
    f.Visible = 'on';
end

% Callback Functions
    % Input Option Callback
function inputOp_Callback(handle,data,CBPara)

    % Enable all Cycle Counting Options 
    cycleOp = CBPara{1};
    timeHistoryPlot = CBPara{2};
    filePanel = CBPara{3};
    broswerButton = CBPara{4};
    waveOp = CBPara{5};
    FFTPlot = CBPara{6}

    filemenu = [filePanel;broswerButton];

    % Determine which button was pressed
    selection = handle.Value;
    selected = handle.String{selection};

	if selection > 2    
        % Enable the appropriate fields
        if strcmp(selected,'From File')
            set(filemenu,'Enable','on');
            waveOp.Enable = 'off';
            cycleOp.Enable = 'on';
        else
            if strcmp(selected,'Example Waveforms')
                set(filemenu,'Enable','off');
                waveOp.Enable = 'on';
                cycleOp.Enable = 'on';
            else
                set(filemenu,'Enable','off')
                waveOp.Enable = 'off';
                cycleOp.Enable = 'off';
            end
        end
        
        switch selected
            case 'Example Waveforms'
                % Load Options and turn on Waveform Selection
                    % Extract Heading from Waveform File
                    num = waveOp.UserData(1);
                    header = waveOp.UserData{2};
                    
                    % Load waveform headings Wave Options
                    empty = cellfun(@isempty,header);
                    waveTitles = header(~empty);
                    waveOp.String = [waveOp.String;waveTitles(:)];
                    
                    % Setup Callback
                    waveOp.Callback = {@waveOp_Callback,{num,header,timeHistoryPlot,cycleOp,FFTPlot}};
                    
            case 'From File'
                

            
            case 'Waveform Generator' 
                % Create random data and store it in the
                % Userdata of cycle options
                ranData = randomnumberfactory;
                cycleOp.UserData = ranData;
                %cycleOp.Enable = 'on'
            
        end
    else
        allControls = [filemenu;waveOp;cycleOp];
        set(allControls,'Enable','off');
	end
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
            if str2double(handle.String) > slider.Max
                slider.Value = slider.Max
                handle.String = num2str(slider.Value)
            else
                slider.Value = str2double(handle.String)
            end
    end
                    lvl = slider.Value;
                    func = otherObject{5}
                output = func(otherObject{2},lvl);
                
                plotHistograms(output,otherObject{3},otherObject{4})

end

function fileSelection_Callback(handle,data,CBPara)

    % Extract UIcontrols
    fileTxt = CBPara{1}
    cycleOp = CBPara{2}
    timeHistoryPlot = CBPara{3}
    FFTPlot = CBPara{4}

    % Open the file navigation system to look for Excel file
        [filename,path] = uigetfile({'*.xls;*.xlsx;*.xlsm;*.xltx;*.xltm',...
                        'Excel Files (*.xls,*.xlsx,*.xlsm,*.xltx,*.xltm)'},'File Selector');
                    
    % Combine the filename and path into one string
        file = strcat(path,filename);
    
    % Extract the data from the file
        [num,header,data] = xlsread(file);
        
    % Input file name in filePanel field   
        fileTxt.String = filename
        
    % Extract the columns from the data & remove entries that are NaN
        columnOfValues = num(1:end,1:2);
        isF = isfinite(columnOfValues);
        finiteValues = columnOfValues(isF(:,1),:);

    
    % Store values is USerData
        cycleOp.UserData = finiteValues
    
    % Plot the time history
            subplot(timeHistoryPlot);
            plot(finiteValues(:,1),finiteValues(:,2));
            
     % Plot the FFT
            subplot(FFTPlot);
            Fs = size(finiteValues,1)
            if mod(Fs,2)==0
                L = Fs
            else
                L = Fs + 1
            end
            
            Y = fft(finiteValues(:,2))
            P2 = abs(Y/L);
            P1 = P2(1:L/2+1);
            P1(2:end-1) = 2*P1(2:end-1);
            f = Fs*(0:(L/2))/L;
            plot(f,P1)
        
end

function waveOp_Callback(handle,data,CBPara)
    
    % Determine which button was pressed
    selection = handle.Value;
    selected = handle.String{selection};
    
    if selection > 2
        % Extract the spreedsheet data
        numbers = CBPara{1}{:};
        header = CBPara{2};
        timeHistoryPlot = CBPara{3};
        cycleOp = CBPara{4}
        FFTPlot = CBPara{5}

        % Find the location of the selected option
        [row,col] = find(strcmp(header,selected));

        % Extract the columns from the data & remove entries that are NaN
        columnOfValues = numbers(:,col:col+1);
        isF = isfinite(columnOfValues);
        finiteValues = columnOfValues(isF(:,1),:);

        % Store the data in UserData of the dropdown
        cycleOp.UserData = finiteValues;

        % Plot the time history
            subplot(timeHistoryPlot);
            plot(finiteValues(:,1),finiteValues(:,2));
            
        % Plot the FFT
            subplot(FFTPlot);
            Fs = size(finiteValues,1)
            L = Fs
            Y = fft(finiteValues(:,2))
            P2 = abs(Y/L);
            P1 = P2(1:L/2+1);
            P1(2:end-1) = 2*P1(2:end-1);
            f = Fs*(0:(L/2))/L;
            plot(f,P1)
    end
end

% Cycle Option Callback
function cycleOp_Callback(handle,data,CBPara)

    % Create random data and store it in the RandomNumB Userdata
    inputControlPanel = CBPara{1}
    histogram3DPlot = CBPara{2}
    histogram2DPlot = CBPara{3}
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
                
                maxNum = max(data(:,2))
                slider = uicontrol(inputControlPanel,'Style', 'slider',...
                            'Min',0,'Max',maxNum,'Value',maxNum*.1,...
                            'SliderStep',[0.02,0.1],...
                            'Position', [0 0 60 20])
                sliderTxt = uicontrol(inputControlPanel,'Style', 'edit',...
                            'String',slider.Value,...
                            'Position', [60 0 40 20])
                
                slider.Callback = {@slideNumber,{sliderTxt,data,histogram3DPlot,histogram2DPlot,@levelCrossing}}
                sliderTxt.Callback = {@slideNumber,{slider,data,histogram3DPlot,histogram2DPlot}}
                
                % Preform initial data analysis
                lvl = slider.Value;
                output = levelCrossing(data,lvl);
                n = length(output);
                cycle = [zeros(n,2),output];
                
            case '3-Point Rainflow'
                cycle = rainflow3p(data);
            case '4-Point Rainflow'
                cycle = rainflow4p(data);
            case 'Racetrack'
                maxNum = max(data(:,2))
                slider = uicontrol(inputControlPanel,'Style', 'slider',...
                            'Min',0,'Max',maxNum,'Value',maxNum*.1,...
                            'SliderStep',[0.02,0.1],...
                            'Position', [0 0 60 20])
                sliderTxt = uicontrol(inputControlPanel,'Style', 'edit',...
                            'String',slider.Value,...
                            'Position', [60 0 40 20])
                
                slider.Callback = {@slideNumber,{sliderTxt,data,histogram3DPlot,histogram2DPlot,@racetrack}}
                sliderTxt.Callback = {@slideNumber,{slider,data,histogram3DPlot,histogram2DPlot}}
                
                % Preform initial data analysis
                lvl = slider.Value;
                output = racetrack(data,lvl);
                n = length(output);
                cycle = [zeros(n,2),output];

            case 'Hayes Method'
                cycle = hayes(data);
            case 'Range Pair'
                cycle = rangePair(data);
            case 'RMS Method'
                cycle = rmsMethod(data);
        end
        
    % Extract range and mean data for display  
    plotHistograms(cycle,histogram3DPlot,histogram2DPlot)
    
    end
    

end


