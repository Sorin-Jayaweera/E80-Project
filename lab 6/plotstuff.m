
close all
clear
clc

flatPlateLiftCoeff= ...
    [0.0001539939936 0.000159174863 0.0001696671582 0.0001877435053 0.0002174978982;...
    0.0004765066667 0.0004761481481 0.000476 0.0004760163265 0.000475983539;
    0.00122216 0.001221511111 0.001221653333 0.001221714286 0.001221662551;
    ];
airFoilLiftCoeff= ...
    [
    0.00006058133333 0.0000584562963 0.0000581632 0.00005807346939 0.00005805761317;
    0.00056016 0.0005561481481 0.0005553173333 0.000555047619 0.0005548312757;
    0.00138216 0.001362103704 0.001380373333 0.001374857143 0.001380279835;    ];

reynoldsNumber= ...
[
337837.8378 1013513.514 1689189.189 2364864.865 3040540.541;
337837.8378 1013513.514 1689189.189 2364864.865 3040540.541;
337837.8378 1013513.514 1689189.189 2364864.865 3040540.541; ];
%%

figure;
plot(reynoldsNumber(1,:),airFoilLiftCoeff(1,:)-flatPlateLiftCoeff(1,:))
hold on;
plot(reynoldsNumber(2,:),airFoilLiftCoeff(2,:)-flatPlateLiftCoeff(2,:))
plot(reynoldsNumber(3,:),airFoilLiftCoeff(3,:)-flatPlateLiftCoeff(3,:))
title("Improvement in Lift Coefficient by Wind speed")
subtitle("Foil - Flat Plate")
xlabel("Reynolds Number");
ylabel("\Delta C_{L}");
legend("5 Deg", "15 Deg", "45 Deg");


%%

figure;
plot(reynoldsNumber(1,:),(airFoilLiftCoeff(1,:)-flatPlateLiftCoeff(1,:))./airFoilLiftCoeff(1,:) * 100)
hold on;
plot(reynoldsNumber(1,:),(airFoilLiftCoeff(2,:)-flatPlateLiftCoeff(2,:))./airFoilLiftCoeff(2,:)* 100)
plot(reynoldsNumber(1,:),(airFoilLiftCoeff(3,:)-flatPlateLiftCoeff(3,:))./airFoilLiftCoeff(3,:)* 100)
title("Percent Improvement in Lift Coefficient by Wind speed")
subtitle("(C_{Foil} - C_{Flat Plate} ) / (C_{Foil}) * 100%")
xlabel("Reynolds Number");
ylabel("% Improvement");
legend("5 Deg", "15 Deg", "45 Deg");

%%

figure;
plot(reynoldsNumber(1,:),(airFoilLiftCoeff(1,:)-flatPlateLiftCoeff(1,:))./flatPlateLiftCoeff(1,:) * 100)
hold on;
plot(reynoldsNumber(1,:),(airFoilLiftCoeff(2,:)-flatPlateLiftCoeff(2,:))./flatPlateLiftCoeff(2,:)* 100)
plot(reynoldsNumber(1,:),(airFoilLiftCoeff(3,:)-flatPlateLiftCoeff(3,:))./flatPlateLiftCoeff(3,:)* 100)
title("Percent Improvement in Lift Coefficient by Wind speed")
subtitle("(C_{Foil} - C_{Flat Plate} ) / (C_{Flat Plate}) * 100%")
xlabel("Reynolds Number");
ylabel("% Improvement");
legend("5 Deg", "15 Deg", "45 Deg");


%%
figure;
plot(reynoldsNumber(1,:), airFoilLiftCoeff(1,:)./flatPlateLiftCoeff(1,:) * 100)
hold on;
plot(reynoldsNumber(2,:), airFoilLiftCoeff(2,:)./flatPlateLiftCoeff(2,:) * 100)
plot(reynoldsNumber(3,:), airFoilLiftCoeff(3,:)./flatPlateLiftCoeff(3,:) * 100)
title("Percent Improvement in Lift Coefficient by Wind speed")
subtitle("(C_{Foil}/ C_{Flat Plate} ) * 100%")
xlabel("Reynolds Number");
ylabel("% Improvement");
legend("5 Deg", "15 Deg", "45 Deg");

