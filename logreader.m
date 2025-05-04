% logreader.m
% Use this script to read data from your micro SD card


clear;
%clf;

filenum = '000'; % file number for the data you want to read
infofile = strcat('inf', filenum, '.txt');
datafile = strcat('log', filenum, '.bin');

%% map from datatype to length in bytes
dataSizes.('float') = 4;
dataSizes.('ulong') = 4;
dataSizes.('int') = 4;
dataSizes.('int32') = 4;
dataSizes.('uint8') = 1;
dataSizes.('uint16') = 2;
dataSizes.('char') = 1;
dataSizes.('bool') = 1;

%% read from info file to get log file structure
fileID = fopen(infofile);
items = textscan(fileID,'%s','Delimiter',',','EndOfLine','\r\n');
fclose(fileID);
[ncols,~] = size(items{1});
ncols = ncols/2;
varNames = items{1}(1:ncols)';
varTypes = items{1}(ncols+1:end)';
varLengths = zeros(size(varTypes));
colLength = 256;
for i = 1:numel(varTypes)
    varLengths(i) = dataSizes.(varTypes{i});
end
R = cell(1,numel(varNames));

%% read column-by-column from datafile
fid = fopen(datafile,'rb');
for i=1:numel(varTypes)
    %# seek to the first field of the first record
    fseek(fid, sum(varLengths(1:i-1)), 'bof');
    
    %# % read column with specified format, skipping required number of bytes
    R{i} = fread(fid, Inf, ['*' varTypes{i}], colLength-varLengths(i));
    eval(strcat(varNames{i},'=','R{',num2str(i),'};'));
end
fclose(fid);

%%
dataTitle = "pier 2, log 2";
datraw = readtable("danapoint/pier2_deeper/log6.csv");%bigkayaktrip1/log15.csv");

dat = table2array(datraw);

presraw = dat(:,1);
turbraw = dat(:,2);
phraw = dat(:,3);
temperatureraw = dat(:,4);
salinityraw = dat(:,5);
time = dat(:,6)./1000;
uV = dat(:,7);


depth = -0.858*presraw+2.19; % meters
ph = -1.11*phraw+10.7; % PH on log scale is maybe not linear?
turbidity = -376*turbraw+1111;
salinity = 2.02e-4*exp(2.08*salinityraw);
temperature = 9.14*temperatureraw-3.28;


% figure;
% plot(time,presraw)
% hold on;
% plot(time,turbraw)
% plot(time,phraw)
% plot(time,temperatureraw)
% plot(time,salinityraw)
% legend("pressure","turbidity","PH","temperature","salinity")
% title("Sensor Voltages")

tiledlayout(2,2)
figure

nexttile
scatter(depth,temperature,10,1:length(turbidity))
title("Temperature")
xlabel("depth [m]")
ylabel("Temperature [C]")
nexttile

scatter(depth, turbidity,10,1:length(turbidity))
title("Turbidity")
xlabel("depth [m]")
ylabel("Turbidity [NTU]")
nexttile

scatter(depth, salinity,10,1:length(turbidity))

title("Salinity")
xlabel("depth [m]")
ylabel("TDS [ppm]")
nexttile

scatter(depth, ph,10,1:length(turbidity))

title("PH")
xlabel("depth [m]")
ylabel("PH")

sgtitle(dataTitle)

%%
close all
pierOfficial = [33.46221,-117.7058];
pierUnofficial = [33.46180556,-117.70418];
stop1 = [33.4619,-117.7048];
stop2 = [33.46155,-117.7046];
stop3 = [33.46125,-117.7052];

latlonSites = [pierUnofficial;pierOfficial;stop1;stop2;stop3];
latlonTests = [pierOfficial;pierOfficial;stop1;stop2;stop3];


filenames = ["log2.csv","log6.csv","log12.csv","log10.csv","log14.csv"];
filepath = "E80-Project/danapoint/"+["pier2/","pier2_deeper/","bigkayaktrip1/","bigkayaktrip1/","bigkayaktrip1/"];
siteNames = ["private pier", "public pier", "kayak 1", "kayak 2", "kayak 3"];
diveNames = ["pier", "pier deep", "kayak 2","kayak 1",  "kayak 3"];


%[ewrelpos,nsrelpos] = latlon2local(latlonSites(:,1), latlonSites(:,2),0.*latlonSites(:,1), [latlonSites(1,1), latlonSites(1,2),0]);
[ewrelposSites,nsrelposSites] = gps2xyref(latlonSites(:,1), latlonSites(:,2), latlonSites(1,1), latlonSites(1,2));
[ewrelposTests,nsrelposTests] = gps2xyref(latlonTests(:,1), latlonTests(:,2), latlonTests(1,1), latlonTests(1,2));

distSites = sqrt(ewrelposSites.^2 + nsrelposSites.^2)';
dist = sqrt(ewrelposTests.^2 + nsrelposTests.^2)';
dist(1) = 0.2; % private pier
dist(2) = 0; % public pier
diststr = strings(1,length(siteNames));

for i = 1:length(siteNames)
   diststr(i) = sprintf("%s: %.1f", siteNames(i),distSites(i));
end

%%

figure
geoscatter(latlonSites(:,1)', latlonSites(:,2)',50, 1:length(latlonSites),"filled"); geobasemap satellite
text(latlonSites(:,1),latlonSites(:,2),diststr',"Color","Red", 'FontSize',14)
title("Approximate Distance from Structures")
%%
maxLen = 0;
for i = 1:1:length(filenames)

    datraw = readtable(filepath(i)+filenames(i));
    dat = table2array(datraw);
    l = length(dat);
    if(l > maxLen)
        maxLen = l;
    end
end

depthArr = zeros(length(filenames),maxLen);
tempArr = zeros(length(filenames),maxLen);
salinityArr = zeros(length(filenames),maxLen);
turbArr = zeros(length(filenames),maxLen);
phArr = zeros(length(filenames),maxLen);
timeArr = zeros(length(filenames),maxLen);

tempRawArr = zeros(length(filenames),maxLen);

for i = 1:1:length(filenames)
    datraw = readtable(filepath(i)+filenames(i));
    dat = table2array(datraw);
        
    presraw = dat(:,1);
    turbraw = dat(:,2);
    phraw = dat(:,3);
    temperatureraw = dat(:,4);
    salinityraw = dat(:,5);
    time = dat(:,6)./1000;
    uV = dat(:,7);

    depth = -0.858*presraw+2.19; % meters
    ph = -1.11*phraw+10.7; % PH on log scale is maybe not linear?
    turbidity = -376*turbraw+1111;
    salinity = 2.02e-4*exp(2.08*salinityraw);
    temperature = -7.81*temperatureraw+25.7;%-9.27*temperatureraw+26.5;
    

    depthArr(i,:) = depthArr(i,:) + padarray(depth',[0,maxLen-length(depth)],'post'); 
    tempArr(i,:) = tempArr(i,:) + padarray(temperature',[0,maxLen-length(temperature)],'post');
    salinityArr(i,:) = salinityArr(i,:) + padarray(salinity',[0,maxLen-length(salinity)],'post');
    turbArr(i,:) = turbArr(i,:) + padarray(turbidity',[0,maxLen-length(turbidity)],'post');
    phArr(i,:)= phArr(i,:) + padarray(ph',[0,maxLen-length(ph)],'post');
    
    timeArr(i,:)= timeArr(i,:) + padarray(time',[0,maxLen-length(time)],'post');
    
    tempRawArr(i,:)= tempRawArr(i,:) + padarray(temperatureraw',[0,maxLen-length(temperatureraw)],'post');
end
%%
figure;
plot(timeArr'/1000,depthArr')
xlabel("Time [S]")
ylabel("Depth [m]")
legend(diveNames)
title("Diving Path")

%%
figure;
plot(tempArr')
title("Temperature vs time")
xlabel("Time [samples]")
ylabel("Temperature [c]")

%%
figure;
plot(tempRawArr')
title("Temperature Voltage vs time")
xlabel("Time [samples]")
ylabel("Voltage [V]")
%%

figure("color","white");
tiledlayout(2,2)
nexttile
plot(timeArr'./1000,depthArr'); title("Depths Achieved"); legend(diveNames); ylabel("Depth [m]"); xlabel("Time [S]"); 
nexttile

plot(depthArr',turbArr'); title("Turbidity vs Depth"); xlabel("Depth [m]"); ylabel("Turbidity [NTU]"); xlim([0,max(max(depthArr))]) %legend(diveNames);
nexttile

plot(depthArr',tempArr'); title("Temperature vs Depth"); xlabel("Depth [m]"); ylabel("Temperature [C]") ; xlim([0,max(max(depthArr))]) %legend(diveNames);
nexttile

plot(depthArr',salinityArr'); title("Salinity vs Depth ");xlabel("Depth [m]"); ylabel("Salinity [ppm]") ; xlim([0,max(max(depthArr))]) % legend(diveNames);
%%
figure
plot(depthArr',phArr'); title("PH vs depth for each dive"); legend(diveNames);xlabel("Depth [m]"); ylabel("PH") ; xlim([0,max(max(depthArr))])
%%

close all
clc
%% Now I want to explore the distance from shore with the trends.
%fist lets calculate the buckets for each depth and distance from shore in
%a nice way. Average temperature for a tiny sliver at each depth. This will
%have some not niceness close to the surface due to sensor settling times,
%but should be mostly nice. 
% Depth bucket , Dive number(in order of distance from shore) > 
%    V
depthExplorationArr = 0:0.1:2;
numDives = length(filenames);

% down is depth bucket, across is the dive number. 
[tempDepthBucket,avgTmpBucket] = getDepthBuckets(tempArr,depthArr,depthExplorationArr,numDives);
plotDepthBuckets(tempDepthBucket,avgTmpBucket,depthExplorationArr,dist,numDives,"Temperature", "C")

[turbDepthBucket,avgTurbBucket] = getDepthBuckets(turbArr,depthArr,depthExplorationArr,numDives);
plotDepthBuckets(turbDepthBucket,avgTurbBucket,depthExplorationArr,dist,numDives,"Turbidity", "NTU")

[salnDepthBucket,avgSalnBucket] = getDepthBuckets(salinityArr,depthArr,depthExplorationArr,numDives);
plotDepthBuckets(salnDepthBucket,avgSalnBucket,depthExplorationArr,dist,numDives,"Salinity", "PPM")

[phDepthBucket,phSalnBucket] = getDepthBuckets(phArr,depthArr,depthExplorationArr,numDives);
plotDepthBuckets(phDepthBucket,phSalnBucket,depthExplorationArr,dist,numDives,"PH", "")
%% Now I want to fit a curve to the data vs distance from structures



%%

for i = 1:length(filenames)
    figure
    tiledlayout(2,2)
   
    
    nexttile
    scatter(depthArr(i,:),tempArr(i,:),10,1:length(tempArr(i,:)))
    title("Temperature")
    xlabel("depth [m]")
    ylabel("Temperature [C]")
    nexttile
    
    scatter(depthArr(i,:), turbArr(i,:),10,1:length(turbArr(i,:)))
    title("Turbidity")
    xlabel("depth [m]")
    ylabel("Turbidity [NTU]")
    nexttile
    
    scatter(depthArr(i,:), salinityArr(i,:),10,1:length(salinityArr(i,:)))
    
    title("Salinity")
    xlabel("depth [m]")
    ylabel("TDS [ppm]")
    nexttile
    
    scatter(depth, ph,10,1:length(turbidity))
    
    title("PH")
    xlabel("depth [m]")
    ylabel("PH")
    
    sgtitle(diveNames(i))

end


%%

function [x,y] = gps2xyref(lat, lon, relLat, relLon)
    earthRadius = 6.371e6; % Meters

    y = (lat - relLat) * pi / 180 * earthRadius;
    x = (lon - relLon) * pi / 180 * cos(relLat * pi / 180) * earthRadius;
end

%length(filenames)
function [varGroupedByDepth,avgVar] = getDepthBuckets(varArr,depthArr,depthExplorationArr,numDives)
    % across is the dive type
    % down is the depth chunking

    delta = 0.1;
    varGroupedByDepth = cell(length(depthExplorationArr),numDives);
    
    avgVar = zeros(length(depthExplorationArr),numDives);
    for i=1:length(depthExplorationArr)
        %figure; 
        %hold on;
        for j = 1:numDives
            depthArrMask = depthArr(j,:) > depthExplorationArr(i)-delta & depthArr(j,:) <  depthExplorationArr(i) + delta;
            varGroupedByDepth{i,j} = varArr(j,depthArrMask);
            avgVar(i,j) = mean(nonzeros(varGroupedByDepth{i,j})); 
            %plot(dist(j)+0.*varGroupedByDepth{i,j},varGroupedByDepth{i,j})
            %scatter(dist(j),avgVar(i,j),'filled')
        end
        % ylabTxt = varname + " within \Delta" + sprintf("%.1f",delta);
        % ylabel(ylabTxt)
        % xlabel("distance [m]")
        % title(varname + " vs distance to shore"); subtitle(sprintf("Depth %f",depthExplorationArr(i)))
    end
    
end

function plotDepthBuckets(varGroupedByDepth,avgVar,depthExplorationArr,dist,numDives,varname, units)
    figure
    hold on;
    for i = 1:length(depthExplorationArr)
        for j = 1:numDives
            if(avgVar(i,j) > 0)
                scatter3(dist(j),depthExplorationArr(i),avgVar(i,j),20,depthExplorationArr(i),'filled')
                plot3(dist(j)+0.*varGroupedByDepth{i,j},depthExplorationArr(i) + 0.*varGroupedByDepth{i,j},varGroupedByDepth{i,j})
            end
        end
    end
    grid()
    xlabel("Distance from Structure [m]")
    ylabel("Depth Bucket")
    zlabel("Average " + varname +" in Bucket [" + units + "]")
    % "\color{255 255 255}"+varname + "Grouped by depth and distance from structure"
    title(varname + " grouped by depth and distance from structure","Color","white")
    colormap("spring")
    set(gca,'color',[0 0 0])
    set(gca, 'XColor', 'white')
    set(gca, 'YColor', 'white')
    set(gca, 'ZColor', 'white')
    set(gca, 'GridLineWidth', 1)
    set(gcf,'Color','black')
    view([-24 5])
end