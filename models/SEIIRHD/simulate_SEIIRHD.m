function simulate_SEIIRHD(timeV, X1, X2, X3, X4, path)

% Input 
% timeV   time vector used as x-axis
% X1      vector containg the ODE solution with R0 = 0.5
% X2      vector containg the ODE solution with R0 = 1
% X3      vector containg the ODE solution with R0 = 1.5
% X4      vector containg the ODE solution with R0 = 3
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

I_a4 = X4(:, 3);
I_s4 = X4(:, 4);
H4 = X4(:, 5);
D4 = X4(:, 7);

fprintf("R0 = 0.5: "); 
fprintf("Max I_a: %f, ", max(I_a1)); 
fprintf("Max I_s: %f\n", max(I_s1)); 
fprintf("Max H: %f, ", max(H1)); 
fprintf("Max D: %f\n", max(D1)); 
fprintf("R0 = 1: "); 
fprintf("Max I_a: %f, ", max(I_a2)); 
fprintf("Max I_s: %f\n", max(I_s2)); 
fprintf("Max H: %f, ", max(H2)); 
fprintf("Max D: %f\n", max(D2)); 
fprintf("R0 = 1.5: "); 
fprintf("Max I_a: %f, ", max(I_a3)); 
fprintf("Max I_s: %f\n", max(I_s3)); 
fprintf("Max H: %f, ", max(H3)); 
fprintf("Max D: %f\n", max(D3)); 
fprintf("R0 = 3"); 
fprintf("Max I_a: %f, ", max(I_a4)); 
fprintf("Max I_s: %f\n", max(I_s4)); 
fprintf("Max H: %f, ", max(H4)); 
fprintf("Max D: %f\n", max(D4)); 

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
plot(timeV,I_a4,'k-', 'Linewidth', 1.5);hold on
xlabel('Days');ylabel('Number of individuals');
legend('R0 = 0.5', 'R0 = 1' ,...
    'R0 = 1.5', 'R0 = 3' ,...
    'Location', 'northeast');
%set(gca,'XLim',[timeV(1), dates(tf+tp)]);
title(sprintf('Infected Asymptomatic'));

% I_s PLOT
subplot(2,2,2);
plot(timeV,I_s1,'g-', 'Linewidth', 1.5);hold on
plot(timeV,I_s2,'b-', 'Linewidth', 1.5);hold on
plot(timeV,I_s3,'r-', 'Linewidth', 1.5);hold on
plot(timeV,I_s4,'k-', 'Linewidth', 1.5);hold on
xlabel('Days');ylabel('Number of individuals');
legend('R0 = 0.5', 'R0 = 1' ,...
    'R0 = 1.5', 'R0 = 3' ,...
    'Location', 'northeast');
%set(gca,'XLim',[timeV(1), dates(tf+tp)]);
title(sprintf('Infected Symptomatic'));

% H PLOT
subplot(2,2,3);
plot(timeV,H1,'g-', 'Linewidth', 1.5);hold on
plot(timeV,H2,'b-', 'Linewidth', 1.5);hold on
plot(timeV,H3,'r-', 'Linewidth', 1.5);hold on
plot(timeV,H4,'k-', 'Linewidth', 1.5);hold on
xlabel('Days');ylabel('Number of individuals');
legend('R0 = 0.5', 'R0 = 1' ,...
    'R0 = 1.5', 'R0 = 3' ,...
    'Location', 'northeast');
%set(gca,'XLim',[timeV(1), dates(tf+tp)]);
title(sprintf('Hospitalized'));

% D PLOT
subplot(2,2,4);
plot(timeV,D1,'g-', 'Linewidth', 1.5);hold on
plot(timeV,D2,'b-', 'Linewidth', 1.5);hold on
plot(timeV,D3,'r-', 'Linewidth', 1.5);hold on
plot(timeV,D4,'k-', 'Linewidth', 1.5);hold on
xlabel('Days');ylabel('Number of individuals');
legend('R0 = 0.5', 'R0 = 1' ,...
    'R0 = 1.5', 'R0 = 3' ,...
    'Location', 'northeast');
%set(gca,'XLim',[timeV(1), dates(tf+tp)]);
title(sprintf('Deaths'));

saveas(gcf,path)




