function [alpha_best, gamma_best, y_best, t_common] = fit_alpha_gamma_targets(Tomp_ts, Ttar_ts, P_cond_ts, q_rad_ts, Text)
    % fit_alpha_gamma stima alpha e gamma per il modello dato i dati time series
    % Input:
    %   Tomp_ts, Ttar_ts, P_cond_ts, q_rad_ts: dati di tipo timeseries MATLAB
    %   Text: temperatura ambiente (es. 300 K)
    % Output:
    %   alpha_best, gamma_best: parametri stimati
    %   y_best: soluzione ODE con parametri ottimali
    %   t_common: vettore tempo usato
    
    % --- Step 1: definisci vettore tempo comune ---
    t_start = max([Tomp_ts.Time(1), Ttar_ts.Time(1), P_cond_ts.Time(1), q_rad_ts.Time(1)]);
    t_end   = min([Tomp_ts.Time(end), Ttar_ts.Time(end), P_cond_ts.Time(end), q_rad_ts.Time(end)]);
    N_points = 431; % numero di punti tempo comuni, scegli a piacere
    
    t_common = linspace(t_start, t_end, N_points);
    
    % --- Step 2: interpola dati su vettore tempo comune ---
    Tomp_data = interp1(Tomp_ts.Time, Tomp_ts.Data, t_common, 'linear');
    Ttar_data = interp1(Ttar_ts.Time, Ttar_ts.Data, t_common, 'linear');
    P_cond_data = interp1(P_cond_ts.Time, P_cond_ts.Data, t_common, 'linear');
    q_rad_data = interp1(q_rad_ts.Time, q_rad_ts.Data, t_common, 'linear');
    
    % --- Step 3: costruisci funzioni interpolanti per P_cond e q_rad ---
    P_cond_fun = @(t) interp1(t_common, P_cond_data, t, 'linear', 'extrap');
    q_rad_fun  = @(t) interp1(t_common, q_rad_data, t, 'linear', 'extrap');
    
    % --- Costanti fisiche / parametri sistema ---
    k_B = 8.617e-5; % costante di Boltzmann [eV/K]
    
    % --- Range parametri da testare ---
    alphas = linspace(0.01, 10, 50);    % puoi regolare range e numero punti
    gammas = linspace(0.01, 10, 50);
    
    % --- Inizializza ricerca parametri ---
    min_err = inf;
    alpha_best = NaN;
    gamma_best = NaN;
    y_best = [];
    
    % --- Condizioni iniziali ---
    ci_T_omp = Tomp_data(1);
    ci_T_tar = Ttar_data(1);
    Tsol0 = (ci_T_omp + ci_T_tar) / 2;
    y0 = [ci_T_omp; Tsol0; ci_T_tar];
    
    % --- Loop griglia parametri ---
    for i = 1:length(alphas)
        alpha = alphas(i);
        for j = 1:length(gammas)
            gamma = gammas(j);
            
            % Definisci ODE system
            ode_fun = @(t,y) [
                (y(2) - y(1)) * alpha + P_cond_fun(t) / (1000*0.014*3) - q_rad_fun(t) / (3*3);
                (y(1) - y(2)) * alpha + (y(3) - y(2)) * alpha - q_rad_fun(t) / (3*3);
                (y(2) - y(3)) * alpha + (Text - y(3)) * gamma - q_rad_fun(t) / 9;
            ];
            
            % Risolvi ODE
            options = odeset('RelTol',1e-6,'AbsTol',1e-8);
            [t_sim, y_sim] = ode45(ode_fun, t_common, y0, options);
            
            % Estrai temp simulate
            Tomp_sim = y_sim(:,1);
            Ttar_sim = y_sim(:,3);
            
            % Calcola errore (somma quadrati)
            err = sum((Tomp_sim - Tomp_data).^2) + sum((Ttar_sim - Ttar_data).^2);
            
            if err < min_err
                min_err = err;
                alpha_best = alpha;
                gamma_best = gamma;
                y_best = y_sim;
            end
        end
    end
    
    % --- Stampa risultati ---
    fprintf('Parametri ottimali:\n alpha = %.4f\n gamma = %.4f\n Errore = %.6f\n', alpha_best, gamma_best, min_err);
    
end
