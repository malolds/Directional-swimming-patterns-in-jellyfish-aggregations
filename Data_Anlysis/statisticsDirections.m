%% Initialization
 
clc
close all
clear all
load('D:\Jellyfish swarm\00_Manuscript\01_Figures\01_Database_creation\01_Data\DataConcentrationTable_24-Feb-2023.mat')

%% Rayleigh test for uniforminty
% The lower the p the less uniform it is

% Jellyfish
circ_rtest(deg2rad(tMovies.mu))

% Optical waves
currInd = tMovies.flagOPW;
circ_rtest(deg2rad(tMovies.opWDir(currInd)))
[a b] = meancirc(tMovies.opWDir(currInd) - tMovies.mu(currInd))


% Optical currents
currInd = tMovies.flagOPC;
circ_rtest(deg2rad(tMovies.opcDir(currInd)))

[a b] = meancirc(tMovies.opcDir(currInd) - tMovies.mu(currInd))


% CMEMS wdir and stox
currInd = tMovies.flagCMEMS;
circ_rtest(deg2rad(tMovies.memsWDir(currInd)))
circ_rtest(deg2rad(tMovies.memsStoDir(currInd)))

% 

[mu kappa] = circ_vmpar(deg2rad(tMovies.mu))
p = circ_vmpdf(deg2rad(tMovies.mu),mu,kappa)
%% Correlation tests

% Optical waves
currInd = tMovies.flagOPW;
alpha = deg2rad(tMovies.mu(currInd)); beta = deg2rad(tMovies.opWDir(currInd));
[c p] = circ_corrcc(alpha, beta)
sum(currInd)

% Optical currents
currInd = tMovies.flagOPC;
alpha = deg2rad(tMovies.mu(currInd)); beta = deg2rad(tMovies.opcDir(currInd));
[c p] = circ_corrcc(alpha, beta)
sum(currInd)

% CMEMS waves
currInd = tMovies.flagCMEMS;
alpha = deg2rad(tMovies.mu(currInd)); beta = deg2rad(tMovies.memsWDir(currInd));
[c p] = circ_corrcc(alpha, beta)
sum(currInd)

% CMEMS Stox and jellyfish
currInd = tMovies.flagCMEMS;
alpha = deg2rad(tMovies.mu(currInd)); beta = deg2rad(tMovies.memsStoDir(currInd));
[c p] = circ_corrcc(alpha, beta)
sum(currInd)

% CMEMS waves and optical waves
currInd = tMovies.flagCMEMS & tMovies.flagOPC;
alpha = deg2rad(tMovies.opWDir(currInd)); beta = deg2rad(tMovies.memsWDir(currInd));
[c p] = circ_corrcc(alpha, beta)
sum(currInd)

% Jellyfish and zeros
currInd = tMovies.mu ~=0;
alpha = deg2rad(tMovies.mu(currInd)); beta = deg2rad(rand(1,sum(currInd))');
[c p] = circ_corrcc(alpha, beta)
sum(currInd)

% long short mean and jellydir
currInd = tMovies.flagCMEMS & tMovies.flagOPW;
alpha = deg2rad(tMovies.mu(currInd)); beta = circ_mean((deg2rad(tMovies.opWDir(currInd)' + tMovies.memsWDir(currInd)')));
[c p] = circ_corrcc(alpha, beta)
sum(currInd)

% Long short correlation
currInd = tMovies.flagCMEMS & tMovies.flagOPW;
alpha = deg2rad(tMovies.opWDir(currInd)); beta = deg2rad(tMovies.memsWDir(currInd));
[c p] = circ_corrcc(alpha, beta)
sum(currInd)

% Ind jelly sd vs long short diff
currInd = tMovies.flagOPC & tMovies.flagCMEMS;
alpha = abs(deg2rad(tMovies.opWDir(currInd) - tMovies.memsWDir(currInd)));
beta = deg2rad(tMovies.IndJellymeanSD(currInd));
[c p] = circ_corrcc(alpha, beta)
sum(currInd)

% Rayleigh test jellyfish
alpha = tMovies.mu;
p = circ_rtest(deg2rad(alpha))

% Rayleigh test Optical waves
currInd = tMovies.flagOPW;
alpha = tMovies.opWDir(currInd);
p = circ_rtest(deg2rad(alpha))

% Sun Position
c = 1;
for i = 1 : size(tMovies,1)
    if tMovies.flagSP(i)
        temp = tMovies.sunPos(i);
        azi(c) = temp.Azimuth;
        zen(c) = temp.Zenith;
        c = c + 1;
    end
end

alpha = deg2rad(tMovies.mu(tMovies.flagSP)); beta = deg2rad(azi)';
[c p] = circ_corrcc(alpha, beta)

[a b] = meancirc(tMovies.mu(tMovies.flagSP)-(90-azi'))


alpha = deg2rad(tMovies.mu(tMovies.flagSP)); beta = deg2rad(zen)';
[c p] = circ_corrcc(alpha, beta)

% Magnetic field
c = 1;
for i = 1 : size(tMovies,1)
    if tMovies.flagMF(i)
        temp = tMovies.magField(i);
        Dec(c) = temp.magDec;
        Inc(c) = temp.magInc;
        c = c + 1;
    end
end


alpha = deg2rad(tMovies.mu(tMovies.flagMF)); beta = deg2rad(Dec)';
[c p] = circ_corrcc(alpha, beta)
[a b] = meancirc(tMovies.mu(tMovies.flagMF)-(90-Dec'))




alpha = deg2rad(tMovies.mu(tMovies.flagMF)); beta = deg2rad(Inc)';
[c p] = circ_corrcc(alpha, beta)

% waves - waves anova
alpha = tMovies.mu(tMovies.flagOPW); beta = tMovies.opWDir(tMovies.flagOPW);
alpha = deg2rad(alpha); beta = deg2rad(beta);
p = circ_wwtest(alpha, beta)



%% Circular linear tests

% jelly direction and SD
alpha = tMovies.mu; x = tMovies.sd;
[c,p] = circ_corrcl(deg2rad(alpha), x)
sum(currInd)

% Wave direction and SD
currInd = tMovies.flagOPW;
alpha = tMovies.opWDir(currInd); x = tMovies.sd(currInd);
[c,p] = circ_corrcl(deg2rad(alpha), x)
sum(currInd)

% Wave direction and SD only 2020
currInd = tMovies.flagOPW & tMovies.Date~=20220704 & tMovies.Date~=20210707 & tMovies.Date~=20210629;
alpha = tMovies.opWDir(currInd); x = tMovies.sd(currInd);
[c,p] = circ_corrcl(deg2rad(alpha), x)
sum(currInd)

% current direction and SD
currInd = tMovies.flagOPC;
alpha = tMovies.opcDir(currInd); x = tMovies.sd(currInd);
[c,p] = circ_corrcl(deg2rad(alpha), x)
sum(currInd)

% JellyDir and T
currInd = tMovies.flagOPC;
alpha = tMovies.mu(currInd); x = tMovies.opT(currInd);
[c,p] = circ_corrcl(deg2rad(alpha), x)
sum(currInd)

% JellyDir and SWH
currInd = tMovies.flagOPC;
alpha = tMovies.mu(currInd); x = tMovies.opSWH(currInd);
[c,p] = circ_corrcl(deg2rad(alpha), x)
sum(currInd)

% JellyDir and current magnitude
currInd = tMovies.flagOPC;
alpha = tMovies.mu(currInd); x = tMovies.opcMag(currInd);
[c,p] = circ_corrcl(deg2rad(alpha), x)
sum(currInd)

% JellyDir and location
currInd = tMovies.flagCMEMS;
alpha = tMovies.mu(currInd); x = tMovies.Lat(currInd);
[c,p] = circ_corrcl(deg2rad(alpha), x)
sum(currInd)
alpha = tMovies.mu(currInd); x = tMovies.Long(currInd);
[c,p] = circ_corrcl(deg2rad(alpha), x)

% JellyDir and Depth
currInd = tMovies.flagOPC;
alpha = tMovies.mu(currInd); x = tMovies.Depth(currInd);
[c,p] = circ_corrcl(deg2rad(alpha), x)
sum(currInd)

% Long short diff with jellySD
currInd = tMovies.flagOPC & tMovies.flagCMEMS;
alpha = abs(deg2rad(tMovies.opWDir(currInd) - tMovies.memsWDir(currInd)));
x = tMovies.sd(currInd);
[c,p] = circ_corrcl((alpha), x)
sum(currInd)

% Long short diff with turtuosity
currInd = tMovies.flagOPC & tMovies.flagCMEMS;
alpha = abs(deg2rad(tMovies.opWDir(currInd) - tMovies.memsWDir(currInd)));
x = tMovies.mutau(currInd);
[c,p] = circ_corrcl((alpha), x)
sum(currInd)

% Long short diff with mean ind jelly sd
currInd = tMovies.flagOPC & tMovies.flagCMEMS;
alpha = abs(deg2rad(tMovies.opWDir(currInd) - tMovies.memsWDir(currInd)));
x = tMovies.IndJellymeanSD(currInd);
[c,p] = circ_corrcl((alpha), x)
sum(currInd)


% Long with jellySD
currInd =  tMovies.flagCMEMS;
alpha = deg2rad(tMovies.memsWDir(currInd));
x = tMovies.sd(currInd);
[c,p] = circ_corrcl((alpha), x)
sum(currInd)

% mean(Long short) with jellySD
currInd = tMovies.flagOPC & tMovies.flagCMEMS;
alpha = mean(deg2rad((tMovies.opWDir(currInd) - tMovies.memsWDir(currInd))),2);
x = tMovies.sd(currInd);
[c,p] = circ_corrcl((alpha), x)
sum(currInd)







%% Linear Linear tests

% SWH and sd
currInd = tMovies.flagOPW;
a = tMovies.opSWH(currInd); b = tMovies.sd(currInd);
[xData, yData] = prepareCurveData( a, b ); % Set up fittype and options.
ft = fittype( 'poly1' ); % Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );
size(a)

% T and sd
currInd = tMovies.flagOPW;
a = tMovies.opT(currInd); b = tMovies.sd(currInd);
[xData, yData] = prepareCurveData( a, b ); % Set up fittype and options.
ft = fittype( 'poly1' ); % Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );
size(a)

% Wave sd and jellysd
currInd = tMovies.flagOPW;
a = tMovies.opWDirsd(currInd); b = tMovies.sd(currInd);
[xData, yData] = prepareCurveData( a, b ); % Set up fittype and options.
ft = fittype( 'poly1' ); % Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );
size(a)

% Number of tracks and jelly sd
a = tMovies.nTracks; b = tMovies.sd;
[xData, yData] = prepareCurveData( a, b ); % Set up fittype and options.
ft = fittype( 'poly1' ); % Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );
size(a)

% Wavedirsd and jellysd
currInd = tMovies.flagOPW;
a = tMovies.opWDirsd(currInd); b = tMovies.sd(currInd);
[xData, yData] = prepareCurveData( a, b ); % Set up fittype and options.
ft = fittype( 'poly1' ); % Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );
size(a)

%%
close all

figure('color','w')
spiralRho = 0:360;
currInd = tMovies.flagOPW;
tempWD = tMovies.opWDir(currInd);
tempWD(tempWD<0) = tempWD(tempWD<0) + 360;
tempMu = tMovies.mu(currInd);
tempMu(tempMu<0) = tempMu(tempMu<0) + 360;
polarscatter(deg2rad(tempMu),(tempWD))
hold on
polarplot(deg2rad(spiralRho),spiralRho)


%% 
close all

currInd = tMovies.flagOPW & tMovies.flagCMEMS;
figure('color','w')
polarhistogram(deg2rad(tMovies.sd(currInd)))

hold on
polarhistogram(abs(deg2rad(tMovies.opWDir(currInd)-tMovies.memsWDir(currInd))))


close all
figure('color','w')
scatter(tMovies.sd(currInd),abs(tMovies.opWDir(currInd)-tMovies.memsWDir(currInd)))

a  = tMovies.sd(currInd);
b = tMovies.opWDir(currInd)-tMovies.memsWDir(currInd);


close all
polarscatter(deg2rad(tMovies.sd(currInd)),abs(tMovies.opWDir(currInd)-tMovies.memsWDir(currInd)),'.')


%% Rayleigh's test for uniformity of individual jellyfish

for i = 1 : size(tTracks,1)
    tempTrack = cell2mat(tTracks.Angles(i));
    Rayleigh(i) = circ_rtest(deg2rad(tempTrack));
    lTrack(i) = length(tempTrack);
end


%% Difference between mu and different parameters


currInd = tMovies.flagOPW;
[mu sd] = meancirc(tMovies.mu(currInd)-tMovies.opWDir(currInd))


currInd = tMovies.flagOPC;
[mu sd] = meancirc(tMovies.mu(currInd) - tMovies.opcDir(currInd))

currInd = tMovies.flagCMEMS;
[mu sd] = meancirc(tMovies.mu(currInd) - tMovies.memsWDir(currInd))

currInd = tMovies.flagCMEMS;
[mu sd] = meancirc(tMovies.mu(currInd) - tMovies.memsStoDir(currInd))

currInd = tMovies.flagSP;
c = 1;
for i = 1 : size(tMovies,1)
    if tMovies.flagSP(i)
        az(c) = tMovies.sunPos(i).Azimuth;
        zen(c) = tMovies.sunPos(i).Zenith;
        c = c + 1;
    end
end
[mu sd] = meancirc(tMovies.mu(currInd) - az')
[mu sd] = meancirc(tMovies.mu(currInd) - zen)

currInd = tMovies.flagMF;
c = 1;
for i = 1 : size(tMovies,1)
    if tMovies.flagMF(i)
        dec(c) = tMovies.magField(i).magDec;
        inc(c) = tMovies.magField(i).magInc;
        c = c + 1;
    end
end
[mu sd] = meancirc(tMovies.mu(currInd) - dec')
[mu sd] = meancirc(tMovies.mu(currInd) - inc)


%%

currInd = tMovies.flagOPW;
mean(sqrt(tMovies.memsStoX(currInd).^2 + tMovies.memsStoY(currInd).^2))
std(sqrt(tMovies.memsStoX(currInd).^2 + tMovies.memsStoY(currInd).^2))



%%

currInd = tMovies.flagOPW;

[mua sdb] = meancirc(tMovies.mu(currInd)-tMovies.opWDir(currInd))



currInd = tMovies.flagCMEMS;

[mua sdb] = meancirc(tMovies.mu(currInd)-tMovies.memsWDir(currInd))
% [mub sdb] = meancirc(tMovies.memsWDir(currInd))