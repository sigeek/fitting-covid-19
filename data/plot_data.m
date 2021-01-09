function [] = plot_data(data, dates, N, t0, tf, plot_type)

x0=100;
y0=100;
width=1200;
height=600;
set(gcf,'position',[x0,y0,width,height])

I = cast((data.totale_positivi), 'double');
E = 0.1*(I); 
R = cast((data.dimessi_guariti), 'double');
H = cast(data.totale_ospedalizzati, 'double');
D = cast(data.deceduti, 'double');
S = N-E-I-R-D;
len = tf-t0+1;

figure(1)
subplot(2,3,1)
plot(dates, S(t0:tf),'m', 'LineWidth',2);
xlabel('time');ylabel('Number of individuals');title('Susceptibles')
set(gca,'XLim',[dates(1), dates(len)])
subplot(2,3,2)
plot(dates, E(t0:tf),'b', 'LineWidth',2);
xlabel('time');ylabel('Number of individuals');title('Exposed')
set(gca,'XLim',[dates(1), dates(len)])
subplot(2,3,3)
plot(dates, I(t0:tf),'r', 'LineWidth',2);
xlabel('time');ylabel('Number of individuals');title('Infected')
set(gca,'XLim',[dates(1), dates(len)])
subplot(2,3,4)
plot(dates, R(t0:tf),'g', 'LineWidth',2);
xlabel('time');ylabel('Number of individuals');title('Recovered')
set(gca,'XLim',[dates(1), dates(len)])
subplot(2,3,5)
plot(dates, H(t0:tf),'c', 'LineWidth',2);
xlabel('time');ylabel('Number of individuals');title('Hospitalized')
set(gca,'XLim',[dates(1), dates(len)])
subplot(2,3,6)
plot(dates, D(t0:tf),'k', 'LineWidth',2);
xlabel('time');ylabel('Number of individuals');title('Deaths')
set(gca,'XLim',[dates(1), dates(len)])

if plot_type=="complete"
    saveas(gcf,'./results/overview_plot.png')
else
    saveas(gcf,'./results/october_plot.png')
end
end

