function dx = SEIRL(t,x,p)
    % Input 
    % t:        time vector
    % x:        variables vector
    % p:        vector containing lambda, alpha and gamma
    % lambda:   λ0/S(0)>0 is the infection rate 
    %           rescaled by the initial number of 
    %           susceptible individuals S(0)
    % alpha:    the inverse of the incubation period
    % gamma:    recovery/death rate
    % delta:    inverse of the average time subjects 
    %           remain ill without infecting others
    
    % Output
    % dx: 
    
    % SEIRL model 
    % S'= -lambda*S*I
    % E' = lambda*S*I - alpha*E
    % I' = alpha*E - gamma*I
    % L' = gamma*I - delta*L
    % R'= delta*L
    
    lambda = p(1);
    alpha = p(2);
    gamma = p(3);
    delta = p(4);
    
    dx = zeros(5,1);
    
    dx(1) = -lambda*x(1)*x(3);
    dx(2) = lambda*x(1)*x(3) - alpha*x(2);
    dx(3) = alpha*x(2) - gamma*x(3);
    dx(4) = delta*dx(3) - delta*dx(4);
    dx(5) = delta*x(4);
    end
    
    