function forecast_SEIIRHD(timeV, X1, path)

% Input 
% timeV   time vector used as x-axis
% X1      vector containg the ODE solution 
% path    path for saving the plot obtained

% Output
%         Void function

I_a1 = X1(:, 3);
I_s1 = X1(:, 4);
H1 = X1(:, 5);
D1 = X1(:, 7);

[maxI_a1, maxdayIa1] = max(I_a1);
[maxI_s1, maxdayIs1] = max(I_s1);
[minI_a1, mindayIa1] = min(I_a1);
[minI_s1, mindayIs1] = min(I_s1);

fprintf("Max I_a: %f, day: %d \n",maxI_a1, maxdayIa1); 
fprintf("Max I_s: %f, day: %d \n", maxI_s1, maxdayIs1); 
fprintf("Min I_a: %f, day: %d \n",minI_a1, mindayIa1); 
fprintf("Min I_s: %f, day: %d \n", minI_s1, mindayIs1);
fprintf("----\n")


x0=100;
y0=100;
width=600;
height=700;
set(gcf,'position',[x0,y0,width,height]);

% I_a PLOT
subplot(2,1,1);
plot(timeV,I_a1,'r-', 'Linewidth', 1.5);hold on
plot(timeV,I_s1,'Color', '#D95319', 'Linewidth', 1.5);
xlabel('Days');ylabel('Number of individuals');
legend('I_a (forecast)', 'I_s (forecast)', ...
    'Location', 'northeast');
set(gca,'XLim',[timeV(1), timeV(501)]);
title(sprintf('SEIIRHD model forecast'));

% H PLOT
subplot(2,1,2);
plot(timeV,H1,'c-', 'Linewidth', 1.5);hold on
plot(timeV,D1,'k-', 'Linewidth', 1.5);
xlabel('Days');ylabel('Number of individuals');
legend('H (forecast)','D (forecast)',...
    'Location', 'northeast');
set(gca,'XLim',[timeV(1), timeV(501)]);
title(sprintf('SEIIRHD model forecast'));

saveas(gcf,path)




