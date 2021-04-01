function forecast_SEIIRHD(timeV, X1, dates, path)

% Input 
% timeV   time vector used as x-axis
% X1      vector containg the ODE solution 
% dates   tove vector with all the dates
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

t1 = find(dates=="01-Jun-2021"); 
t2 = find(dates=="01-Sep-2021"); 
t3 = find(dates=="01-Dec-2021"); 
t4 = find(dates=="01-Mar-2022"); 
t5 = find(dates=="01-Jun-2022"); 
t6 = find(dates=="01-Sep-2022"); 
t7 = find(dates=="01-Dec-2022");

I = I_a1+I_s1 * 10^7;
fprintf("June 2021: \n");
fprintf("I: %f\n",I(t1));
fprintf("H: %f\n",H1(t1));
fprintf("D: %f\n",D1(t1));

fprintf("September 2021: \n");
fprintf("I: %f\n",I(t2));
fprintf("H: %f\n",H1(t2));
fprintf("D: %f\n",D1(t2));

fprintf("December 2021: \n");
fprintf("I: %f\n",I(t3));
fprintf("H: %f\n",H1(t3));
fprintf("D: %f\n",D1(t3));

fprintf("March 2022: \n");
fprintf("I: %f\n",I(t4));
fprintf("H: %f\n",H1(t4));
fprintf("D: %f\n",D1(t4));

fprintf("June 2022: \n");
fprintf("I: %f\n",I(t5));
fprintf("H: %f\n",H1(t5));
fprintf("D: %f\n",D1(t5));

fprintf("September 2022: \n");
fprintf("I: %f\n",I(t6));
fprintf("H: %f\n",H1(t6));
fprintf("D: %f\n",D1(t6));

fprintf("December 2022: \n");
fprintf("I: %f\n",I(t7));
fprintf("H: %f\n",H1(t7));
fprintf("D: %f\n",D1(t7));

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




