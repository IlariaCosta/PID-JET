function [alpha_best, gamma_best] = fit_alpha_gamma(t_data, Tomp_data, Ttar_data, P_cond_data, q_rad_data, Text, ci_Tomp, ci_Ttar)
 
    % Costanti geometriche
    C1 = 1000 * 0.014 * 3;
    C2 = 3 * 3;
    C3 = 3 * 3;
    C4 = 9;
 
    % Interpolazioni dei dati
    P_cond_fun = @(t) interp1(t_data, P_cond_data, t, 'linear', 'extrap');
    q_rad_fun  = @(t) interp1(t_data, q_rad_data, t, 'linear', 'extrap');
 
    % Funzione errore da minimizzare (somme quadrati errori)
    funzione_errore = @(params) compute_error(params, t_data, Tomp_data, Ttar_data, ...
                                              P_cond_fun, q_rad_fun, Text, ...
                                              ci_Tomp, ci_Ttar, C1, C2, C3, C4);
 
    % Valori iniziali di alpha e gamma
    x0 = [0.1, 0.1];
 
    % Ottimizzazione
    best_params = fminsearch(funzione_errore, x0);
    alpha_best = best_params(1);
    gamma_best = best_params(2);
end
 
function err = compute_error(params, t_data, Tomp_data, Ttar_data, ...
                             P_cond_fun, q_rad_fun, Text, ...
                             ci_Tomp, ci_Ttar, C1, C2, C3, C4)
    alpha = params(1);
    gamma = params(2);
 
    % Condizioni iniziali: Tomp(0), Tsol(0) stimato come media, Ttar(0)
    Tsol0 = (ci_Tomp + ci_Ttar) / 2;
    y0 = [ci_Tomp; Tsol0; ci_Ttar];
 
    % Sistema dinamico
    ode_fun = @(t, y) [
        (y(2) - y(1)) * alpha + P_cond_fun(t) / C1 - q_rad_fun(t) / C2; % Tomp_dot
        (y(1) - y(2)) * alpha + (y(3) - y(2)) * alpha - q_rad_fun(t) / C3; % Tsol_dot
        (y(2) - y(3)) * alpha + (Text - y(3)) * gamma - q_rad_fun(t) / C4 % Ttar_dot
    ];
 
    % Integrazione
    [~, y] = ode45(ode_fun, t_data, y0);
 
    % Estrai Tomp e Ttar simulati
    Tomp_sim = y(:,1);
    Ttar_sim = y(:,3);
 
    % Errore come somma quadrati differenze
    err = sum((Tomp_sim - Tomp_data).^2) + sum((Ttar_sim - Ttar_data).^2);
end