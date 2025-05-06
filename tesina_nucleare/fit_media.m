function fit_media = fit_media(E, ne_core, E_observed)
 
    V = 80;
 
    % Interpola E per adattarla alla dimensione di E_observed (61x1)
    E_resized = interp1(1:length(E), E, linspace(1, length(E), length(E_observed)), 'linear');
    
    % Trova il valore ottimale di K usando fminsearch
    best_media = fminsearch(@(K) errore_K(K, E_resized, ne_core, V, E_observed), 1);  % punto iniziale K = 1 (regola se necessario)
 
    % Simula con il miglior valore di K
    E_sim_best = best_media * (E_resized / (3 * (ne_core * V)));
    ts_sim_best = timeseries(E_sim_best, E_observed.Time);  % Usa il tempo di E_observed per ts_sim_best
 
    % Plot confronto tra energia simulata e osservata
    figure;
    plot(E_observed.Time, E_observed.Data, 'r', 'DisplayName', 'Energia osservata');
    hold on;
    plot(ts_sim_best.Time, ts_sim_best.Data, 'b', 'DisplayName', 'Energia simulata con media');
    legend();
    xlabel('Tempo');
    ylabel('Energia [J]');
    title(['Fit di K = ', num2str(best_media)]);
    grid on;

end

% Funzione errore per trovare K
function err = errore_K(K, E_resized, ne_core, V, E_observed)
    % Calcola l'energia simulata con il parametro K
    E_sim = K * (E_resized / (3 * (ne_core * V)));
    ts_sim = timeseries(E_sim, E_observed.Time);  % Usa il tempo di E_observed per ts_sim
    
    % Estrai i dati dai timeseries per la sottrazione
    E_sim_data = ts_sim.Data;
    E_observed_data = E_observed.Data;
    size(E_sim_data)
    size(E_observed_data)
    
    % Calcola l'errore quadratico tra i dati simulati e osservati
    err = sum((E_sim_data - E_observed_data).^2);
end
