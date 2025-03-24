function [X,f]=fdomainsingle(x,Fs)
    % FDOMAINSINGLE Function to compute the Fourier coefficients from vector x
    %   and the corresponding frequencies (single-sided)
    % usage:
    %   [X,f]=fdomainsingle(x,fs)
    %         x=vector of time domain samples
    %        fs=sampling rate (in Hz)
    %         X=vector of complex Fourier coefficients
    %         f=vector of corresponding frequencies (single-sided)
    
    N=length(x);
    
    if mod(N,2)==0
        k=-N/2:N/2-1; % N even
    else
        k=-(N-1)/2:(N-1)/2; % N odd
    end
    
    T=N/Fs;
    fdouble=k/T;
    Xdouble=fft(x)/N; % make up for the lack of 1/N in Matlab FFT
    Xdouble=fftshift(Xdouble);
    
    % Convert to single-sided spectrum
    dcIndex = floor(length(fdouble)/2)+1;
    f = fdouble(dcIndex:end);
    X = Xdouble(dcIndex:end);
    % Remember to double the non-DC components since it's a single sided
    % spectrum!
    X(2:end) = 2.*X(2:end);
end