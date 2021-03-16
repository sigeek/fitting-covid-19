function plot_PI_SEIIRHD(X, X0, N, dates, t0, tf, tp, path)

% Input 
% X       data: S, I, R
% X0      initial conditions: S0, I0, R0
% N       number of individuals (Italian population)
% dates   time vector
% t0      time at which the fitting starts
% tf      time at which the fitting ends  
% tp      vector containing the times for the predictions
% path    path for saving the plot obtained

% Output
%         Void function


%S = X(:, 1);
E = X(:, 2);
I_a = X(:, 3);
I_s = X(:, 4);
H = X(:, 5);
R = X(:, 6);
D = X(:, 7);


x_fit = t0:1:tf;
x_pred = t0:1:tf+tp;
dates_fit = dates(t0:1:tf);
dates_pred = dates(t0:1:tf+tp);
%dates_to_pred = tf-1:1:tf+tp;
%dates_to_pred_norm = tf-t0-1:1:tf-t0+tp;
alpha = 0.05;

x0=100;
y0=100;
width=1300;
height=700;
set(gcf,'position',[x0,y0,width,height]);

% E PLOT
subplot(2,3,1);
[pE, SE] = polyfit(x_fit,E(x_fit),3);
[y_fitE,deltaE] = polyconf(pE,x_pred,SE,'alpha',alpha);
plot(dates_fit,E(x_fit),'ko')
hold on
plot(dates_pred,y_fitE,'b-', 'Linewidth', 1.5)
hold on
fill([dates_pred fliplr(dates_pred)], ...
    [(y_fitE+deltaE) fliplr((y_fitE-deltaE))],...
    'b', 'facealpha', 0.2);
xlabel('Days');ylabel('Number of individuals');
legend('E (reported)', 'E (fitted)' ,'Location', 'northwest');
set(gca,'XLim',[dates(t0), dates(tf+tp)]);
title(sprintf('Exposed'));

% I_a PLOT
subplot(2,3,2);
[pIa, SIa] = polyfit(x_fit,I_a(x_fit),3);
[y_fitIa,deltaIa] = polyconf(pIa,x_pred,SIa,'alpha',alpha);
plot(dates_fit,I_a(x_fit),'ko')
hold on
plot(dates_pred,y_fitIa,'r-', 'Linewidth', 1.5)
hold on
fill([dates_pred fliplr(dates_pred)], ...
    [(y_fitIa+deltaIa) fliplr((y_fitIa-deltaIa))],...
    'r', 'facealpha', 0.2);
xlabel('Days');ylabel('Number of individuals');
legend('I_a (reported)', 'I_a (fitted)' ,'Location', 'northwest');
set(gca,'XLim',[dates(t0), dates(tf+tp)]);
title(sprintf('Infected Asymptomatic'));

% I_s PLOT
subplot(2,3,3);
[pIs, SIs] = polyfit(x_fit,I_s(x_fit),3);
[y_fitIs,deltaIs] = polyconf(pIs,x_pred,SIs,'alpha',alpha);
plot(dates_fit,I_s(x_fit),'ko')
hold on
plot(dates_pred,y_fitIs,'-','Color', '#D95319', 'Linewidth', 1.5)
hold on
fill([dates_pred fliplr(dates_pred)], ...
    [(y_fitIs+deltaIs) fliplr((y_fitIs-deltaIs))],...
    [217, 83, 25]/255, 'facealpha', 0.2);
xlabel('Days');ylabel('Number of individuals');
legend('I_s (reported)', 'I_s (fitted)' ,'Location', 'northwest');
set(gca,'XLim',[dates(t0), dates(tf+tp)]);
title(sprintf('Infected Symptomatic'));

% H PLOT
subplot(2,3,4);
[pH, SH] = polyfit(x_fit,H(x_fit),3);
[y_fitH,deltaH] = polyconf(pH,x_pred,SH,'alpha',alpha);
plot(dates_fit,H(x_fit),'ko')
hold on
plot(dates_pred,y_fitH,'c-', 'Linewidth', 1.5)
hold on
fill([dates_pred fliplr(dates_pred)], ...
    [(y_fitH+deltaH) fliplr((y_fitH-deltaH))],...
    'c', 'facealpha', 0.2);
xlabel('Days');ylabel('Number of individuals');
legend('H (reported)', 'H (fitted)' ,'Location', 'northwest');
set(gca,'XLim',[dates(t0), dates(tf+tp)]);
title(sprintf('Hospitalized'));

% R PLOT
subplot(2,3,5);
[pR, SR] = polyfit(x_fit,R(x_fit),3);
[y_fitR,deltaR] = polyconf(pR,x_pred,SR,'alpha',alpha);
plot(dates_fit,R(x_fit),'ko')
hold on
plot(dates_pred,y_fitR,'g-', 'Linewidth', 1.5)
hold on
fill([dates_pred fliplr(dates_pred)], ...
    [(y_fitR+deltaR) fliplr((y_fitR-deltaR))],...
    'g', 'facealpha', 0.2);
xlabel('Days');ylabel('Number of individuals');
legend('R (reported)', 'R (fitted)' ,'Location', 'northwest');
set(gca,'XLim',[dates(t0), dates(tf+tp)]);
title(sprintf('Recovered'));

% D PLOT
subplot(2,3,6);
[pD, SD] = polyfit(x_fit,D(x_fit),3);
[y_fitD,deltaD] = polyconf(pD,x_pred,SD,'alpha',alpha);
plot(dates_fit,D(x_fit),'ko')
hold on
plot(dates_pred,y_fitD,'k-', 'Linewidth', 1.5)
hold on
fill([dates_pred fliplr(dates_pred)], ...
    [(y_fitD+deltaD) fliplr((y_fitD-deltaD))],...
    'k', 'facealpha', 0.2);
xlabel('Days');ylabel('Number of individuals');
legend('D (reported)', 'D (fitted)' ,'Location', 'northwest');
set(gca,'XLim',[dates(t0), dates(tf+tp)]);
title(sprintf('Deaths'));

saveas(gcf,path)



end
