function dx = SEIIHRD(t,x,p)
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
% dx:               [S', E', Ia', Is', H', R', D']



% SEIIRHD model
% S'= -(beta_s*I_s + beta_e*E+ beta_a*I_a) * S
% E' = (beta_s*I_s + beta_e*E + beta_a*I_a)*S - (alpha + nu_e)*E
% I_a' = (1-f)*alpha*E - (gamma*I_a)
% I_s'  = f*alpha*E - (gamma + mu + nu_s)*I_s
% H' = nu_e*E + nu_S*I_s - (gamma + mu) * H
% R'= gamma*(I_s+I_a+ H)
% D' = mu* (I_S + H)

f = p(1);
alpha = p(2);
gamma = p(3);
beta_a = p(4);
beta_s = p(5);
nu_s = p(6);
mu = p(7);
%beta_e = p(6);
%nu_e = p(7);
%nu_s = p(8);
%mu = p(9);


dx = zeros(7,1);

%dx(1) = -beta_a*x(1)*x(3) -beta_s*x(1)*x(4) -beta_e*x(1)*x(2);
%dx(2) = beta_a*x(1)*x(3) + beta_s*x(1)*x(4) + beta_e*x(1)*x(2) - (alpha+nu_e)*x(2);
%dx(3) = (1-f)*alpha*x(2) - gamma*x(3);
%dx(4) = f*alpha*x(2) - (gamma + mu + nu_s)*x(4);
%dx(5) = nu_e*x(2) + nu_s *x(4) - (gamma + mu) * x(5);
%dx(6) = gamma *( x(4) + x(3) +x(5));
%dx(7) = mu* (x(4) + x(5));


dx(1) = -beta_a*x(1)*x(3) -beta_s*x(1)*x(4);
dx(2) = beta_a*x(1)*x(3) + beta_s*x(1)*x(4) - alpha*x(2);
dx(3) = (1-f)*alpha*x(2) - gamma*x(3);
dx(4) = f*alpha*x(2) - (gamma + mu + nu_s)*x(4);
dx(5) = + nu_s *x(4) - (gamma + mu) * x(5);
dx(6) = gamma *( x(4) + x(3) +x(5));
dx(7) = mu* (x(4) + x(5));

end

