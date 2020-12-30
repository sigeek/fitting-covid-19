function err = err_SEIR(T,data,p,X0)
[t_res,x_res] = ode23s(@(t,x) SEIR(t,x, p), T, X0);  

E = x_res(:, 2); 
I = x_res(:, 3); 
R = x_res(:, 4);    
% compute mean square error between real data and result data
err = sum((data-[E; I; R]).^2); 
end