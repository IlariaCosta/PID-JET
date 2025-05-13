function ottimizza_PID(n_core_data, n_omp_data)

    t = n_core_data.Time;  % Tempo
    dt = t(2) - t(1);

    % Range PID da esplorare
    Kp_vals = linspace(0.1, 5000, 500);
    Ki_vals = linspace(0, 2000, 100);
    Kd_vals = linspace(0, 1000, 100);

    best_J = Inf;
    best_K = [0 0 0];

    for Kp = Kp_vals
        for Ki = Ki_vals
            for Kd = Kd_vals
                J = simula_PID(Kp, Ki, Kd, 300, n_omp_data, t);
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

function J = simula_PID(Kp, Ki, Kd, tau, n_omp_data, t)
    dt = t(2) - t(1);
    n_core = zeros(size(t));
    e_int = 0;
    e_prev = 0;
    y = zeros(size(t));

    ref = 1e20;  % riferimento costante

    for i = 2:length(t)
        [~, idx_omp] = min(abs(n_omp_data.Time - t(i)));

        e = ref - n_core(i-1);
        e_int = e_int + e * dt;
        e_der = (e - e_prev) / dt;

        % PID
        S = Kp * e + Ki * e_int + Kd * e_der;

        % Modello dinamico
        n_core_dot = S + (n_omp_data.Data(idx_omp) - n_core(i-1)) / tau;
        n_core(i) = n_core(i-1) + n_core_dot * dt;

        y(i) = n_core(i);
        e_prev = e;
    end

    % Funzione costo
    ess = abs(y(end) - ref);
    overshoot = max(0, (max(y) - ref) * 100 / ref);  % in percentuale
    idx_Ts = find(abs(y - ref) > 0.05 * ref, 1, 'last');
    if ~isempty(idx_Ts)
        Ts = t(idx_Ts);
    else
        Ts = 0;
    end

    J = 1 * overshoot + 1 * Ts + 10 * ess;
end
