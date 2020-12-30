function dx = SIR(t,x,p)
    % Input 
    % t:        time vector
    % x:        variables vector
    % p:        vector containing lambda, alpha and gamma
    % alpha:    λ0/S(0)>0 is the infection rate 
    %           rescaled by the initial number of 
    %           susceptible individuals S(0)
    % gamma:    recovery/death rate
    
    % Output
    % dx: 
    
    % SEIR model 
    % S'= -alpha*S*I
    % I' = alpha*S*I - gamma*I
    % R'= gamma*I
    
    lambda = p(1);
    gamma = p(2);
    
    dx = zeros(3,1);
    
    dx(1) = -lambda*x(1)*x(2);
    dx(2) = lambda*x(1)*x(2) - gamma*x(2);
    dx(3) = gamma*x(2);
    end
    
    