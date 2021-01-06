function err = err_SEIIRHD(T,data,p,X0)
[t_res,x_res] = ode23s(@(t,x) SEIIRHD(t,x, p), T, X0);  

E = x_res(:, 2); 
I_a = x_res(:, 3); 
I_s = x_res(:, 4);
H = x_res(:, 5);
R = x_res(:, 6);
D = x_res(:, 7);

% compute mean square error between real data and result data
err = sum((data-[E; I_a; I_s; H; R; D]).^2); 
end