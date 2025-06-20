function ottimizza_PID()
 
    n = 0;
    t = 0:0.001:3;  % 3 secondi con dt = 1ms
    dt = t(2) - t(1);
    % Range PID da esplorare (puoi restringere per velocizzare)
    Kp_vals = linspace(1e2, 1e15, 100);
    Ki_vals = linspace(1e2, 1e15, 100);
    Kd_vals = linspace(1, 1e3, 50);
 
    best_J = Inf;
    best_K = [0 0 0];
 
    for Kp = Kp_vals
        for Ki = Ki_vals
            for Kd = Kd_vals
                n = n+1;
                J = simula_PID(Kp, Ki, Kd, t);
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
 
 
function J = simula_PID(Kp, Ki, Kd, t)
    dt = t(2) - t(1);
    n_core = zeros(size(t));  % Stato
    e_int = 0;
    e_prev = 0;
    ref = 1e20;
 
    delay = 0.0019;
    alpha = exp(-dt / 0.002);  % per G(s) = 0.91 / (0.002s + 1)
    G_gain = 0.91;
    G_state = 0;
    PID_history = zeros(size(t));
    nz_history = zeros(size(t));
 
    for i = 2:length(t)
        current_time = t(i);
        e = ref - n_core(i-1);
        e_int = e_int + e * dt;
        e_der = (e - e_prev) / dt;
 
        % PID controller
        S = Kp * e + Ki * e_int + Kd * e_der;
        PID_history(i) = S;
 
        % Delay
        delayed_time = current_time - delay;
        if delayed_time < 0
            S_delayed = 0;
        else
            S_delayed = interp1(t(1:i), PID_history(1:i), delayed_time, 'linear', 0);
        end
 
        % Filtro G(s)
        G_state = alpha * G_state + (1 - alpha) * S_delayed;
        G_output = G_gain * G_state;
 
        % Saturazione
        nz = max(0, G_output);
        nz_history(i) = nz;
 
        % Dinamica sistema: assume derivata = nz
        n_core(i) = n_core(i-1) + nz * dt;
 
        e_prev = e;
    end
 
    % Costo: somma ponderata di errori
    ess = abs(n_core(end) - ref);
    overshoot = max(0, (max(n_core) - ref) * 100 / ref);  % percentuale
    idx_Ts = find(abs(n_core - ref) > 0.05 * ref, 1, 'last');
    if ~isempty(idx_Ts)
        Ts = t(idx_Ts);
    else
        Ts = 0;
    end
 
    % Funzione obiettivo: puoi regolare i pesi
    J = 1 * overshoot + 1 * Ts + 10 * ess;
end