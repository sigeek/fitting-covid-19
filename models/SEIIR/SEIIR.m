function dx = SEIIR(t,x,p)
% Input 
% t:        time vector
% x:        variables vector
% p:        vector containing lambda, alpha and gamma
% lambda:   λ0/S(0)>0 is the infection rate 
%           rescaled by the initial number of 
%           susceptible individuals S(0)
% alpha:    the inverse of the incubation period
% gamma:    recovery/death rate (tasso di morte)

% Output
% dx: 

% SEIIR model (1)
% S'= -(lambda_s*I_s + lambda_a*I_a) * S
% E' = ( + lambda_s*I_s + lambda_a*I_a)*S - alpha*E
% I_s'  = f*alpha*E - (gamma)*I_s
% I_a' = (1-f)*alpha*E - (gamma*I_a)
% R'= gamma*(I_s+I_a)

% SEIIR model (2)
% S'= -(lambda_s*I_s +lambda_e*E+ lambda_a*I_a) * S
% E' = ( + lambda_s*I_s + lambda_e*E + lambda_a*I_a)*S - alpha*E
% I_s'  = f*alpha*E - (gamma)*I_s
% I_a' = (1-f)*alpha*E - (gamma*I_a)
% R'= gamma*(I_s+I_a)

f = p(1);
alpha = p(2);
gamma = p(3);
lambda_a = p(4);
lambda_s = p(5);
lambda_e = p(6);

dx = zeros(5,1);

dx(1) = -lambda_a*x(1)*x(3) -lambda_s*x(1)*x(4) -lambda_e*x(1)*x(2);
dx(2) = lambda_a*x(1)*x(3) + lambda_s*x(1)*x(3) + lambda_e*x(1)*x(2) - alpha*x(2);
dx(3) = (1-f)*alpha*x(2) - gamma*x(3);
dx(4) = f*alpha*x(2) - gamma*x(4);
dx(5) = gamma *( x(4) + x(3) );
end

