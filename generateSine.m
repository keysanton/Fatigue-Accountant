function generateSine
    x=[0.1:0.1:20]
    step1=0:2:200
    step2=1:2:200
    A=1;B=2;
    f1=1;f2=3;
    
    
    
    for t = 1:200
        y(t)=A*sin(f1*t)+B*sin(f2*t/10);
    %{
        if any(step2(:) == floor(t/50))
            y(t) = A*sin(f1*t/10)+B*sin(f2*t/10)+10;
        else
            y(t) = A*sin(f1*t/10)+B*sin(f2*t/10)-10;
        end
         %}
    end
   
    plot(x,y)
end