function dx = SEIR(t,x,lambda,alpha,gamma)
% TODO
% Input 
% t:        time vector
% x:        variables vector
% lambda:   λ0/S(0)>0 is the infection rate 
%           rescaled by the initial number of 
%           susceptible individualsS(0)
% alpha:    the inverse of the incubation period
% gamma:    recovery/death rate

% Output
% dx: 

% SEIR model 
% S'= -lambda*S*I
% E' = lambda*S*I - alpha*E
% I' = alpha*E - gamma*I
% R'= gamma*I

dx = zeros(4,1);

dx(1) = -lambda*x(1)*x(3);
dx(2) = lambda*x(1)*x(3) - alpha*x(2);
dx(3) = alpha*x(2) - gamma*x(3);
dx(4) = gamma*x(3);
end

