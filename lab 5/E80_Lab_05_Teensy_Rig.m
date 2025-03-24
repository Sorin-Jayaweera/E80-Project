%% Lab 5 Interface

samplingFreq = 100E3; % Hz [100E3 max]
numSamples = 1000; % the higher this is the longer sampling will take

bytesPerSample = 2; % DO NOT CHANGE
micSignal = zeros(numSamples,1); % DO NOT CHANGE

% close and delete serial ports in case desired port is still open
if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
end

% Modify first argument of serial to match Teensy port under Tools tab of Arduino IDE.  Second to match baud rate.
% Note that the timeout is set to 60 to accommodate long sampling times.
s = serial('COM10','BaudRate',115200); 
set(s,{'InputBufferSize','OutputBufferSize'},{numSamples*bytesPerSample,4});
s.Timeout = 60; 

fopen(s);
pause(2);
fwrite(s,[numSamples,samplingFreq/2],'uint16');
dat = fread(s,numSamples,'uint16');
fclose(s);
%%
% Some convenience code to begin converting data for you.
dat = sin(4*pi * [0:1/samplingFreq:1])
micSignal = dat.*(3.3/1023); % convert from Teensy Units to Volts
samplingPeriod = 1/samplingFreq; % s
totalTime = numSamples*samplingPeriod; % s
t = linspace(0,totalTime,numSamples)'; % time vector of signal


switcher = 2;
disp("click enter to continuee, but check the variable is appropriately named")
pause

if(switcher == 1)
    sig1 = micSignal; %10 kS/s
    sig1Fs = samplingFreq;
else
    sig2 = micSignal; % 100 kS/s
    sig2Fs = samplingFreq;
end
%%

figure; 
plot(1/sig1Fs*[1:length(sig1)],sig1);
title("Sig 1");
%hold on;
figure;
plot(1/sig2Fs*[1:length(sig2)],sig2);
title("Sig 2");

%%

[dx, ffx]= fdomain(sig1,sig1Fs);
[dy, ffy]= fdomain(sig2,sig2Fs);

figure; 
plot(ffx, abs(dx))
hold on;
plot(ffy, abs(dy))
title("FFT");
legend("10 kS/s", "100 kS/s")



%%
figure
tiledlayout(1,2)
nexttile
plot([1:100]*sig1Fs,sig1(1:100))
xlabel("Time [s]")

nexttile
plot([1:100]*sig2Fs,sig2(1:100))
xlabel("Time [s]")


%%
[dx, ffx]= fdomainsingle(sig1,sig1Fs);
[dy, ffy]= fdomainsingle(sig2,sig2Fs);
figure; 
plot(ffx, abs(dx))
hold on;
plot(ffy, abs(dy))
title("FFT");
legend("10 kS/s", "100 kS/s")



%%
sig1fft = abs(fft(sig1));
sig2fft = abs(fft(sig2));

figure;
plot(sig1Fs/(length(sig1))*(0:length(sig1)-1), sig1fft );
hold on;
plot(sig2Fs/(length(sig2))*(0:length(sig2)-1), sig2fft );
title("FFT")
xlabel("Freq [Hz]")
ylabel("Complex Magnitude")
legend("10 kS/s","100 kS/s")