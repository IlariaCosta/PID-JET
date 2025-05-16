%% fit_tau_tau1
function fit_traporto_particelle(sparo, cond_in)
    close all 
    % === CARICAMENTO DATI E CONDIZIONI INIZIALI ===
    i = sparo;
    load(name_l{i});
     
    % Condizioni iniziali (densità)
    ci_core = 2.05e19;
    ci_tar = 2.6e19;
    ci_omp = 1.0e19;
    ci_SOL = 1.5e19;  % Stima iniziale
    x0 = [ci_core; ci_omp; ci_SOL; ci_tar];
     
    % Intervallo temporale
    i1 = 3001;
    i2 = 6001;
    tempo_data = Data.t(i1:i2)';
    tempo_data = tempo_data - tempo_data(1);
     
    % Dati reali 
    n_tar_data_raw = Data.Lan_Ne(i1:i2)';
    n_omp_data_raw = TS.N.T(56,61:121)';
    n_core_data_raw = TS.N.T(1,61:121)';
    tempo_TS = TS.N.t(61:121)';
    tempo_TS = tempo_TS - tempo_TS(1);
     
    % Interpolazione su tempo_data
    n_core_data = interp1(tempo_TS, n_core_data_raw, tempo_data, 'linear', 'extrap');
    n_omp_data = interp1(tempo_TS, n_omp_data_raw, tempo_data, 'linear', 'extrap');
    n_tar_data = n_tar_data_raw;
    n_SOL_data = ones(size(n_tar_data)) * ci_SOL;  % dummy
     
    % === PARAMETRI DA ESPLORARE ===
    taus = linspace(100, 1000, 50);
    tau1s = linspace(100, 1000, 50);
    S_vals = linspace(0.1, 0.9, 10);  % S_core da 0.1 a 0.9
     
    min_err = Inf;
    best_tau = 0;
    best_tau1 = 0;
    best_S_core = 0;
    best_S_tar = 0;
     
    % === LOOP SU TUTTE LE COMBINAZIONI ===
    for i = 1:length(taus)
        for j = 1:length(tau1s)
            for k = 1:length(S_vals)
                S_core = S_vals(k);
                S_tar = 1 - S_core;  % Imposto S_tar in modo che la somma sia 1
     
                % Vincolo: somma ∈ [0.9, 1]
                if S_core + S_tar >= 0.9 && S_core + S_tar <= 1.0
                    tau = taus(i);
                    tau1 = tau1s(j);
     
                    % Simulazione
                    [t, x] = ode45(@(t,x) model(t, x, S_core, S_tar, tau, tau1), tempo_data, x0);
     
                    % Estrai densità simulate
                    n_core_sim = x(:,1);
                    n_omp_sim  = x(:,2);
                    n_SOL_sim  = x(:,3);
                    n_tar_sim  = x(:,4);
     
                    % Errore totale
                    err = sum((n_core_sim - n_core_data).^2 + ...
                              (n_omp_sim  - n_omp_data ).^2 + ...
                              (n_SOL_sim  - n_SOL_data ).^2 + ...
                              (n_tar_sim  - n_tar_data ).^2);
     
                    % Salva se è la migliore
                    if err < min_err
                        min_err = err;
                        best_tau = tau;
                        best_tau1 = tau1;
                        best_S_core = S_core;
                        best_S_tar = S_tar;
                        best_sim = x;
                    end
                end
            end
        end
    end
    %%
    fprintf('Migliori parametri:\n');
    fprintf('tau    = %.3f\n', best_tau);
    fprintf('tau1   = %.3f\n', best_tau1);
    fprintf('S_core = %.3f\n', best_S_core);
    fprintf('S_tar  = %.3f\n', best_S_tar);
    fprintf('Errore = %.4e\n', min_err);
    save best_param.mat best_tau best_tau1 best_S_core best_S_tar min_err

end