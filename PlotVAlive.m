function PlotVAlive(output, i)

subplot(3,2,3:4); 
plot(1:i, output.A(1:i),'r')
title('Arousal')

subplot(3,2,5:6); 
plot(1:i, output.V(1:i))
title('Valence')