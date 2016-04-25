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
    timeHistoryPanel = uipanel(f,...
                    'Position', [.25,.6,.5,.4])
    frequencyResponsePanel = uipanel(f,...
                    'Position', [.25,.2,.5,.4])
    OutputFileLocationPanel = uipanel(f,...
                    'Position', [.25,0,.75,.2])
    histogram3DPanel = uipanel(f,...
                    'Position', [.75,.6,.25,.4])
    histogram2DPanel = uipanel(f,...
                    'Position', [.75,.2,.25,.4])
    inputControlPanel = uipanel('Parent',inputPanel,...
                    'Position', [.10,.4,.80,.25],...
                    'Visible','off')  

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
        DropSize = [120,20]
        
        % Input Options
            inputOp = uicontrol(inputPanel,'Style','popupmenu',...
                'Units','pixels',...
                'Position',[15,0,DropSize],...
                'String',{'Input Options','----------',...
                        'Waveforms',...
                        'From File',...
                        'Waveform Generator'})
            
            inputOp.Units = 'normalize'
            inputOp.Position(2) = .8
            inputOp.Units = 'pixels'
            
         % Cycle Counting Options
            cycleOp = uicontrol(inputPanel,'Style','popupmenu',...
                'Units','pixels',...
                'Position',[15,0,DropSize],...
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
            
            cycleOp.Units = 'normalize'
            cycleOp.Position(2) = .7
            cycleOp.Units = 'pixels'
     
            outputFileFieldOne = uicontrol(OutputFileLocationPanel,'Style','edit',...
                'Units','pixels',...
                'Position',[75 3 400 20])
            
            outputFileFieldTwo = uicontrol(OutputFileLocationPanel,'Style','edit',...
                'Units','pixels',...
                'Position',[75 28 400 20])
            
            outputFileFieldThree = uicontrol(OutputFileLocationPanel,'Style','edit',...
                'Units','pixels',...
                'Position',[75 53 400 20])
            
            outputBrowserButtonOne = uicontrol(OutputFileLocationPanel,'Style','pushbutton',...
                'Units','pixels',...
                'String','O',...
                'Position',[outputFileFieldOne.Position(1)-25 outputFileFieldOne.Position(2) outputFileFieldOne.Position(4) outputFileFieldOne.Position(4)])
            
            outputBrowserButtonTwo = uicontrol(OutputFileLocationPanel,'Style','pushbutton',...
                'Units','pixels',...
                'String','O',...
                'Position',[outputFileFieldTwo.Position(1)-25 outputFileFieldTwo.Position(2) outputFileFieldTwo.Position(4) outputFileFieldTwo.Position(4)])
            
            outputBrowserButtonThree = uicontrol(OutputFileLocationPanel,'Style','pushbutton',...
                'Units','pixels',...
                'String','O',...
                'Position',[outputFileFieldThree.Position(1)-25 outputFileFieldThree.Position(2) outputFileFieldThree.Position(4) outputFileFieldThree.Position(4)])
            
     
        % Set Callbacks
        inputOp.UserData = {cycleOp,timeHistoryPanel}
        inputOp.Callback = @inputOp_Callback
        cycleOp.UserData = {inputControlPanel}
        cycleOp.Callback = @cycleOp_Callback
        
% Make the UI visible.
    f.Visible = 'on';
end

% Callback Functions
    % Random Number Callback
    function inputOp_Callback(handle,data)
        
        % Enable all Cycle Counting Options 
        cycleOp = handle.UserData{1}
        timeHistoryPanel = handle.UserData{2}
        cycleOp.Enable = 'on'
        
        % Create random data and store it in the
        % Userdata of cycle options
        ranData = randomnumberfactory
        cycleOp.UserData{2} = ranData
        
        % Define axes for plot within panel
        timePlot = axes('Parent',timeHistoryPanel,...
                    'Position',[0,0,1,1])
        plot(ranData(:,1),ranData(:,2))
        
    end
    
    % Random Number Callback
function cycleOp_Callback(handle,data)

    % Create random data and store it in the RandomNumB Userdata
    inputControlPanel = handle.UserData{1}
    data = handle.UserData{2}

    % Determine which button was pressed
    selection = handle.Value
    selected = handle.String{selection}

    if selection > 2
        
        if selection == or(5,8)
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
                lvl = .1;%NOTE: change for UI
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
  
% Build UI Home screen
    % Location and Size
    DisLoc = [700,50]
    DisSize = [600,560]
    
    % Load window properties
    dis = figure('tag','DisWin',...
            'Visible','off',...
            'Name',selected,...
            'Position',[DisLoc,DisSize],...
            'NumberTitle','Off');
    
    displayHistogram(cycle);
            
    % Make the UI visible.
    dis.Visible = 'on';
    end

