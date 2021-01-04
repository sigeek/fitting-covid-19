function dx = SEIR(t,x,p)
% Input 
% t:        time vector
% x:        variables vector
% p:        vector containing beta, alpha and gamma
% beta:   λ0/S(0)>0 is the infection rate 
%           rescaled by the initial number of 
%           susceptible individuals S(0)
% alpha:    the inverse of the incubation period
% gamma:    recovery/death rate

% Output
% dx: 

% SEIR model 
% S'= -beta*S*I
% E' = beta*S*I - alpha*E
% I' = alpha*E - gamma*I
% R'= gamma*I

beta = p(1);
alpha = p(2);
gamma = p(3);

dx = zeros(4,1);

dx(1) = -beta*x(1)*x(3);
dx(2) = beta*x(1)*x(3) - alpha*x(2);
dx(3) = alpha*x(2) - gamma*x(3);
dx(4) = gamma*x(3);
end

