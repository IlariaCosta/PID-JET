function dati_sparo_1(name_l)

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
    
    %% FILTRI DENSITA'
    
    % DENSITA' CORE
    data = n_core_data.Data;          % i valori del segnale
    time = n_core_data.Time;          % i tempi
    
    Fs = 1 / mean(diff(time));   % Frequenza di campionamento
    Fc = Fs / 20;                % (più è grande il denom maggiore è il filtraggio)
    Wn = Fc / (Fs/2);            % Frequenza normalizzata
    
    if Wn >= 1
        error('Fc troppo alta rispetto a Fs. Riduci Fc oppure verifica il tempo.');
    end
    
    [b, a] = butter(4, Wn);
    filtered_data = filtfilt(b, a, data);
    n_core_data_filt = timeseries(filtered_data, time);
    
    % DENSITA' TARGET
    data = n_tar_data.Data;          % i valori del segnale
    time = n_tar_data.Time;          % i tempi
    
    Fs = 1 / mean(diff(time));   % Frequenza di campionamento
    Fc = Fs / 600;               
    Wn = Fc / (Fs/2);            % Frequenza normalizzata
    
    if Wn >= 1
        error('Fc troppo alta rispetto a Fs. Riduci Fc oppure verifica il tempo.');
    end
    
    [b, a] = butter(4, Wn);
    filtered_data = filtfilt(b, a, data);
    n_tar_data_filt = timeseries(filtered_data, time);
    
    % DENSITA' OMP
    data = n_omp_data.Data;          % i valori del segnale
    time = n_omp_data.Time;          % i tempi
    
    Fs = 1 / mean(diff(time));   % Frequenza di campionamento
    Fc = Fs / 20;               
    Wn = Fc / (Fs/2);            % Frequenza normalizzata
    
    if Wn >= 1
        error('Fc troppo alta rispetto a Fs. Riduci Fc oppure verifica il tempo.');
    end
    
    [b, a] = butter(4, Wn);
    filtered_data = filtfilt(b, a, data);
    n_omp_data_filt = timeseries(filtered_data, time);
    
    %% FILTRI TEMPERATURA
    
    % TEMPERATURA CORE
    data = temp_core_data.Data;          % i valori del segnale
    time = temp_core_data.Time;          % i tempi
    
    Fs = 1 / mean(diff(time));   % Frequenza di campionamento
    Fc = Fs / 100;                % (più è grande il denom maggiore è il filtraggio)
    Wn = Fc / (Fs/2);            % Frequenza normalizzata
    
    if Wn >= 1
        error('Fc troppo alta rispetto a Fs. Riduci Fc oppure verifica il tempo.');
    end
    
    [b, a] = butter(4, Wn);
    filtered_data = filtfilt(b, a, data);
    temp_core_data_filt = timeseries(filtered_data, time);
    
    % TEMPERATURA TARGET
    data = temp_tar_data.Data;          % i valori del segnale
    time = temp_tar_data.Time;          % i tempi
    
    Fs = 1 / mean(diff(time));   % Frequenza di campionamento
    Fc = Fs / 600;               
    Wn = Fc / (Fs/2);            % Frequenza normalizzata
    
    if Wn >= 1
        error('Fc troppo alta rispetto a Fs. Riduci Fc oppure verifica il tempo.');
    end
    
    [b, a] = butter(4, Wn);
    filtered_data = filtfilt(b, a, data);
    temp_tar_data_filt = timeseries(filtered_data, time);
    
    % TEMPERATURA OMP
    data = temp_omp_data.Data;          % i valori del segnale
    time = temp_omp_data.Time;          % i tempi
    
    Fs = 1 / mean(diff(time));   % Frequenza di campionamento
    Fc = Fs / 40;               
    Wn = Fc / (Fs/2);            % Frequenza normalizzata
    
    if Wn >= 1
        error('Fc troppo alta rispetto a Fs. Riduci Fc oppure verifica il tempo.');
    end
    
    [b, a] = butter(4, Wn);
    filtered_data = filtfilt(b, a, data);
    temp_omp_data_filt = timeseries(filtered_data, time);
    
    %% FILTRO ENERGIA
    
    % ENERGIA
    data = media_energia.Data;          % i valori del segnale
    time = media_energia.Time;          % i tempi
    
    Fs = 1 / mean(diff(time));   % Frequenza di campionamento
    Fc = Fs / 600;                % (più è grande il denom maggiore è il filtraggio)
    Wn = Fc / (Fs/2);            % Frequenza normalizzata
    
    if Wn >= 1
        error('Fc troppo alta rispetto a Fs. Riduci Fc oppure verifica il tempo.');
    end
    
    [b, a] = butter(4, Wn);
    filtered_data = filtfilt(b, a, data);
    media_energia_filt = timeseries(filtered_data, time);

    save param_sparo_1 ci_core ci_tar ci_omp ci_T_core ci_T_tar ci_T_omp ci_energia ...
        n_core_data n_omp_data n_tar_data ...
        temp_omp_data temp_core_data temp_tar_data ...
        media_energia_filt n_core_data_filt n_omp_data_filt n_tar_data_filt ...
        temp_core_data_filt temp_omp_data_filt temp_tar_data_filt ...
        indici valvola P_tot Z_eff
end