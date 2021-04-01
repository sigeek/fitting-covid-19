function compute_errors(E, I_s, H, R, D, X)

% Input 
% E       E actual
% I_s     I_s actual
% H       H actual
% R       R actual
% D       D actual
% X       prediction vector

% Output
%         Void function

E_pred = X(:, 2); 
Ia_pred = X(:, 3);
Is_pred = X(:, 4);
H_pred = X(:, 5);
R_pred = X(:, 6);
D_pred = X(:, 7);

MAE_Is = mean(abs((I_s)-Is_pred));
MAE_H = mean(abs((H)-H_pred));
MAE_R = mean(abs((R)-R_pred));
MAE_D = mean(abs((D)-D_pred));
fprintf("--------------MAE-----------------\n");
fprintf("MAE Is: %f \n", MAE_Is);
fprintf("MAE H: %f \n", MAE_H);
fprintf("MAE R: %f \n", MAE_R);
fprintf("MAE D: %f \n", MAE_D);

RMSE_Is = sqrt(mean(((I_s)-Is_pred).^2));
RMSE_H = sqrt(mean(((H)-H_pred).^2));
RMSE_R = sqrt(mean(((R)-R_pred).^2));
RMSE_D = sqrt(mean(((D)-D_pred).^2));
fprintf("--------------RMSE-----------------\n");
fprintf("RMSE Is: %f \n", RMSE_Is);
fprintf("RMSE H: %f \n", RMSE_H);
fprintf("RMSE R: %f \n", RMSE_R);
fprintf("RMSE D: %f \n", RMSE_D);

TSS_Is = sum(((I_s)-mean(I_s).^2));
TSS_H = sum(((H)-mean(H).^2));
TSS_R = sum(((R)-mean(R).^2));
TSS_D = sum(((D)-mean(D).^2));

RSS_Is = sum(((I_s)-(Is_pred).^2));
RSS_H = sum(((H)-(H_pred).^2));
RSS_R = sum(((R)-(R_pred).^2));
RSS_D = sum(((D)-(D_pred).^2));

R2_Is = 1 - TSS_Is/RSS_Is;
R2_H = 1 - TSS_H/RSS_H;
R2_R = 1 - TSS_R/RSS_R;
R2_D = 1 - TSS_D/RSS_D;

fprintf("--------------R2-----------------\n");
fprintf("R2 Is: %f \n", R2_Is);
fprintf("R2 H: %f \n", R2_H);
fprintf("R2 R: %f \n", R2_R);
fprintf("R2 D: %f \n", R2_D);
end

