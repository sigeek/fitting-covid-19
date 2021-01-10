function dx = SEIIR(t,x,p)
% Input 
% t:                time vector
% x:                variables vector
% p:                vector containing the parameters
% f:                probability of being symptomatic
% alpha:            the inverse of the incubation period
% gamma:            recovery rate
% beta_{e,a,s}:     infection rate from S to E, I_a, I_s
% nu_{e,s}:         intervention rate for E and I_s
% mu:               death rate

% Output
% dx:               [S', E', Ia', Is', R']

% SEIIR model
% S'= -(beta_s*I_s +beta_e*E+ beta_a*I_a) * S
% E' = (beta_s*I_s + beta_e*E + beta_a*I_a)*S - alpha*E
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
dx(2) = lambda_a*x(1)*x(3) + lambda_s*x(1)*x(4) + lambda_e*x(1)*x(2) - alpha*x(2);
dx(3) = (1-f)*alpha*x(2) - gamma*x(3);
dx(4) = f*alpha*x(2) - gamma*x(4);
dx(5) = gamma *( x(4) + x(3) );
end

