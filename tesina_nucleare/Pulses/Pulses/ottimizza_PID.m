function ottimizza_PID(n_core_data, n_omp_data)

    t = n_core_data.Time;  % Tempo del tuo timeseries
    dt = t(2) - t(1);
 
    % Range PID da esplorare
    Kp_vals = linspace(0.1, 50, 300);
    Ki_vals = linspace(0, 20, 100);
    Kd_vals = linspace(0, 10, 100);
 
    best_J = Inf;
    best_K = [0 0 0];
 
    for Kp = Kp_vals
        for Ki = Ki_vals
            for Kd = Kd_vals
                J = simula_PID(Kp, Ki, Kd, 300, n_core_data, n_omp_data, t);
                if J < best_J
                    best_J = J;
                    best_K = [Kp, Ki, Kd];
                end
            end
        end
    end
 
    fprintf('=== PID Ottimizzato ===\n');
    fprintf('Kp = %.3f\nKi = %.3f\nKd = %.3f\nCosto J = %.4f\n', ...
        best_K(1), best_K(2), best_K(3), best_J);
end

function J = simula_PID(Kp, Ki, Kd, tau, n_core_data, n_omp_data, t)
    dt = t(2) - t(1);
    n_core = zeros(size(t));
    e_int = 0;
    e_prev = 0;
    y = zeros(size(t));
 
    % Assumiamo che i dati reali siano già allineati in termini di tempo
    % (se necessario, interpolerai i dati reali per il confronto con i dati simulati)
 
    for i = 2:length(t)
        % Trova l'indice più vicino per il tempo t(i)
        [~, idx_core] = min(abs(n_core_data.Time - t(i)));
        [~, idx_omp] = min(abs(n_omp_data.Time - t(i)));
 
        % Confronta la densità simulata con la densità reale (n_core_data e n_omp_data)
        e_core = n_core_data.Data(idx_core) - n_core(i-1);  % errore core
        e_omp = n_omp_data.Data(idx_omp) - n_omp_data.Data(idx_omp);  % errore omp
 
        % Calcola l'errore totale
        e = e_core + e_omp;
 
        e_int = e_int + e * dt;
        e_der = (e - e_prev) / dt;
 
        % PID controller
        S = Kp * e + Ki * e_int + Kd * e_der;
 
        % Modello dinamico: dot_n_core = S + (n_omp - n_core)/tau
        n_core_dot = S + (n_omp_data.Data(idx_omp) - n_core(i-1)) / tau;
        n_core(i) = n_core(i-1) + n_core_dot * dt;
 
        y(i) = n_core(i);
        e_prev = e;
    end
 
    % Calcola la funzione costo in base all'errore
    ref = n_core_data.Data(end);  % riferimento finale dal dato reale
    ess = abs(y(end) - ref);  % errore a regime
    overshoot = max(0, (max(y) - ref) * 100);
    idx_Ts = find(abs(y - ref) > 0.05 * ref, 1, 'last');
    if ~isempty(idx_Ts)
        Ts = t(idx_Ts);
    else
        Ts = 0;
    end
 
    J = 1 * overshoot + 1 * Ts + 10 * ess;
end

