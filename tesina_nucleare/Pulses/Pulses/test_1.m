%%
clear;
clc
close all
load("list_pulse.mat")
load("pulse_bon.mat")


%% deuterio

perc_deu_div = 0.2 % percentuale di deuterio che va nel divertore dalla valavola di deuterio
tau_deu_div = 1/12 % --> valore originale 1/12 -->

A_deu_div = -1/tau_deu_div
B_deu_div = perc_deu_div
C_deu_div = 1 
D_deu_div = 0

perc_deu_core = 1-perc_deu_div % percentuale di deuterio che va nel divertore dalla valvola
%tau_deu_core = 1/4 % tau del modello di pompaggio deuterio nel core
tau_deu_core = 1/4 % --> valore originale 1/4 
 
A_deu_core = -1/tau_deu_core
B_deu_core = perc_deu_core
C_deu_core = 1 
D_deu_core = 0

%% azoto

perc_azoto_div = 0.8 % percentuale di azoto che va nel divertore dalla valavola dell' azoto
tau_azoto_div = 1/12 % --> valore originale 1/12 costante di tempo del sistema di pompaggio 1/polo del modello di pompaggio al divertore
A_azoto_div = -1/tau_azoto_div
B_azoto_div = perc_azoto_div
C_azoto_div = 1 
D_azoto_div = 0

perc_azoto_core = 1-perc_azoto_div % percentuale di azoto che va nel core dalla valavola 
tau_azoto_core = 1/4 % --> valore  originale 1/4 tau del modello di pompaggio al core valore originale di partenza: 1/4
A_azoto_core = -1/tau_azoto_core
B_azoto_core = perc_azoto_core
C_azoto_core = 1 
D_azoto_core = 0



%% azoto prova più lento
perc_azoto_div = 0.8 % percentuale di azoto che va nel divertore dalla valavola dell' azoto
tau_azoto_div_prova = 1/2 % costante di tempo del sistema di pompaggio 1/polo del modello di pompaggio
A_azoto_div_prova = -1/tau_azoto_div_prova
B_azoto_div = perc_azoto_div
C_azoto_div = 1 
D_azoto_div = 0

perc_azoto_core = 1-perc_azoto_div % percentuale di azoto che va nel core dalla valavola di azoto
tau_azoto_core_prova = 1/1 % tau del modello di pompaggio al core
A_azoto_core_prova = -1/tau_azoto_core_prova
B_azoto_core = perc_azoto_core
C_azoto_core = 1 
D_azoto_core = 0
%% condizione iniziale 
ne0_div = 10^18 %densità elettronica sul divertore iniziale 
ne0_core = 10^18 %densità elettronica sul core iniziale
ion = 7  % Azoto: 7 , Krypton: 36 %livello di ionizzazione delle impurezze 
Te_tar = 2 % temperatura elettronica sul target
Te_omp = 80 %temperatura elettronica outer midplane
k0 = 1000
Te_tar2 = 10 % temperatura elettronica sul target nella simulazione in cui la temperatura non rimane costante 
Te_omp2 = 100 %temperatura elettronica outer midplane nella simulazione in cui la temperatura non rimane costante 

%% caso in cui non faccio distinzione tra core e divertore

tau_deu = 1/3 % costante di tempo del sistema di pompaggio 1/polo del modello di pompaggio al divertore
A_deu_med = -1/tau_deu
B_deu_med = 1;
C_deu_med = 1 
D_deu_med = 0

tau_azoto = 1/3 % costante di tempo del sistema di pompaggio 1/polo del modello di pompaggio al divertore
A_azoto_med = -1/tau_azoto
B_azoto_med = 1
C_azoto_med = 1 
D_azoto_med = 0

%% Lz di argon 

% Definisci i punti dati per l'interpolazione
Te_valuesArgon = [0, 1, 5, 8,11, 18, 21, 30, 46, 59, 72, 180, 200, 260,300,400, 700, 830, 1950, 3000, 6300, 10000];
%Te_values = [0, 5, 11, 18, 21, 30, 46, 59, 72, 180, 200, 260,300,400, 700, 830, 1950, 3000, 6300, 10000];  % Valori di temperatura campione



Lz_valuesArgon = [5e-35, 5e-35, 2.5e-32, 9e-32,1.95e-31, 1.8e-31, 1.8e-31, 6e-32, 6e-33, 3.8e-33, 6e-33, 7e-32, 6.5e-32, 4.2e-32, 2.5e-32, 1e-32,3.5e-33, 3.1e-33, 4.1e-33, 3e-33,1.8e-33, 1.4e-33];     % Valori di Lz corrispondenti
%Lz_valuesArgon = [1e-34, 2.5e-32, 1.95e-31, 1.8e-31, 1.8e-31, 6e-32, 6e-33, 3.8e-33, 6e-33, 7e-32, 6.5e-32, 4.2e-32, 2.5e-32, 1e-32,3.5e-33, 3.1e-33, 4.1e-33, 3e-33,1.8e-33, 1.4e-33];


% Crea un intervallo di temperature da interpolare
Te = linspace(min(Te_valuesArgon), max(Te_valuesArgon), 10000);  % 100 punti tra min e max di Te_values

% Calcola i valori interpolati di Lz
%Lz = interp1(Te_values, Lz_valuesArgon, Te, 'linear', 'extrap');
Lz = interp1(Te_valuesArgon, Lz_valuesArgon, Te, 'pchip', 'extrap');

% Visualizza il grafico di Lz in funzione di Te
% figure(1);
% % % plot(Te, Lz, '-'); % Usa % plot normale
% set(gca, 'XScale', 'log'); % Imposta l'asse x su scala logaritmica
% set(gca, 'YScale', 'log'); % Imposta l'asse y su scala logaritmica
% xlabel('Te [eV]');
% ylabel('Lz (Interpolated Value)');
% title('Argon - Interpolazione di Lz in funzione di T ');
% grid on;

% Asse y
yticks([1e-34, 1e-33, 1e-32, 1e-31, 1e-30]); % Tacche logaritmiche su y
ylim([1e-34, 1e-30]); % Limita l'intervallo dei valori di y

xticks([5, 10, 100, 1000, 10000]); % Tacche logaritmiche su x
xlim([0, 10000]); % Limita l'intervallo dei valori di y

%% Lz Azoto

% Definisci i punti dati per l'interpolazione
Te_valuesAzoto = [0,1, 5, 10, 12, 15, 20, 30, 59, 100, 155, 200, 300, 500, 700, 1000, 3000, 10000];  % Valori di temperatura campione
Lz_valuesAzoto = [5e-35, 5e-35,1.3e-32, 4.0e-32, 4.8e-32, 3.6e-32, 7e-33, 1.35e-33, 2.4e-34, 7e-34, 1.1e-33, 9e-34, 4.7e-34, 2.4e-34, 1.75e-34, 1.45e-34, 1e-34, 1.25e-34];     % Valori di Lz corrispondenti

% Crea un intervallo di temperature da interpolare
Te = linspace(min(Te_valuesAzoto), max(Te_valuesAzoto), 10000);  % 10000 punti tra min e max di Te_values


% Calcola i valori interpolati di Lz
Lz = interp1(Te_valuesAzoto, Lz_valuesAzoto, Te, 'pchip', 'extrap');

% Visualizza il grafico di Lz in funzione di Te
% figure(2);
% % plot(Te, Lz, '-'); % Usa % plot normale
% set(gca, 'XScale', 'log'); % Imposta l'asse x su scala logaritmica
% set(gca, 'YScale', 'log'); % Imposta l'asse y su scala logaritmica
% xlabel('Te [eV]');
% ylabel('Lz (Interpolated Value)');
% title('Azoto - Interpolazione di Lz in funzione di T ');
% grid on;

% Asse y
yticks([1e-34, 1e-33, 1e-32, 1e-31, 1e-30]); % Tacche logaritmiche su y
ylim([1e-34, 1e-30]); % Limita l'intervallo dei valori di y

xticks([5, 10, 100, 1000, 10000]); % Tacche logaritmiche su x
xlim([0, 10000]); % Limita l'intervallo dei valori di y

%% Lz neon

% Definizione dei punti dati
Te_valuesNeon = [0, 1, 5, 8, 10, 15, 17, 20, 30, 35, 60, 100, 150, 160, 200, 250, 300, 330, 500, 620, 1000,2000,5000,10000];  % Valori di temperatura
Lz_valuesNeon = [1e-34, 1e-34, 8e-34, 4e-33, 8e-33, 1.8e-32, 2.3e-32, 3.1e-32, 4.3e-32, 4.5e-32, 9e-33, 1.3e-33, 7e-34, 6.8e-34, 8.8e-34, 1.25e-33, 1.65e-33, 1.7e-33, 1.2e-33, 8.5e-34, 5e-34,3.3e-34, 2.8e-34,3e-34]; 

% Crea un intervallo di temperature da interpolare
Te = linspace(min(Te_valuesNeon), max(Te_valuesNeon), 10000);  % 100 punti tra min e max di Te_values

% Calcola i valori interpolati di Lz
Lz = interp1(Te_valuesNeon, Lz_valuesNeon, Te, 'pchip', 'extrap');

% Visualizza il grafico di Lz in funzione di Te
% figure(3);
% % plot(Te, Lz, '-'); % Usa % plot normale
% set(gca, 'XScale', 'log'); % Imposta l'asse x su scala logaritmica
% set(gca, 'YScale', 'log'); % Imposta l'asse y su scala logaritmica
% xlabel('Te [eV]');
% ylabel('Lz (Interpolated Value)');
% title('Neon - Interpolazione di Lz in funzione di Te (Scale logaritmiche)');
% grid on;

% Asse y
yticks([1e-34, 1e-33, 1e-32, 1e-31, 1e-30]); % Tacche logaritmiche su y
ylim([1e-34, 1e-30]); % Limita l'intervallo dei valori di y

xticks([5, 10, 100, 1000, 10000]); % Tacche logaritmiche su x
xlim([0, 10000]); % Limita l'intervallo dei valori di y


%% Lz Krypton

% Definizione dei punti dati
Te_valuesKrypton = [0, 1, 5, 10, 16, 20, 30, 45, 61, 80, 115, 200, 310, 340, 410, 600, 1000, 1750, 2000, 4000, 6000, 10000];  % Valori di temperatura
Lz_valuesKrypton = [1e-34, 1e-34, 2.35e-32, 9e-32, 2e-31, 2.65e-31, 1.9e-31, 7e-32, 2.45e-32, 4e-32, 8e-32, 1.45e-31, 1.7e-31, 1.65e-31, 1.2e-31, 6e-32, 3.9e-32, 3.5e-32, 3e-32, 1e-32, 8e-33, 7.5e-33]; 

% Crea un intervallo di temperature da interpolare
Te = linspace(min(Te_valuesKrypton), max(Te_valuesKrypton), 10000);  % 100 punti tra min e max di Te_values

% Calcola i valori interpolati di Lz
Lz = interp1(Te_valuesKrypton, Lz_valuesKrypton, Te, 'pchip', 'extrap');

% Visualizza il grafico di Lz in funzione di Te
% figure(4);
% % plot(Te, Lz, '-'); % Usa % plot normale
% set(gca, 'XScale', 'log'); % Imposta l'asse x su scala logaritmica
% set(gca, 'YScale', 'log'); % Imposta l'asse y su scala logaritmica
% xlabel('Te [eV]');
% ylabel('Lz (Interpolated Value)');
% title('Krypton - Interpolazione di Lz in funzione di Te (Scale logaritmiche)');
% grid on;

% Asse y
yticks([1e-34, 1e-33, 1e-32, 1e-31, 1e-30]); % Tacche logaritmiche su y
ylim([1e-34, 1e-30]); % Limita l'intervallo dei valori di y

xticks([5, 10, 100, 1000, 10000]); % Tacche logaritmiche su x
xlim([0, 10000]); % Limita l'intervallo dei valori di y

%% Lz Tungsteno

% Definizione dei punti dati
Te_valuesTungsteno = [40,50,70,150,200,300,500,800,1000,1500,2000,3000,5000,7000,20000,40000,100000];  % Valori di temperatura
Lz_valuesTungsteno = [2.56*10^-31, 2.55*10^-31, 1.73*10^-31,1.57*10^-31 ,1.65*10^-31 ,1.99*10^-31, 2.91*10^-31,3.76*10^-31,4.21*10^-31,4.59*10^-31,4.38*10^-31,2.28*10^-31,1.87*10^-31,1.67*10^-31,7.3*10^-32, 4.95*10^-32, 2.50*10^-32]; 

% Crea un intervallo di temperature da interpolare
Te = linspace(min(Te_valuesTungsteno), max(Te_valuesTungsteno), 10000);  % 100 punti tra min e max di Te_values

% Calcola i valori interpolati di Lz
Lz = interp1(Te_valuesTungsteno, Lz_valuesTungsteno, Te, 'pchip', 'extrap');

% Visualizza il grafico di Lz in funzione di Te
% figure(5);
% % % plot(Te, Lz, '-'); % Usa % plot normale
% set(gca, 'XScale', 'log'); % Imposta l'asse x su scala logaritmica
% set(gca, 'YScale', 'log'); % Imposta l'asse y su scala logaritmica
% xlabel('Te [eV]');
% ylabel('Lz (Interpolated Value)');
% title('Tungsteno - Interpolazione di Lz in funzione di Te (Scale logaritmiche)');
% grid on;

% Asse y
yticks([1e-34, 1e-33, 1e-32, 1e-31, 1e-30]); % Tacche logaritmiche su y
ylim([1e-34, 1e-30]); % Limita l'intervallo dei valori di y

xticks([5, 10, 100, 1000, 10000]); % Tacche logaritmiche su x
xlim([0, 10000]); % Limita l'intervallo dei valori di y


%% Dinamica variazione temperatura

tau_e = 0.50; % energy confinement time - valore tra quelli realistici per Iter
A_temp = -1/tau_e; % matrice A del sistema dinamico per la variazione della temperatura. 
B_temp = 0;
C_temp = 1;
D_temp = 0;

Ein = 7.2*10^6; %energia iniziale [J] contenuta nel core E = (3/2)*ne_core*Tcore*V per 10KeV

V = 30; % volume core in m^3 , abbiamo visto che il volume del Jet sono circa 100 m^3 ; solitamente
        % Volume core è circa il 30%

Kbr = 1.69*(10^-4);


ne_div = 15*10^19;
ne_omp = 3*10^19;
L = 3;
k0 = 1700;
Apar = 0.014;
ne_core = 10^20;
Zeff = 3.1;

%%

for i=1:length(pulse_bon)
 
    load(name_l{pulse_bon(i)});
    
    figure(1)
    clf;
    ax1=subplot(2,4,1);
    plot(Data.t,Data.Ip)
    xlabel('Tempo', 'FontSize', 14);
    title('Plasma current', 'FontSize', 14)
    grid on;
    ax2=subplot(2,4,2);
    grid on;
    hold off
    plot(Data.t,Data.PTOT)
    grid on;
    hold on
    plot(Data.t,Data.Prad)
    legend(['P_in';'Prad'])
    xlabel('Tempo', 'FontSize', 14);
    title('Power','FontSize', 14)
    grid on;
    ax3=subplot(2,4,3);
    hold off
    plot(Data.t,Data.WDIA)
    grid on;
    hold on
     plot(Data.t,Data.WP)
     xlabel('Tempo', 'FontSize', 14);
     title('Plasma Energy','FontSize', 14)
     grid on;
     ax4=subplot(2,4,4);
     grid on;
     try
        hold off
        plot(Data.t,Data.ZEFF)
        grid on;
        xlabel('Tempo', 'FontSize', 14);
        title('ZEFF','FontSize', 14)
     catch
     end
    ax5=subplot(2,4,5);
    grid on;
    hold off
    plot(TS.T.t,TS.T.T(1,:));
    yyaxis right
    plot(TS.T.t,TS.T.T(56,:));     
    legend(["Core";"OMP"])
    xlabel('Tempo', 'FontSize', 14);
    title('Temperature','FontSize', 14)
    grid on;
    ax6=subplot(2,4,6);
    grid on;
    hold off
    plot(TS.T.t,TS.N.T(1,:)); 
    hold on
    grid on;
    plot(TS.T.t,interp1(Data.t,Data.Lan_Ne,TS.T.t));
    grid on;
    plot(TS.T.t,TS.N.T(56,:));
    grid on;
    ylim([0 Inf])
    
    legend(["Core";"TAR";"OMP"])
    xlabel('Tempo', 'FontSize', 14);
    title('Density','FontSize', 14)
    ax7=subplot(2,4,7);
    grid on;
    hold off
    plot(Data.t,Data.D2);
    grid on;
    
    if Error.NE==0 || Error.N2==0
    yyaxis right
    
    try
    plot(Data.t,Data.N2);
    grid on;
    catch
    plot(Data.t,Data.NE);
    grid on;
    end
    end
    xlabel('Tempo', 'FontSize', 14);
    title('Valves','FontSize', 14)
    
    ax8=subplot(2,4,8);
    hold off
    plot(Data.t,Data.Lan_TE);
    grid on;
    xlabel('Tempo', 'FontSize', 14);
    title('T_{TAR}','FontSize', 14)
    
    sgtitle(num2str(shot))
    linkaxes([ax1,ax2,ax3,ax4,ax5,ax6,ax7,ax8],'x')
    drawnow;
    pause()
end

%% VETTORI
%% 1. Sparo 94568
i = contains(name_l, '94568');  % trova l'indice del nome che contiene '94568'
sparo_1 = name_l{i};
load(sparo_1);

% condizioni iniziali densità
ci_core = 2.05*10^19;
ci_tar = 2.6*10^19;
ci_omp = 1*10^19;

% tempo 43-46 s
i1 = find(Data.t == 43);
i2 = find(Data.t == 46);
indici = [i1 i2];
tempo_data = Data.t(i1:i2)';
valvola = timeseries(Data.D2(i1:i2)', tempo_data); % deuterio immesso
valvola.Time = valvola.Time - valvola.Time(1);  % ora parte da 0 s
n_tar_data = timeseries(Data.Lan_Ne(i1:i2)', tempo_data); % densità vera omp
n_tar_data.Time = n_tar_data.Time - n_tar_data.Time(1);  % ora parte da 0 s

ii1 = find(startsWith(string(TS.N.t), '43'), 1);
ii2 = find(startsWith(string(TS.N.t), '46'), 1);
tempo_TS = TS.N.t(ii1:ii2)';
n_core_data = timeseries(TS.N.T(1,ii1:ii2)', tempo_TS); % densità vera core
n_core_data.Time = n_core_data.Time - n_core_data.Time(1);  % ora parte da 0 s
n_omp_data = timeseries(TS.N.T(56,ii1:ii2)', tempo_TS); % densità vera omp
n_omp_data.Time = n_omp_data.Time - n_omp_data.Time(1);  % ora parte da 0 s

% Potenza -> diagramma Controllo
P_tot = timeseries(Data.PTOT(i1:i2)', tempo_data);
P_tot.Time = P_tot.Time - P_tot.Time(1);

% Z efficace
Z_eff = timeseries(Data.ZEFF(i1:i2)', tempo_data);
Z_eff.Time = Z_eff.Time - Z_eff.Time(1);

% Temperatura
temp_core_data = timeseries(TS.T.T(1,ii1:ii2)', tempo_TS);
temp_core_data.Time = temp_core_data.Time - temp_core_data.Time(1);
temp_omp_data = timeseries(TS.T.T(56,ii1:ii2)', tempo_TS);
temp_omp_data.Time = temp_omp_data.Time - temp_omp_data.Time(1);
temp_tar_data = timeseries(Data.Lan_TE(i1:i2)', tempo_data); 
temp_tar_data.Time = temp_tar_data.Time - temp_tar_data.Time(1);

% condizioni iniziali temperatura
ci_T_core = 1300;
ci_T_omp = 59;
ci_T_tar = 6.6;

% Energia
media_energia = (timeseries(Data.WP(i1:i2)', tempo_data) + timeseries(Data.WDIA(i1:i2)', tempo_data))/2;
media_energia.Time = media_energia.Time - media_energia.Time(1);
ci_energia = media_energia.Data(1);


%% 2. Sparo 95502
i = contains(name_l, '95502'); 
sparo_2 = name_l{i};
load(sparo_2);

% condizioni iniziali
ci_core = 1.95*10^19;
ci_tar = 1.85*10^19;
ci_omp = 0.95*10^19;

i1 = find(Data.t == 43);
i2 = find(Data.t == 46);
indici = [i1 i2];
tempo_data = Data.t(i1:i2)';
valvola = timeseries(Data.D2(i1:i2)', tempo_data); % formato per simulink
valvola.Time = valvola.Time - valvola.Time(1);  % ora parte da 0 s
n_tar_data = timeseries(Data.Lan_Ne(i1:i2)', tempo_data); % densità vera omp
n_tar_data.Time = n_tar_data.Time - n_tar_data.Time(1);  % ora parte da 0 s

ii1 = find(startsWith(string(TS.N.t), '43'), 1);
ii2 = find(startsWith(string(TS.N.t), '46'), 1);
tempo_TS = TS.N.t(ii1:ii2)';
n_core_data = timeseries(TS.N.T(1,ii1:ii2)', tempo_TS); % densità vera core
n_core_data.Time = n_core_data.Time - n_core_data.Time(1);  % ora parte da 0 s
n_omp_data = timeseries(TS.N.T(56,ii1:ii2)', tempo_TS); % densità vera omp
n_omp_data.Time = n_omp_data.Time - n_omp_data.Time(1);  % ora parte da 0 s

% Potenza -> diagramma Controllo
P_tot = timeseries(Data.PTOT(i1:i2)', tempo_data);
P_tot.Time = P_tot.Time - P_tot.Time(1);

% Z efficace
Z_eff = timeseries(Data.ZEFF(i1:i2)', tempo_data);
Z_eff.Time = Z_eff.Time - Z_eff.Time(1);

% Temperatura
temp_core_data = timeseries(TS.T.T(1,ii1:ii2)', tempo_TS);
temp_core_data.Time = temp_core_data.Time - temp_core_data.Time(1);
temp_omp_data = timeseries(TS.T.T(56,ii1:ii2)', tempo_TS);
temp_omp_data.Time = temp_omp_data.Time - temp_omp_data.Time(1);
temp_tar_data = timeseries(Data.Lan_TE(i1:i2)', tempo_data); 
temp_tar_data.Time = temp_tar_data.Time - temp_tar_data.Time(1);

% condizioni iniziali temperatura
% ci_T_core = 1168;
% ci_T_omp = 1173;
% ci_T_tar = 6.6;
ci_T_core = temp_core_data.Data(1);
ci_T_omp = temp_omp_data.Data(1);
ci_T_tar = temp_tar_data.Data(1);

% Energia
media_energia = (timeseries(Data.WP(i1:i2)', tempo_data) + timeseries(Data.WDIA(i1:i2)', tempo_data))/2;
media_energia.Time = media_energia.Time - media_energia.Time(1);
ci_energia = media_energia.Data(1);

%% 3. Sparo 95503
i = contains(name_l, '95503'); 
sparo_3 = name_l{i};
load(sparo_3);

% condizioni iniziali densità
ci_core = 1.49*10^19;
ci_tar = 2.55*10^18;
ci_omp = 8.02*10^18;

% tempo 42-47
i1 = find(Data.t == 42);
i2 = find(Data.t == 47);
indici = [i1 i2];
tempo_data = Data.t(i1:i2)';
valvola = timeseries(Data.D2(i1:i2)', tempo_data); % formato per simulink
valvola.Time = valvola.Time - valvola.Time(1);  % ora parte da 0 s
n_tar_data = timeseries(Data.Lan_Ne(i1:i2)', tempo_data); % densità vera omp
n_tar_data.Time = n_tar_data.Time - n_tar_data.Time(1);  % ora parte da 0 s

ii1 = find(startsWith(string(TS.N.t), '42'), 1);
ii2 = find(startsWith(string(TS.N.t), '47'), 1);
tempo_TS = TS.N.t(ii1:ii2)';
n_core_data = timeseries(TS.N.T(1,ii1:ii2)', tempo_TS); % densità vera core
n_core_data.Time = n_core_data.Time - n_core_data.Time(1);  % ora parte da 0 s
n_omp_data = timeseries(TS.N.T(56,ii1:ii2)', tempo_TS); % densità vera omp
n_omp_data.Time = n_omp_data.Time - n_omp_data.Time(1);  % ora parte da 0 s

% Potenza -> diagramma Controllo
P_tot = timeseries(Data.PTOT(i1:i2)', tempo_data);
P_tot.Time = P_tot.Time - P_tot.Time(1);

% Z efficace
Z_eff = timeseries(Data.ZEFF(i1:i2)', tempo_data);
Z_eff.Time = Z_eff.Time - Z_eff.Time(1);

% Temperatura
temp_core_data = timeseries(TS.T.T(1,ii1:ii2)', tempo_TS);
temp_core_data.Time = temp_core_data.Time - temp_core_data.Time(1);
temp_omp_data = timeseries(TS.T.T(56,ii1:ii2)', tempo_TS);
temp_omp_data.Time = temp_omp_data.Time - temp_omp_data.Time(1);
temp_tar_data = timeseries(Data.Lan_TE(i1:i2)', tempo_data); 
temp_tar_data.Time = temp_tar_data.Time - temp_tar_data.Time(1);

% condizioni iniziali temperatura
ci_T_core = temp_core_data.Data(1);
ci_T_omp = temp_omp_data.Data(1);
ci_T_tar = temp_tar_data.Data(1);

% Energia
media_energia = (timeseries(Data.WP(i1:i2)', tempo_data) + timeseries(Data.WDIA(i1:i2)', tempo_data))/2;
media_energia.Time = media_energia.Time - media_energia.Time(1);
ci_energia = media_energia.Data(1);

%% FITTING

%% Sparo 1
clc
close all
[best_tau, best_E] = fit_controllo(sparo_1, indici);

% Tempo comune
t_data = tempo_TS;
 
% Estrai e interpola dati su t_data
P_cond_vec = out.P_cond.Data;
tempo_cond = out.P_cond.Time;
q_rad_vec = out.qrad.Data;
P_cond_interp = interp1(tempo_cond, P_cond_vec, t_data, 'linear', 'extrap');
q_rad_interp  = interp1(tempo_cond, q_rad_vec, t_data, 'linear', 'extrap');
 
% Dati simulati
Tomp_sim = out.Tomp.Data;
t_Tomp = out.Tomp.Time;
Ttar_sim = out.Ttar.Data;
Tomp_sim_interp = interp1(t_Tomp, Tomp_sim, t_data, 'linear', 'extrap');
Ttar_sim_interp = interp1(t_Tomp, Ttar_sim, t_data, 'linear', 'extrap');
 
% Dati misurati
Tomp = temp_omp_data.Data;
t_Tomp_mis = temp_omp_data.Time;
Ttar = temp_tar_data.Data;
t_Ttar_mis = temp_tar_data.Time;
Tomp_interp = interp1(t_Tomp_mis, Tomp, t_data, 'linear', 'extrap');
Ttar_interp = interp1(t_Ttar_mis, Ttar, t_data, 'linear', 'extrap');
 
% Costanti geometriche
C1 = 1000 * 0.014 * 3;
C2 = 3 * 3;
C3 = 3 * 3;
C4 = 9;

%% Sparo 2
clc
close all
[best_tau, best_E] = fit_controllo(sparo_2, indici);

% Tempo comune
t_data = tempo_TS;
 
% Estrai e interpola dati su t_data
P_cond_vec = out.P_cond.Data;
tempo_cond = out.P_cond.Time;
q_rad_vec = out.qrad.Data;
P_cond_interp = interp1(tempo_cond, P_cond_vec, t_data, 'linear', 'extrap');
q_rad_interp  = interp1(tempo_cond, q_rad_vec, t_data, 'linear', 'extrap');
 
% Dati simulati
Tomp_sim = out.Tomp.Data;
t_Tomp = out.Tomp.Time;
Ttar_sim = out.Ttar.Data;
Tomp_sim_interp = interp1(t_Tomp, Tomp_sim, t_data, 'linear', 'extrap');
Ttar_sim_interp = interp1(t_Tomp, Ttar_sim, t_data, 'linear', 'extrap');
 
% Dati misurati
Tomp = temp_omp_data.Data;
t_Tomp_mis = temp_omp_data.Time;
Ttar = temp_tar_data.Data;
t_Ttar_mis = temp_tar_data.Time;
Tomp_interp = interp1(t_Tomp_mis, Tomp, t_data, 'linear', 'extrap');
Ttar_interp = interp1(t_Ttar_mis, Ttar, t_data, 'linear', 'extrap');
 
% Costanti geometriche
C1 = 1000 * 0.014 * 3;
C2 = 3 * 3;
C3 = 3 * 3;
C4 = 9;


%% Sparo 3
clc
close all
[best_tau, best_E] = fit_controllo(sparo_3, indici);

% Tempo comune
t_data = tempo_TS;
 
% Estrai e interpola dati su t_data
P_cond_vec = out.P_cond.Data;
tempo_cond = out.P_cond.Time;
q_rad_vec = out.qrad.Data;
P_cond_interp = interp1(tempo_cond, P_cond_vec, t_data, 'linear', 'extrap');
q_rad_interp  = interp1(tempo_cond, q_rad_vec, t_data, 'linear', 'extrap');
 
% Dati simulati
Tomp_sim = out.Tomp.Data;
t_Tomp = out.Tomp.Time;
Ttar_sim = out.Ttar.Data;
Tomp_sim_interp = interp1(t_Tomp, Tomp_sim, t_data, 'linear', 'extrap');
Ttar_sim_interp = interp1(t_Tomp, Ttar_sim, t_data, 'linear', 'extrap');
 
% Dati misurati
Tomp = temp_omp_data.Data;
t_Tomp_mis = temp_omp_data.Time;
Ttar = temp_tar_data.Data;
t_Ttar_mis = temp_tar_data.Time;
Tomp_interp = interp1(t_Tomp_mis, Tomp, t_data, 'linear', 'extrap');
Ttar_interp = interp1(t_Ttar_mis, Ttar, t_data, 'linear', 'extrap');
 
% Costanti geometriche
C1 = 1000 * 0.014 * 3;
C2 = 3 * 3;
C3 = 3 * 3;
C4 = 9;




 

