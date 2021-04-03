function compute_errors(I_s, H, R, D, Is_pred, H_pred, R_pred, D_pred)

% Input 
% I_s       I_s actual
% H         H actual
% R         R actual
% D         D actual
% I_s_pred  I_s predicted
% H_pred    H predicted
% R_pred    R predicted
% D_pred    D predicted

% Output
%         Void function


MAE_Is = mean(abs(I_s-Is_pred));
MAE_H = mean(abs(H-H_pred));
MAE_R = mean(abs(R-R_pred));
MAE_D = mean(abs(D-D_pred));
fprintf("--------------MAE-----------------\n");
fprintf("MAE Is: %f \n", MAE_Is);
fprintf("MAE H: %f \n", MAE_H);
fprintf("MAE R: %f \n", MAE_R);
fprintf("MAE D: %f \n", MAE_D);

RMSE_Is = sqrt(mean((I_s-Is_pred).^2));
RMSE_H = sqrt(mean((H-H_pred).^2));
RMSE_R = sqrt(mean((R-R_pred).^2));
RMSE_D = sqrt(mean((D-D_pred).^2));
fprintf("--------------RMSE-----------------\n");
fprintf("RMSE Is: %f \n", RMSE_Is);
fprintf("RMSE H: %f \n", RMSE_H);
fprintf("RMSE R: %f \n", RMSE_R);
fprintf("RMSE D: %f \n", RMSE_D);

% TSS_Is = sum((I_s-mean(I_s)).^2);
% TSS_H = sum((H-mean(H)).^2);
% TSS_R = sum((R-mean(R)).^2);
% TSS_D = sum((D-mean(D)).^2);
% 
% RSS_Is = sum((I_s-Is_pred).^2);
% RSS_H = sum((H-H_pred).^2);
% RSS_R = sum((R-R_pred).^2);
% RSS_D = sum((D-D_pred).^2);
% 
% R2_Is = 1 - RSS_Is/TSS_Is;
% R2_H = 1 - RSS_H/TSS_H;
% R2_R = 1 - RSS_R/TSS_R;
% R2_D = 1 - RSS_D/TSS_D;


R_Is = corrcoef(I_s, Is_pred);
R2_Is = R_Is(1,2);
R_H = corrcoef(H, H_pred);
R2_H = R_H(1,2);
R_R = corrcoef(R, R_pred);
R2_R = R_R(1,2);
R_D = corrcoef(D, D_pred);
R2_D = R_D(1,2);

fprintf("--------------R2-----------------\n");
fprintf("R2 Is: %f \n", R2_Is);
fprintf("R2 H: %f \n", R2_H);
fprintf("R2 R: %f \n", R2_R);
fprintf("R2 D: %f \n", R2_D);
end

