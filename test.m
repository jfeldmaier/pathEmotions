t = (0:0.001:0.5)';
y = 1*square(2*pi*2*t);
y2 = zeros(1,length(y));

% t = 1:1:80;
% y(1:20) = 1;
% y(21:50) = -1;
% y(51:80) =1;
% y2 = zeros(1,length(y));

% t = 1:1:length(output.right_dir);
% y = output.right_dir;
% y2 = zeros(1,length(y));

for i = 1:length(y)
    
    if y(i) == 0
        break
    end
    
    if i == 1
        y2(1) = 0.01*y(1);
    elseif y(i) == -1
        y2(i) = y2(i-1) * 0.7;
    else
%        y2(i) = y2(i-1)^0.5;
        % sigmoid(y2(i-1))
         y2(i) = 6.3 ./ (1.0 + 0.1*exp(-(y2(i-1)-5)));

    end
    
    
end

figure;
plot(t(1:i),y(1:i),t(1:i),y2(1:i))

    