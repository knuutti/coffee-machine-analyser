clc
close all
clearvars

a = readtable('kahvidata.txt');

huonot = [find(a.coffee < 1)];
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

figure

xx = times.Hour + times.Minute./60 + times.Second./3600;
hold on
%sekunnit = datenum(a.aika(:), 'hh:mm:ss')

plot(times,coffee,'b:')
axis tight;grid on

liukuva = coffee;
step = 3;


for i = step+1:length(times)-step
    liukuva(i) = median(liukuva(i-step:i+step));
end

diffs = diff(liukuva); diffs = [0;diffs];

good_diffs = [];
for i = 2:length(diffs)-1
    if sum(diffs(i-1:i+1)) == 0
        good_diffs = [good_diffs i];
    end
end

times_cutted = [];
smoothen_cutted = [];
for i = 1:length(liukuva)
    if length(find(good_diffs==i)) == 1
        times_cutted = [times_cutted times(i)];
        smoothen_cutted = [smoothen_cutted liukuva(i)];
    end
end


%plot(times,diffs,'g', LineWidth=1)
%plot(times(step+1:end-step),liukuva(step+1:end-step),'g', LineWidth=1)

t1 = [];
t2 = [];
for i = 1:length(times_cutted)-1
    d = times_cutted(i+1)-times_cutted(i);
    if d > duration(1,0,0)
        t1 = [t1 ; times_cutted(i+1)];
        t2 = [t2 ; smoothen_cutted(i)];
        plot(t1, t2, 'r', LineWidth=2)
        t1 = [];
        t2 = [];
    else
        t1 = [t1 ; times_cutted(i)];
        t2 = [t2 ; smoothen_cutted(i)];
    end
end

plot(t1, t2, 'r', LineWidth=2)
ylabel('coffee coefficient')
xlabel('time')
legend('measured', 'analysed')
