in = test;

w = 0;

gamma = 0.1;

out = zeros(1,length(in));

for i = 1:length(in)
    
    w = w + (in(i) - w) * 0.1;
    
    out(i) = w;
    
end