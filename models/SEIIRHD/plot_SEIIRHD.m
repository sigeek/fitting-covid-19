function plot_SEIIRHD(X, X0, N, p, dates, t0, tf, tp, path)

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
I_a = X(:, 3);
I_s = X(:, 4);
H = X(:, 5);
R = X(:, 6);
D = X(:, 7);

for i = 1:size(tp, 2)

    [t,X] = ode23s(@(t,x) SEIIRHD(t,x, p), t0:1:tf+tp(i), X0);   

    E_pred = X(:, 2); 
    Ia_pred = X(:, 3);
    Is_pred = X(:, 4);
    H_pred = X(:, 5);
    R_pred = X(:, 6);
    D_pred = X(:, 7);
    len_train = tf-t0;
    
    
    compute_errors(I_s(tf:tf+tp(i)), H(tf:tf+tp(i)),...
    R(tf:tf+tp(i)), D(tf:tf+tp(i)), N*Is_pred(len_train:len_train+tp(i)), ...
    N*H_pred(len_train:len_train+tp(i)), N*R_pred(len_train:len_train+tp(i)), ...
    N*D_pred(len_train:len_train+tp(i)));

    x0=100;
    y0=100;
    width=1300;
    height=700;
    set(gcf,'position',[x0,y0,width,height]);

    figure(1)
    subplot(2,3,i);
    xline(dates(tf),'--m');hold on;
    plot(dates(t0:tf+tp(i)), I_a(t0:tf+tp(i)),'ro');hold on; 
    plot(dates(t),N*Ia_pred,'r', 'LineWidth',2);
    plot(dates(t0:tf+tp(i)), I_s(t0:tf+tp(i)), 'o', 'Color', '#D95319');hold on;
    plot(dates(t), N*Is_pred, 'Color', '#D95319', 'LineWidth',2);
    plot(dates(t0:tf+tp(i)), R(t0:tf+tp(i)),'go');hold on;
    plot(dates(t), N*R_pred,'g', 'LineWidth',2);
    xlabel('Days');ylabel('Number of individuals');
    legend('Start forecast',...
    'I_a (reported)','I_a (fitted)', 'I_s (reported)', 'I_s (fitted)',...
    'R (reported)','R (fitted)',...
    'Location', 'northwest');
    title(sprintf('SEIIRHD: %d days forecasts', tp(i)));
    set(gca,'yscale','log');
    set(gca,'XLim',[dates(t0), dates(tf+tp(i))]);
    grid on
    
    subplot(2,3,3+i);
    xline(dates(tf),'--m');hold on;
    plot(dates(t0:tf+tp(i)), E(t0:tf+tp(i)),'bo');hold on; 
    plot(dates(t),N*E_pred,'b', 'LineWidth',2);
    plot(dates(t0:tf+tp(i)), H(t0:tf+tp(i)),'co');hold on;
    plot(dates(t), N*H_pred, 'c', 'LineWidth',2);
    plot(dates(t0:tf+tp(i)), D(t0:tf+tp(i)),'ko');hold on;
    plot(dates(t), N*D_pred,'k', 'LineWidth',2);
    xlabel('Days');ylabel('Number of individuals');
    legend('Start forecast', 'E (reported)','E (fitted)',...
    'H (reported)','H (fitted)',...
    'D (reported)','D (fitted)','Location', 'northwest');
    title(sprintf('SEIIRHD: %d days forecasts', tp(i)));
    set(gca,'yscale','log');
    set(gca,'XLim',[dates(t0), dates(tf+tp(i))]);
    grid on
    
    
end
saveas(gcf,path)
end