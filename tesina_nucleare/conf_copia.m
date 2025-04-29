clc
clear all 
close all 

%% deuterio

perc_deu_div = 0.2 % percentuale di deuterio che va nel divertore dalla valavola di deuterio
%tau_deu_div = 1/12 % costante di tempo del sistema di pompaggio 1/polo del modello di pompaggio al divertore
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
B_deu_med = 1
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
figure(1);
plot(Te, Lz, '-'); % Usa plot normale
set(gca, 'XScale', 'log'); % Imposta l'asse x su scala logaritmica
set(gca, 'YScale', 'log'); % Imposta l'asse y su scala logaritmica
xlabel('Te [eV]');
ylabel('Lz (Interpolated Value)');
title('Argon - Interpolazione di Lz in funzione di T ');
grid on;

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
figure(2);
plot(Te, Lz, '-'); % Usa plot normale
set(gca, 'XScale', 'log'); % Imposta l'asse x su scala logaritmica
set(gca, 'YScale', 'log'); % Imposta l'asse y su scala logaritmica
xlabel('Te [eV]');
ylabel('Lz (Interpolated Value)');
title('Azoto - Interpolazione di Lz in funzione di T ');
grid on;

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
figure(3);
plot(Te, Lz, '-'); % Usa plot normale
set(gca, 'XScale', 'log'); % Imposta l'asse x su scala logaritmica
set(gca, 'YScale', 'log'); % Imposta l'asse y su scala logaritmica
xlabel('Te [eV]');
ylabel('Lz (Interpolated Value)');
title('Neon - Interpolazione di Lz in funzione di Te (Scale logaritmiche)');
grid on;

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
figure(4);
plot(Te, Lz, '-'); % Usa plot normale
set(gca, 'XScale', 'log'); % Imposta l'asse x su scala logaritmica
set(gca, 'YScale', 'log'); % Imposta l'asse y su scala logaritmica
xlabel('Te [eV]');
ylabel('Lz (Interpolated Value)');
title('Krypton - Interpolazione di Lz in funzione di Te (Scale logaritmiche)');
grid on;

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
figure(5);
plot(Te, Lz, '-'); % Usa plot normale
set(gca, 'XScale', 'log'); % Imposta l'asse x su scala logaritmica
set(gca, 'YScale', 'log'); % Imposta l'asse y su scala logaritmica
xlabel('Te [eV]');
ylabel('Lz (Interpolated Value)');
title('Tungsteno - Interpolazione di Lz in funzione di Te (Scale logaritmiche)');
grid on;

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

Kbr = 1.69*(10^-4)


ne_div = 15*10^19
ne_omp = 3*10^19 
L = 3 
k0 = 1700
Apar = 0.014
ne_core = 10^20
Zeff = 3.1
