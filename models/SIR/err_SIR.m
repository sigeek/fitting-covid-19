function err = err_SIR(T,data,p,X0)
    [t_res,x_res] = ode23s(@(t,x) SIR(t,x, p), T, X0);  
    
   
    I = x_res(:, 2); 
    R = x_res(:, 3);    
    % compute mean square error between real data and result data
    err = sum((data-[I; R]).^2); 
    end