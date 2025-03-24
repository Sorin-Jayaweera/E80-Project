sample1 = readtable("tank_data_measurements\scope_161.csv");
sample2 = readtable("tank_data_measurements\scope_156.csv");
sample3 = readtable("tank_data_measurements\scope_157.csv");
sample4 = readtable("tank_data_measurements\scope_158.csv");
sample5 = readtable("tank_data_measurements\scope_159.csv");
sample6 = readtable("tank_data_measurements\scope_160.csv");

distancesArrayIN = [1.1,2.2,3.3,4.4,5.5,6.6];
distancesArrayCM = 2.54*distancesArrayIN;

d1 = table2array(sample1);
d2 = table2array(sample2);
d3 = table2array(sample3);
d4 = table2array(sample4);
d5 = table2array(sample5);
d6 = table2array(sample6);

%%
d1_finalidx = 1980;
d2_finalidx = 1980;
d3_finalidx = 1980;
d4_finalidx = 1980;
d5_finalidx = 1980;
d6_finalidx = 1980;

d1 = d1(3:d1_finalidx,:);
d2 = d2(3:d2_finalidx,:);
d3 = d3(3:d3_finalidx,:);
d4 = d4(3:d4_finalidx,:);
d5 = d5(3:d5_finalidx,:);
d6 = d6(3:d6_finalidx,:);
%%
% figure; plot(d1(:,1),d1(:,2))
% figure; plot(d2(:,1),d2(:,2))
% figure; plot(d3(:,1),d3(:,2))
% figure; plot(d4(:,1),d4(:,2))
% figure; plot(d5(:,1),d5(:,2))
% figure; plot(d6(:,1),d6(:,2))
%%
power1 = sum(d1(:,2).^2,'all')/length(power1);
power2 = sum(d2(:,2).^2,'all')/length(power1);
power3 = sum(d3(:,2).^2,'all')/length(power1);
power4 = sum(d4(:,2).^2,'all')/length(power1);
power5 = sum(d5(:,2).^2,'all')/length(power1);
power6 = sum(d6(:,2).^2,'all')/length(power1);

powerArr = [power1,power2,power3,power4,power5,power6];
%%
Pcenter = power1;
hypotheticalSamples = distancesArrayCM(1):0.1:distancesArrayCM(end);
hypotheticalPowers = 1800 * 1./(hypotheticalSamples);%Pcenter * 1./(hypotheticalSamples);
figure;
plot(distancesArrayCM,powerArr);
hold on;
plot(hypotheticalSamples,hypotheticalPowers )
legend("real data", "hypothetical data without reflections")
xlabel("Distance from Source [cm]")
ylabel("RMS Power")
title("Recieved power vs Distance from Source")

%%
figure;
plot(d1(:,2).^2)
hold on;
plot(d2(:,2).^2)
plot(d3(:,2).^2)
plot(d4(:,2).^2)
plot(d5(:,2).^2)
plot(d6(:,2).^2)

%%
figure;
plot(d1(:,2))
plot(d2(:,2))
plot(d3(:,2))
plot(d4(:,2))
hold on;
plot(d5(:,2))
plot(d6(:,2))
legend(sprintf("%.2f",distancesArrayCM(1)),sprintf("%.2f",distancesArrayCM(2)),sprintf("%.2f",distancesArrayCM(3)),sprintf("%.2f",distancesArrayCM(4)),sprintf("%.2f",distancesArrayCM(5)),sprintf("%.2f",distancesArrayCM(6)))
title("Recorded Signals by Distance")
xlabel("Time [samples]")
ylabel("Voltage [V]")
%%

figure;

tiledlayout(3,1)
nexttile
plot(d4(:,2))
title("Distance = "+sprintf("%.2f",distancesArrayCM(4)))

nexttile
plot(d5(:,2))
title("Distance = "+sprintf("%.2f",distancesArrayCM(5)))
nexttile
plot(d6(:,2))
title("Distance = "+sprintf("%.2f",distancesArrayCM(6)))