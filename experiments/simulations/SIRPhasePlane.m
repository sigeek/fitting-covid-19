S0=0.8;
I0=0.2;
beta=0.3;
gamma=1/10;
mu=5e-5;

SIR=@(t,y)[mu-beta*y(1)*y(2)-mu*y(1);beta*y(1)*y(2)-gamma*y(2)-mu*y(2)];

y1=linspace(0,1,20);
y2=linspace(0,1,20);
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
for y10=[0:0.2:1]
    for y20=[0:0.2:1]
    options=odeset('MaxStep',0.1);
    [ts,ys]=ode45(SIR,[0,4000],[y10,y20],options);
    plot(ys(:,1),ys(:,2))
    end
end
saveas(gcf,"./results/simulations/SIRPhasePlane.png")
hold off
