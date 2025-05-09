function [best_tau, best_E] = fit_controllo(sparo, indici)
    % === CARICAMENTO DATI ===
    load(sparo);
     
    % === ESTRAZIONE INTERVALLI ===
    i1 = indici(1);
    i2 = indici(2);
    tempo_data = Data.t(i1:i2)';
    tempo_data = tempo_data - tempo_data(1);  % tempo da 0
     
    % === DATI DI ENERGIA ===
    media_energia = (timeseries(Data.WP(i1:i2)', tempo_data) + ...
                     timeseries(Data.WDIA(i1:i2)', tempo_data)) / 2;
    media_energia.Time = media_energia.Time - media_energia.Time(1);
    ci_energia = media_energia.Data(1);  % condizione iniziale
     
    % === POTENZE ===
    Pnbi   = timeseries(Data.PTOT(i1:i2)', tempo_data);
    Pnbi.Time = Pnbi.Time - Pnbi.Time(1);
    Z_eff = timeseries(Data.ZEFF(i1:i2)', tempo_data);
    Z_eff.Time = Z_eff.Time - Z_eff.Time(1);
    temp_core_data = timeseries(TS.T.T(1,61:121)', TS.N.t(61:121)' - TS.N.t(61));
    n_core_data = timeseries(TS.N.T(1,61:121)', TS.N.t(61:121)' - TS.N.t(61));
     
    % Interpolazione su tempo comune
    t = tempo_data;
    Zeff_data     = interp1(Z_eff.Time, Z_eff.Data, t);
    Te_core_data  = interp1(temp_core_data.Time, temp_core_data.Data, t);
    ni_data       = interp1(n_core_data.Time, n_core_data.Data, t);
    ne_data       = ni_data;  % assumiamo ni ≈ ne (plasma quasi neutro)
    V = 80; 
     
    % Calcolo P_brem
    P_brem_data = (1.7e-38) .* Zeff_data.^2 .* ni_data .* ne_data .* sqrt(Te_core_data) * V;
     
    % Impurezze trascurate
    cz = 1;
    P_imp_data = cz * ne_data.^2 * 1e-34;
    
     
    % === FIT DI TAUE ===
    taues = linspace(0.01, 0.5, 100);  % esplorazione
    min_err = Inf;
    best_tau = 0;
    best_E = [];

    disp('Check dimensione e NaN dei dati:');
    disp(['Pnbi: ', num2str(any(isnan(Pnbi.Data)))]);
    disp(['P_brem_data: ', num2str(any(isnan(P_brem_data)))]);
    disp(['P_imp_data: ', num2str(any(isnan(P_imp_data)))]);
    P_brem_data = fillmissing(P_brem_data, 'linear');
P_imp_data  = fillmissing(P_imp_data, 'linear');


     
    for i = 1:length(taues)
        taue = taues(i);
        % Simulazione equazione differenziale con ode45
        [t_sim, E_sim] = ode45(@(tt, E) eqDiff(taue, E, ...
                        interp1(Pnbi.Time, Pnbi.Data, tt, 'linear', 'extrap'), ...
                        interp1(t, P_brem_data, tt, 'linear', 'extrap'), ...
                        interp1(t, P_imp_data, tt, 'linear', 'extrap')), ...
                        t, ci_energia);
     
        % Interpolazione per confronto
        E_interp = interp1(t_sim, E_sim, t, 'linear', 'extrap');
        err = sum((E_interp - media_energia.Data).^2);
     
        if err < min_err
            min_err = err;
            best_tau = taue;
            best_E = E_interp;
        end
    end
     
    % === RISULTATI ===
    fprintf('Miglior taue = %.4f s (errore %.4e)\n', best_tau, min_err);
     
    % % === PLOT ===
    % figure;
    % plot(t, media_energia.Data, 'k--', 'DisplayName','Energia reale');
    % hold on;
    % plot(t, best_E, 'b', 'DisplayName','Energia simulata');
    % xlabel('Tempo [s]');
    % ylabel('Energia [J]');
    % title(['Fit \tau_e per sparo (migliore: ', num2str(best_tau), ' s)']);
    % legend;
    % grid on;
end
 
% === EQUAZIONE DIFFERENZIALE ===
function dE = eqDiff(tau, E, Pnbi, P_brem, P_imp)
    dE = -(1/tau)*E + Pnbi - P_brem - P_imp;
end