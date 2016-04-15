function Example
options = ['1)Level    ';...
           '2)Range    ';...
           '3)Racetrack']
        
formatString = '%s\n'

for i = 1:size(options,1)
fprintf(formatString,options(i,:))
end

x = input('Which number?\n')

end