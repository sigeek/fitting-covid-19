function simulate_SEIIRHD(timeV, X1, X2, X3, path)

% Input 
% timeV   time vector used as x-axis
% X1      vector containg the ODE solution with 0.25 quartiles
% X2      vector containg the ODE solution with 0.5 quartiles
% X3      vector containg the ODE solution with 0.75 quartiles
% path    path for saving the plot obtained

% Output
%         Void function

I_a1 = X1(:, 3);
I_s1 = X1(:, 4);
H1 = X1(:, 5);
D1 = X1(:, 7);

I_a2 = X2(:, 3);
I_s2 = X2(:, 4);
H2 = X2(:, 5);
D2 = X2(:, 7);

I_a3 = X3(:, 3);
I_s3 = X3(:, 4);
H3 = X3(:, 5);
D3 = X3(:, 7);

[maxI_a1, dayIa1] = max(I_a1);
[maxI_s1, dayIs1] = max(I_s1);
[maxH1, dayH1] = max(H1);
[maxD1, dayD1] = max(D1);

[maxI_a2, dayIa2] = max(I_a2);
[maxI_s2, dayIs2] = max(I_s2);
[maxH2, dayH2] = max(H2);
[maxD2, dayD2] = max(D2);

[maxI_a3, dayIa3] = max(I_a3);
[maxI_s3, dayIs3] = max(I_s3);
[maxH3, dayH3] = max(H3);
[maxD3, dayD3] = max(D3);

fprintf("0.25 Quartiles:\n "); 
fprintf("Max I_a: %f, day: %d \n",maxI_a1, dayIa1); 
fprintf("Max I_s: %f, day: %d \n", maxI_s1, dayIs1); 
fprintf("Max H: %f, day: %d \n", maxH1, dayH1); 
fprintf("Max D: %f, day: %d \n", maxD1, dayD1); 
fprintf("----\n")
fprintf("0.5 Quartiles:\n "); 
fprintf("Max I_a: %f, day: %d\n", maxI_a2, dayIa2); 
fprintf("Max I_s: %f, day: %d\n", maxI_s2, dayIs2); 
fprintf("Max H: %f, day: %d\n ", maxH2, dayH2); 
fprintf("Max D: %f, day: %d\n", maxD2, dayD2); 
fprintf("----\n")
fprintf("0.75 Quartiles:\n "); 
fprintf("Max I_a: %f, day: %d\n ", maxI_a3, dayIa3); 
fprintf("Max I_s: %f, day: %d\n", maxI_s3, dayIs3); 
fprintf("Max H: %f, day: %d\n ", maxH3, dayH3); 
fprintf("Max D: %f, day: %d\n", maxD3, dayD3); 

x0=100;
y0=100;
width=1200;
height=700;
set(gcf,'position',[x0,y0,width,height]);

% I_a PLOT
subplot(2,2,1);
plot(timeV,I_a1,'g-', 'Linewidth', 1.5);hold on
plot(timeV,I_a2,'b-', 'Linewidth', 1.5);hold on
plot(timeV,I_a3,'r-', 'Linewidth', 1.5);hold on
xlabel('Days');ylabel('Number of individuals');
legend('R0 = 1.23', 'R0 = 1.05' ,...
    'R0 = 0.83', ...
    'Location', 'northeast');
%set(gca,'XLim',[timeV(1), dates(tf+tp)]);
title(sprintf('Infected Asymptomatic'));

% I_s PLOT
subplot(2,2,2);
plot(timeV,I_s1,'g-', 'Linewidth', 1.5);hold on
plot(timeV,I_s2,'b-', 'Linewidth', 1.5);hold on
plot(timeV,I_s3,'r-', 'Linewidth', 1.5);hold on
xlabel('Days');ylabel('Number of individuals');
legend('R0 = 1.23', 'R0 = 1.05' ,...
    'R0 = 0.83', ...
    'Location', 'northeast');
%set(gca,'XLim',[timeV(1), dates(tf+tp)]);
title(sprintf('Infected Symptomatic'));

% H PLOT
subplot(2,2,3);
plot(timeV,H1,'g-', 'Linewidth', 1.5);hold on
plot(timeV,H2,'b-', 'Linewidth', 1.5);hold on
plot(timeV,H3,'r-', 'Linewidth', 1.5);hold on
xlabel('Days');ylabel('Number of individuals');
legend('R0 = 1.23', 'R0 = 1.05' ,...
    'R0 = 0.83', ...
    'Location', 'northeast');
%set(gca,'XLim',[timeV(1), dates(tf+tp)]);
title(sprintf('Hospitalized'));

% D PLOT
subplot(2,2,4);
plot(timeV,D1,'g-', 'Linewidth', 1.5);hold on
plot(timeV,D2,'b-', 'Linewidth', 1.5);hold on
plot(timeV,D3,'r-', 'Linewidth', 1.5);hold on
xlabel('Days');ylabel('Number of individuals');
legend('R0 = 1.23', 'R0 = 1.05' ,...
    'R0 = 0.83', ...
    'Location', 'southeast');
%set(gca,'XLim',[timeV(1), dates(tf+tp)]);
title(sprintf('Deaths'));
saveas(gcf,path)




