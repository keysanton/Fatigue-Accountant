function [newArray] = countLevels(input)

array = input;
n = length(array);

index = 1;

    while index <= n
        if abs(minus(array(index,1),array(index+1,1))) ~= 1
            n = length(array);
            newArray = [array(1:index,:);zeros(1,2);array(index+1:length(array),:)];
            array = newArray;
            index = index + 2;
            continue
        end
        index = index + 1;
    end
end
