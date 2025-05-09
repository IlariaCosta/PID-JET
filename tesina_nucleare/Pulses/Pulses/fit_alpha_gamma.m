function [alpha_best, gamma_best] = fit_alpha_gamma(t_data, Tomp_interp, Ttar_interp, P_cond_interp, q_rad_data, Text, ci_T_omp, ci_T_tar, alpha_best, gamma_best)
   % === STIMA DI ALPHA E GAMMA CON RICERCA A GRIGLIA === 
    alphas = linspace(0.01, 100, 100);    
    gammas = linspace(0.01, 100, 100);    
     
    min_err = inf;  % errore minimo iniziale
    k_B = 8.617e-5;  % costante di Boltzmann
     
    % Condizioni iniziali
    Tsol0 = (ci_T_omp + ci_T_tar) / 2;
    y0 = [ci_T_omp; Tsol0; ci_T_tar];
     
    for i = 1:length(alphas)
        for j = 1:length(gammas)
            alpha = alphas(i);
            gamma = gammas(j);
     
            % Sistema dinamico con retroazione modificata (Tomp, Ttar moltiplicati per k_B)
            ode_fun = @(t, y) [
                (y(2) - k_B * y(1)) * alpha + P_cond_fun(t) / C1 - q_rad_fun(t) / C2;
                (k_B * y(1) - y(2)) * alpha + (k_B * y(3) - y(2)) * alpha - q_rad_fun(t) / C3;
                (y(2) - k_B * y(3)) * alpha + (273 - k_B * y(3)) * gamma - q_rad_fun(t) / C4
            ];
     
            [~, y] = ode45(ode_fun, t_data, y0);
     
            Tomp_sim = y(:,1);
            Ttar_sim = y(:,3);
     
            err = sum((Tomp_sim - Tomp_interp).^2) + sum((Ttar_sim - Ttar_interp).^2);
     
            if err < min_err
                min_err = err;
                alpha_best = alpha;
                gamma_best = gamma;
                y_best = y;
            end
        end
    end
    
    fprintf('Migliori parametri:\n');
    fprintf('alpha    = %.3f\n', alpha_best);
    fprintf('gamma   = %.3f\n', gamma_best);

end