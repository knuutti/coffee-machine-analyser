clc
close all
clearvars

a = readtable('kahvidata.txt');

huonot = find(~isnan(a.coffee));
a = a(huonot,:);

% karsitaan alkudata
t0 = a.time(1);
inds = [];
for i = 2:length(a.time)
    d = a.time(i)-t0;
    if d > duration(0,0,13)
        inds = [inds i];
        t0 = a.time(i);
    end
end
a = a(inds,:);


times = a.time;
coffee = a.coffee;

xx = times.Hour + times.Minute./60 + times.Second./3600;
hold on
%sekunnit = datenum(a.aika(:), 'hh:mm:ss')

plot(times,coffee,'b')
axis tight;grid on

liukuva = coffee;
step = 8;


for i = step+1:length(times)-step
    liukuva(i) = median(liukuva(i-step:i+step));
end

diffs = diff(liukuva); diffs = [0;diffs];


plot(times,diffs,'g', LineWidth=1)
plot(times(step+1:end-step),liukuva(step+1:end-step),'r', LineWidth=2)
