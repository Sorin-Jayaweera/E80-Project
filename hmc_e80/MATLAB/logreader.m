% logreader.m
% Use this script to read data from your micro SD card

clear;
%clf;

filenum = '019'; % file number for the data you want to read
infofile = strcat('INF', filenum, '.txt');
datafile = strcat('LOG', filenum, '.bin');

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

%% Process your data here

zcAccel = [accelX-mean(accelX),accelY-mean(accelY),accelZ-mean(accelZ)];

figure; plot(zcAccel); 
title("Zero Centered Acceleration");
legend("x","y","z");
xlabel("Time [samples]"); 
ylabel("Acceleration [cm/s^2]") 


figure; plot(accelX); 
title("X Acceleration");
xlabel("Time [samples]"); 
ylabel("Acceleration [cm/s^2]") 


figure; plot(accelY); 
title("Y Acceleration");
xlabel("Time [samples]"); 
ylabel("Acceleration [cm/s^2]") 

figure; plot(accelZ); 
title("Z Acceleration");
xlabel("Time [samples]"); 
ylabel("Acceleration [cm/s^2]") 


%%
range = [374:498];


[hxy,pxy] = ttest2(accelX(range),accelY(range));
[hxz,pxz] = ttest2(accelX(range),accelZ(range));
[hzy,pyz] = ttest2(accelZ(range),accelY(range));

%%

[hxy,pxy] = ttest2(zcAccel(range,1),zcAccel(range,2));
[hxz,pxz] = ttest2(zcAccel(range,1),zcAccel(range,3));
[hzy,pyz] = ttest2(zcAccel(range,2),zcAccel(range,3));

%%
disp(sprintf("xy p= %.8f",pxy));
disp(sprintf("xz p= %.8f",pxz));
disp(sprintf("yz p= %.8f",pyz));

%%
a = 1:100;
b = 1:100;
[h,p] = ttest2(a',b')

%%

figure; plot(accelZ(500:630)); title("Raw Z Acceleration"); subtitle("During Non Handling Time"); xlabel("time [Samples]");ylabel("cm/s^2");
hold on; plot(max(accelZ(500:630)) + 0.*accelZ,'r')
%%

d = accelZ(range);

m = mean(d);
%stdev = std(d);
n = length(d);

stdmean = m/sqrt(n);
dof = n-1;

t = tinv([0.025 0.975],dof);
ci = t*stdmean