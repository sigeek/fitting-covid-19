function plot_SEIIRHD(X, X0, N, p, dates, t0, tf, tp, name)

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
    
    %RMSE_E_train = sqrt(mean((E(t0:tf)-E_pred(1:len_train+1)).^2));
    %RMSE_Ia_train = sqrt(mean((I_a(t0:tf)-Ia_pred(1:len_train+1)).^2));
    %RMSE_Is_train = sqrt(mean((I_s(t0:tf)-Is_pred(1:len_train+1)).^2));
    %RMSE_H_train = sqrt(mean((H(t0:tf)-H_pred(1:len_train+1)).^2));
    %RMSE_R_train = sqrt(mean((R(t0:tf)-R_pred(1:len_train+1)).^2));
    %RMSE_D_train = sqrt(mean((D(t0:tf)-D_pred(1:len_train+1)).^2));
    
    %RMSE_E_test = sqrt(mean((E(tf:tf+tp(i))-E_pred(len_train:len_train+tp(i))).^2));
    %RMSE_Ia_test = sqrt(mean((I_a(tf:tf+tp(i))-Ia_pred(len_train:len_train+tp(i))).^2));
    %RMSE_Is_test = sqrt(mean((I_s(tf:tf+tp(i))-Is_pred(len_train:len_train+tp(i))).^2));
    %RMSE_H_test = sqrt(mean((H(tf:tf+tp(i))-H_pred(len_train:len_train+tp(i))).^2));
    %RMSE_R_test = sqrt(mean((R(tf:tf+tp(i))-R_pred(len_train:len_train+tp(i))).^2));
    %RMSE_D_test = sqrt(mean((D(tf:tf+tp(i))-D_pred(len_train:len_train+tp(i))).^2));
    
    %fprintf("%d days forecasts errors \n", tp(i));
    %fprintf("RMSE train E: %f \n", RMSE_E_train);
    %fprintf("RMSE train Ia: %f \n", RMSE_Ia_train);
    %fprintf("RMSE train Is: %f \n", RMSE_Is_train);
    %fprintf("RMSE train H: %f \n", RMSE_H_train);
    %fprintf("RMSE train R: %f \n", RMSE_R_train);
    %fprintf("RMSE train D: %f \n", RMSE_D_train);
    
    %fprintf("RMSE test E: %f \n", RMSE_E_test);
    %fprintf("RMSE test Ia: %f \n", RMSE_Ia_test);
    %fprintf("RMSE test Is: %f \n", RMSE_Is_test);
    %fprintf("RMSE test H: %f \n", RMSE_H_test);
    %fprintf("RMSE test R: %f \n", RMSE_R_test);
    %fprintf("RMSE test D: %f \n", RMSE_D_test);

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
    set(gca,'XLim',[dates(t0), dates(tf+tp(i))]);
    
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
    set(gca,'XLim',[dates(t0), dates(tf+tp(i))]);
    
    
end
if name == "Molise"
    saveas(gcf,'./results/SEIIRHD_Molise_fitting.png')
elseif name == "Sardegna"
    saveas(gcf,'./results/SEIIRHD_Sardegna_fitting.png')
else
    saveas(gcf,'./results/SEIIRHD_fitting.png')
end