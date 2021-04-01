S0=0.8;
I0=0.2;
beta=0.3;
gamma=1/10;
mu=5e-5;

SEIIRHD=@(t,y)
[-(beta_s*y(4) + beta_e*y(2)+ beta_a*y(3)) * y(1);...
 beta*y(1)*y(2)-gamma*y(2)-mu*y(2);...
 ];

y1=linspace(0,1,14);
y2=linspace(0,1,14);
[x,y]=meshgrid(y1,y2);
u=zeros(size(x));
v=zeros(size(y));
t=0;
for i=1:numel(x)

    Yprime=SIR(t,[x(i);y(i)]);
    Yprime=Yprime/norm(Yprime);
    u(i)=Yprime(1);
    v(i)=Yprime(2);

end
quiver(x,y,u,v,'r')
axis tight equal
xlabel('S (susceptibles)');ylabel('I (infected)');
title('Phase Plane SIR');
hold on

%solve ODEs
for y10=[0:1:1]
    for y20=[0:0.05:0.7]
    options=odeset('MaxStep',0.1);
    [ts,ys]=ode45(SIR,[0,4000],[y10,y20],options);
    plot(ys(:,1),ys(:,2), 'Linewidth', 1.5)
    hold on
    end
end
saveas(gcf,"./results/simulations/SIRPhasePlane.png")
hold off
