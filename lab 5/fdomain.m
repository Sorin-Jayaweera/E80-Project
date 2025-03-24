function [X,f]=fdomain(x,Fs)
% FDOMAIN Function to compute the Fourier coefficients from vector x
%   and the corresponding frequencies (two-sided)
% usage:
%   [X,f]=fdomain(x,Fs)
%         x=vector of time domain samples
%         Fs=sampling rate (in Hz)
%         X=vector of complex Fourier coefficients
%         f=vector of corresponding frequencies (two-sided)

N=length(x);

if mod(N,2)==0
    k=-N/2:N/2-1; % N even
else
    k=-(N-1)/2:(N-1)/2; % N odd
end

T0=N/Fs;    % Duration of signal
f=k/T0;     % wavenumbers (k) divided by T0 = frequencies
X=fft(x)/N    ; % Matlab's FFT uses a different convention without the 1/N so we put it in here.
X=fftshift(X);

end

% t = 0.1
% 
% t =
% 
%     0.1000
% 
% t = 0:0.1:1
% 
% t =
% 
%          0    0.1000    0.2000    0.3000    0.4000    0.5000    0.6000    0.7000    0.8000    0.9000    1.0000
% 
% x = cos(2*pi, t)
% Error using cos
% Too many input arguments.
% 
% x = cos(2*pi*t)
% 
% x =
% 
%     1.0000    0.8090    0.3090   -0.3090   -0.8090   -1.0000   -0.8090   -0.3090    0.3090    0.8090    1.0000
% 
% help fdomain
%   fdomain Function to compute the Fourier coefficients from vector x
%     and the corresponding frequencies (two-sided)
%   usage:
%     [X,f]=fdomain(x,Fs)
%           x=vector of time domain samples
%           Fs=sampling rate (in Hz)
%           X=vector of complex Fourier coefficients
%           f=vector of corresponding frequencies (two-sided)
% 
% [X, f] = fdomain(x, 0.1)
% 
% X =
% 
%   Columns 1 through 6
% 
%   -0.0002 + 0.0014i  -0.0020 + 0.0045i  -0.0078 + 0.0090i  -0.0312 + 0.0201i   0.4958 - 0.1456i   0.0909 + 0.0000i
% 
%   Columns 7 through 11
% 
%    0.4958 + 0.1456i  -0.0312 - 0.0201i  -0.0078 - 0.0090i  -0.0020 - 0.0045i  -0.0002 - 0.0014i
% 
% 
% f =
% 
%    -0.0455   -0.0364   -0.0273   -0.0182   -0.0091         0    0.0091    0.0182    0.0273    0.0364    0.0455
% 
% stem(f, abs(X))
% xlabel("Hz")
% ylabel("X")
% [X, f] = fdomain(x, 10)
% 
% X =
% 
%   Columns 1 through 6
% 
%   -0.0002 + 0.0014i  -0.0020 + 0.0045i  -0.0078 + 0.0090i  -0.0312 + 0.0201i   0.4958 - 0.1456i   0.0909 + 0.0000i
% 
%   Columns 7 through 11
% 
%    0.4958 + 0.1456i  -0.0312 - 0.0201i  -0.0078 - 0.0090i  -0.0020 - 0.0045i  -0.0002 - 0.0014i
% 
% 
% f =
% 
%    -4.5455   -3.6364   -2.7273   -1.8182   -0.9091         0    0.9091    1.8182    2.7273    3.6364    4.5455
% 
% stem(f, abs(X))
