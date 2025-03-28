% The x, r, and y below are for testing. Comment them out and add yor own
% data to the sample data at the end of the comments, and uncomment your
% data
% x = 1:0.5:10;
% r = normrnd(0,1,[1,length(x)]);
% y = 3*x-5+r;
% Script for the linear fit of data. The independent values are
% in the x array and the matched dependent values are in the y array. This
% script does not use MATLAB's built-in fitting functions, but uses the
% formulas from the videos/class notes.
% You also need to enter the confidence level, typically 95%. The values
% that are calculated and displayed are:
% 1. Beta_hat_1 (the best-fit slope)
% 2. Beta_hat_0 (the best-fit y-intercept)
% 3. The Root Mean Square Residual, Se
% 4. The Standard Error for beta0, Sbeta0
% 5. The Standard Error for beta1, Sbeta1
% 6. The confidence intervals for beta1 and beta0.
% After calculating these quantities, the script plots the original data,
% the best fit line, and the upper and lower bounds for the confidence
% interval on the best fit line.

x =data.PercentOn %[7.5 4 6 5 8]; % Uncomment and add your own data
y =  data.velocity%[3.70 3.10 3.32 2.98 3.68]; % Uncomment and add your own data
confLev = 0.95; % The confidence level
N = length(y); % The number of data points
xbar = mean(x);
ybar = mean(y);
Sxx = dot((x-xbar),(x-xbar));
%Sxx = (x-xbar)*transpose(x-xbar);
% beta1 is the estimated best slope of the best-fit line
beta1 = dot((x-xbar),(y-ybar))/Sxx
% beta1 = ((x-xbar)*transpose(y-ybar))/Sxx
% beta0 is the estimated best-fit y-intercept of the best fit line
beta0 = ybar - beta1*xbar
yfit = beta0 + beta1*x;
SSE = dot((y - yfit),(y - yfit)) % Sum of the squared residuals
% SSE = (y - yfit)*transpose(y - yfit) % Sum of the squared residuals
Se = sqrt(SSE/(N-2)) % The Root Mean Square Residual
Sbeta0 = Se*sqrt(1/N + xbar^2/Sxx)
Sbeta1 = Se/sqrt(Sxx)
% tinv defaults to 1-sided test. We need 2-sises, hence:(1-0.5*(1-confLev))
StdT = tinv((1-0.5*(1-confLev)),N-2) % The Student's t factor
lambdaBeta1 = StdT*Sbeta1 % The 1/2 confidence interval on beta1
lambdaBeta0 = StdT*Sbeta0 % The 1/2 confidence interval on beta0
range = max(x) - min(x);
xplot = min(x):range/30:max(x); % Generate array for plotting
yplot = beta0 + beta1*xplot; % Generate array for plotting
Syhat = Se*sqrt(1/N + (xplot - xbar).*(xplot - xbar)/Sxx);
lambdayhat = StdT*Syhat;
Sy = Se*sqrt(1+1/N + (xplot - xbar).*(xplot - xbar)/Sxx);
lambday = StdT*Sy;
figure(1)
plot(x,y,'x')
hold on
plot(xplot,yplot)
plot(xplot,yplot+lambdayhat,'-.b',xplot,yplot-lambdayhat,'-.b')
plot(xplot,yplot+lambday,'--m',xplot,yplot-lambday,'--m')
xlabel('% Activation')
ylabel('Wind Speed')
title("% Tunnel Activation to Velocity Calibration Curve")
if beta1 > 0 % Fix this
    location = 'northwest';
else
    location = 'northeast';
end
legend('Data Points','Best Fit Line','Upper Func. Bound',...
    'Lower Func. Bound', 'Upper Obs. Bound', 'Lower Obs. Bound',...
    'Location', location)
hold off

% %%
% figure(2)
% plot(x,y,'x')
% subtitle(sprintf("%.3f + %.3fx",beta0,beta1))
% hold on
% plot(xplot,yplot)
% legend("Real Data","Fit")
% title("RPM to Velocity Fit")
% xlabel("RPM")
% ylabel("Velocity [m/s]")

