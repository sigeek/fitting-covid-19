function plot_SEIRH(X, X0, N, p, t0, tf, tp)

% Input 
% X       data: S, I, R
% X0      initial conditions: S0, I0, R0
% N       number of individuals (Italian population)
% p       estimated values of the coefficients of the model
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

    [t,X] = ode23s(@(t,x) SEIRH(t,x, p), t0:1:tf+tp(i), X0);   

    E_pred = X(:, 2); 
    I_pred = X(:, 3);
    R_pred = X(:, 4);

    figure(1)
    subplot(1,3,i);
    xline(tf,'--m');hold on;
    plot(t0:tf+tp(i), E(t0:tf+tp(i)),'bo');hold on; 
    plot(t,N*E_pred,'b', 'LineWidth',2);
    plot(t0:tf+tp(i), I(t0:tf+tp(i)),'ro');hold on; 
    plot(t,N*I_pred,'r', 'LineWidth',2);
    plot(t0:tf+tp(i), R(t0:tf+tp(i)),'go');hold on;
    plot(t, N*R_pred,'g', 'LineWidth',2);
    xlabel('Days');ylabel('Number of individuals');
    legend('Start forecast', 'E (reported)','E (fitted)', ...
    'I (reported)','I (fitted)', 'R (reported)', 'R (fitted)', ...
     'Location', 'northwest');
    title(sprintf('SEIRH: %d days forecasts', tp(i)));
    set(gca,'FontSize',12)

end