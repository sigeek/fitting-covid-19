function plot_SEIR(X, X0, N, p, dates, t0, tf, tp, path)

% Input 
% X       data: S, I, R
% X0      initial conditions: S0, I0, R0
% N       number of individuals (Italian population)
% p       estimated values of the coefficients of the model
% dates   time vector
% t0      time at which the fitting starts
% tf      time at which the fitting ends  
% tp      vector containing the times for the predictions

% Output
%         Void function

%S = X(:, 1);
E = X(:, 2);
I = X(:, 3);
R = X(:, 4);

for i = 1:size(tp, 2)

    [t,X] = ode23s(@(t,x) SEIR(t,x, p), t0:1:tf+tp(i), X0);   

    E_pred = X(:, 2); 
    I_pred = X(:, 3);
    R_pred = X(:, 4);
    len_train = tf-t0;
    
    x0=100;
    y0=100;
    width=1300;
    height=700;
    set(gcf,'position',[x0,y0,width,height]);

    figure(1)
    subplot(2,3,i);
    xline(dates(tf),'--m');hold on;
    plot(dates(t0:tf+tp(i)), I(t0:tf+tp(i)),'ro');hold on; 
    plot(dates(t),N*I_pred,'r', 'LineWidth',2);
    plot(dates(t0:tf+tp(i)), R(t0:tf+tp(i)),'go');hold on;
    plot(dates(t), N*R_pred,'g', 'LineWidth',2);
    xlabel('time');ylabel('Number of individuals');
    legend('Start forecast', ...
    'I (reported)','I (fitted)', 'R (reported)', 'R (fitted)',...
    'Location', 'northwest');
    title(sprintf('SEIR: %d days forecasts', tp(i)));
    grid on
    set(gca,'yscale','log');
    set(gca,'XLim',[dates(t0), dates(tf+tp(i))]);
    
    
    subplot(2,3,3+i);
    xline(dates(tf),'--m');hold on;
    plot(dates(t0:tf+tp(i)), E(t0:tf+tp(i)),'bo');hold on; 
    plot(dates(t),N*E_pred,'b', 'LineWidth',2);
    xlabel('time');ylabel('Number of individuals');
    legend('Start forecast', 'E (reported)','E (fitted)',...
    'Location', 'northwest');
    title(sprintf('SEIR: %d days forecasts', tp(i)));
    grid on
    set(gca,'yscale','log');
    set(gca,'XLim',[dates(t0), dates(tf+tp(i))]);
    
end

saveas(gcf,path)
end
