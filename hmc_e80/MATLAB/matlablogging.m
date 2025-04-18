% matlablogging
% reads from Teensy data stream

function teensyanalog=matlablogging(length)
    length = 5000;  % 5000 is hardcoded buffer size on Teensy
    s = serial('COM5','BaudRate',115200);%Port_#0006.HUB_#0002
    set(s,'InputBufferSize',2*length)
    fopen(s);
    fprintf(s,'%d',2*length)         % Send length to Teensy
    dat = fread(s,2*length,'uint8');      
    fclose(s);
    teensyanalog = uint8(dat);
    teensyanalog = typecast(teensyanalog,'uint16');
end

%%
%sig = ans
%a = sig./150
%disp(sprintf(' %.4f',max(sig./150)))

%str = fscanf(s);
%teensyanalog = str2num(str);

%[teensyanalog, count] = fscanf(s,['%d']);