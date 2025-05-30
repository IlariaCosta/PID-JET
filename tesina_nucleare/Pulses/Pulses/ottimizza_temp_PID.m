function ottimizza_temp_PID(temp_core_data, temp_omp_data, temp_tar_data, ne_data, P_tot, Zeff_data)

    cz = 1.0;
    V = 80;
    t = temp_core_data.Time;

    % Range PID da esplorare
    Kp_vals = linspace(0.01, 80000, 300);
    Ki_vals = linspace(0.01, 200000, 100);
    Kd_vals = linspace(0.01, 100, 50);

    best_J = Inf;
    best_K = [0 0 0];

    for Kp = Kp_vals
        for Ki = Ki_vals
            for Kd = Kd_vals
                J = simula_temp_PID(Kp, Ki, Kd, 300, temp_core_data, temp_omp_data, temp_tar_data, ne_data, Zeff_data, cz, V, t, P_tot);
                if J < best_J
                    best_J = J;
                    best_K = [Kp, Ki, Kd];
                end
            end
        end
    end

    fprintf('=== PID Ottimizzato per la Temperatura ===\n');
    fprintf('Kp = %.3f\nKi = %.3f\nKd = %.3f\nCosto J = %.4f\n', ...
        best_K(1), best_K(2), best_K(3), best_J);
end


function J = simula_temp_PID(Kp, Ki, Kd, tau, temp_core_data, temp_omp_data, temp_tar_data, ne_data, Zeff_data, cz, V, t, P_tot)

    dt = t(2) - t(1);
    E = zeros(size(t));
    e_int = 0;
    e_prev = 0;
    y = zeros(size(t));

    Pnbi = interp1(P_tot.Time, P_tot.Data, t, 'linear', 'extrap');
    T_tar_interp = interp1(temp_tar_data.Time, temp_tar_data.Data, t, 'linear', 'extrap');

    ref = 1200;  % target di temperatura

    for i = 2:length(t)
        [~, idx_core] = min(abs(temp_core_data.Time - t(i)));
        [~, idx_omp] = min(abs(temp_omp_data.Time - t(i)));
        [~, idx_ne] = min(abs(ne_data.Time - t(i)));
        [~, idx_Zeff] = min(abs(Zeff_data.Time - t(i)));

        T_core = temp_core_data.Data(idx_core);
        T_omp = temp_omp_data.Data(idx_omp);
        T_tar = T_tar_interp(i);
        ne_val = ne_data.Data(idx_ne);
        Zeff_val = Zeff_data.Data(idx_Zeff);

        P_brem = 1.7e-38 * Zeff_val^2 * ne_val^2 * sqrt(T_core) * V;
        P_imp = cz * ne_val^2 * 1e-34;

        % PID su errore rispetto al riferimento
        e = ref - E(i-1);
        e_int = e_int + e * dt;
        e_der = (e - e_prev) / dt;
        S = Kp * e + Ki * e_int + Kd * e_der;

        % Dinamica
        E_dot = -(1/tau) * E(i-1) + S + Pnbi(i) - P_brem - P_imp;
        E(i) = E(i-1) + E_dot * dt;
        y(i) = E(i);
        e_prev = e;
    end

    % Funzione di costo
    ess = abs(y(end) - ref);
    overshoot = max(0, (max(y) - ref) * 100 / ref);
    idx_Ts = find(abs(y - ref) > 0.05 * ref, 1, 'last');
    Ts = t(idx_Ts); 
    if ~isempty(idx_Ts) 
    else 0;
    end

    J = 1 * overshoot + 1 * Ts + 10 * ess;
end
