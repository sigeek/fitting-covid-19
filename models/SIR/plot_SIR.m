function plot_SIR(X, X0, N, p, t0, tf, tp)

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
I = X(:, 2);
R = X(:, 3);
fprintf("--- SIR MODEL ---\n");
for i = 1:size(tp, 2)

    [t,X] = ode23s(@(t,x) SIR(t,x, p), t0:1:tf+tp(i), X0);   

    I_pred = X(:, 2); 
    R_pred = X(:, 3);
    len_train = tf-t0;

    RMSE_I_train = sqrt(mean((I(t0:tf)-I_pred(1:len_train+1)).^2));
    RMSE_R_train = sqrt(mean((R(t0:tf)-R_pred(1:len_train+1)).^2));
    RMSE_I_test = sqrt(mean((I(tf:tf+tp(i))-I_pred(len_train:len_train+tp(i))).^2));
    RMSE_R_test = sqrt(mean((R(tf:tf+tp(i))-R_pred(len_train:len_train+tp(i))).^2));
    
    if i == 1
        fprintf("--- SIR MODEL --- \n");
        fprintf("RMSE train I: %f \n", RMSE_I_train);
        fprintf("RMSE train R: %f \n", RMSE_R_train);
    end
    fprintf("%d days forecasts errors \n", tp(i));
    fprintf("RMSE test I: %f \n", RMSE_I_test);
    fprintf("RMSE test R: %f \n", RMSE_R_test);

    figure(1)
    subplot(1,3,i);
    xline(tf,'--m');hold on;
    plot(t0:tf+tp(i), I(t0:tf+tp(i)),'ro');hold on; 
    plot(t,N*I_pred,'r', 'LineWidth',2);
    plot(t0:tf+tp(i), R(t0:tf+tp(i)),'go');hold on;
    plot(t, N*R_pred,'g', 'LineWidth',2);
    xlabel('Days');ylabel('Number of individuals');
    legend('Start forecast', 'I (reported)','I (fitted)', ...
        'R (reported)', 'R (fitted)', 'Location', 'northwest');
    title(sprintf('SIR: %d days forecasts', tp(i)));
    set(gca,'FontSize',12)

end