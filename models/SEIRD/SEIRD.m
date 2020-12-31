function dx = SEIRD(t,x,p)
% Input 
% t:        time vector
% x:        variables vector
% p:        vector containing lambda, alpha and gamma
% lambda:   λ0/S(0)>0 is the infection rate 
%           rescaled by the initial number of 
%           susceptible individuals S(0)
% alpha:    the inverse of the incubation period
% gamma:    recovery/death rate

% Output
% dx: 

% SEIR model 
% S'= -lambda*S*I
% E' = lambda*S*I - alpha*E
% I' = alpha*E - gamma*I
% R'= gamma*I

lambda = p(1);
alpha = p(2);
gamma = p(3);
d = p(4);
ro = p(5);

dx = zeros(4,1);

dx(1) = -lambda*x(1)*x(3);
dx(2) = lambda*x(1)*x(3) - alpha*x(2);
dx(3) = alpha*x(2) - (1-d)*gamma*x(3)-d*ro*x(3);
dx(4) = (1-d)*gamma*x(3);
dx(5) = d*ro*x(3);
end

