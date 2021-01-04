function plot_SEIRD(X, X0, N, p, t0, tf, tp)

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
D = X(:, 5);

for i = 1:size(tp, 2)

    [t,X] = ode23s(@(t,x) SEIRD(t,x, p), t0:1:tf+tp(i), X0);   

    E_pred = X(:, 2); 
    I_pred = X(:, 3);
    R_pred = X(:, 4);
    D_pred = X(:, 5);
    len_train = tf-t0;
    
    RMSE_E_train = sqrt(mean((E(t0:tf)-E_pred(1:len_train+1)).^2));
    RMSE_I_train = sqrt(mean((I(t0:tf)-I_pred(1:len_train+1)).^2));
    RMSE_R_train = sqrt(mean((R(t0:tf)-R_pred(1:len_train+1)).^2));
    RMSE_D_train = sqrt(mean((D(t0:tf)-D_pred(1:len_train+1)).^2));
    RMSE_E_test = sqrt(mean((E(tf:tf+tp(i))-E_pred(len_train:len_train+tp(i))).^2));
    RMSE_I_test = sqrt(mean((I(tf:tf+tp(i))-I_pred(len_train:len_train+tp(i))).^2));
    RMSE_R_test = sqrt(mean((R(tf:tf+tp(i))-R_pred(len_train:len_train+tp(i))).^2));
    RMSE_D_test = sqrt(mean((D(tf:tf+tp(i))-D_pred(len_train:len_train+tp(i))).^2));
    
    if i == 1
        fprintf("--- SEIRD MODEL --- \n");
        fprintf("RMSE train E: %f \n", RMSE_E_train);
        fprintf("RMSE train I: %f \n", RMSE_I_train);
        fprintf("RMSE train R: %f \n", RMSE_R_train);
        fprintf("RMSE train D: %f \n", RMSE_D_train);
    end
    fprintf("%d days forecasts errors \n", tp(i));
    fprintf("RMSE train R: %f \n", RMSE_D_train);
    fprintf("RMSE test E: %f \n", RMSE_E_test);
    fprintf("RMSE test I: %f \n", RMSE_I_test);
    fprintf("RMSE test R: %f \n", RMSE_R_test);
    fprintf("RMSE test D: %f \n", RMSE_D_test);

    figure(1)
    subplot(1,3,i);
    xline(tf,'--m');hold on;
    plot(t0:tf+tp(i), E(t0:tf+tp(i)),'bo');hold on; 
    plot(t,N*E_pred,'b', 'LineWidth',2);
    plot(t0:tf+tp(i), I(t0:tf+tp(i)),'ro');hold on; 
    plot(t,N*I_pred,'r', 'LineWidth',2);
    plot(t0:tf+tp(i), R(t0:tf+tp(i)),'go');hold on;
    plot(t, N*R_pred,'g', 'LineWidth',2);
    plot(t0:tf+tp(i), D(t0:tf+tp(i)),'co');hold on;
    plot(t, N*D_pred,'c', 'LineWidth',2);
    xlabel('Days');ylabel('Number of individuals');
    legend('Start forecast', 'E (reported)','E (fitted)',...
    'I (reported)','I (fitted)', 'R (reported)', 'R (fitted)',...
    'D (reported)','D (fitted)','Location', 'northwest');
    title(sprintf('SEIRD: %d days forecasts', tp(i)));
    set(gca,'FontSize',12)

end