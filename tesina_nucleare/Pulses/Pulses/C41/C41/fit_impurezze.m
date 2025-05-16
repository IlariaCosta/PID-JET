function fit_impurezze(name_l)
    close all;

    % === CARICAMENTO DATI ===
    load(name_l);  % Carica ci_core, ci_tar, ci_omp, n_core_data, n_omp_data, n_tar_data, tempo_data, etc.

    % Normalizza tempo_data a zero
    tempo_data = tempo_data - tempo_data(1);

    % Controllo dimensioni e uniformità dati
    L = min([length(n_core_data.Data), length(n_omp_data.Data), length(n_tar_data.Data), length(tempo_data)]);
    if L < 2
        error('Dati troppo corti: servono almeno due punti');
    end

    % Ritaglio dati e tempo alla minima lunghezza comune
    n_core_data = n_core_data.Data(1:L);
    n_omp_data  = n_omp_data.Data(1:L);
    n_tar_data  = n_tar_data.Data(1:L);
    tempo_data  = tempo_data(1:L);

    % Dati n_SOL_data dummy (esempio, da modificare se necessario)
    ci_SOL = 1.5e19;  
    n_SOL_data = ones(L, 1) * ci_SOL;

    % Condizioni iniziali (da parametri caricati)
    x0 = [ci_core; ci_omp; ci_SOL; ci_tar];

    % Parametri da esplorare
    taus = linspace(0.1, 1000, 50);
    tau1s = linspace(100, 1000, 50);
    S_vals = linspace(0.1, 0.9, 10);

    min_err = Inf;
    best_tau = 0;
    best_tau1 = 0;
    best_S_core = 0;
    best_S_tar = 0;

    for i = 1:length(taus)
        for j = 1:length(tau1s)
            for k = 1:length(S_vals)
                S_core = S_vals(k);
                S_tar = 1 - S_core;

                if S_core + S_tar >= 0.9 && S_core + S_tar <= 1.0
                    tau = taus(i);
                    tau1 = tau1s(j);

                    [t, x] = ode45(@(t,x) model(t, x, S_core, S_tar, tau, tau1), tempo_data, x0);

                    n_core_sim = x(:,1);
                    n_omp_sim  = x(:,2);
                    n_SOL_sim  = x(:,3);
                    n_tar_sim  = x(:,4);

                    err = sum((n_core_sim - n_core_data).^2 + ...
                              (n_omp_sim  - n_omp_data ).^2 + ...
                              (n_SOL_sim  - n_SOL_data ).^2 + ...
                              (n_tar_sim  - n_tar_data ).^2);

                    if err < min_err
                        min_err = err;
                        best_tau = tau;
                        best_tau1 = tau1;
                        best_S_core = S_core;
                        best_S_tar = S_tar;
                        best_sim = x;
                        best_time = t;
                    end
                end
            end
        end
    end

    % Stampa risultati
    fprintf('Migliori parametri:\n');
    fprintf('tau    = %.3f\n', best_tau);
    fprintf('tau1   = %.3f\n', best_tau1);
    fprintf('S_core = %.3f\n', best_S_core);
    fprintf('S_tar  = %.3f\n', best_S_tar);

    % Salvataggio risultati
    save best_param.mat best_tau best_tau1 best_S_core best_S_tar min_err best_sim best_time
end
