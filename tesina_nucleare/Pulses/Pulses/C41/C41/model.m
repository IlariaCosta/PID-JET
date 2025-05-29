% === FUNZIONE MODELLO ===
function dxdt = model(~, x, S_core, S_tar, tau, tau1)
    n_core = x(1);
    n_omp  = x(2);
    n_SOL  = x(3);
    n_tar  = x(4);
 
    n_core_dot = S_core + (n_omp - n_core)/tau;
    n_omp_dot  = (n_core - n_omp)/tau + (n_SOL - n_omp)/tau;
    n_SOL_dot  = (n_omp - n_SOL)/tau + (n_tar - n_SOL)/tau;
    n_tar_dot  = S_tar + (n_SOL - n_tar)/tau - n_tar/tau1;
 
    dxdt = [n_core_dot;
            n_omp_dot;
            n_SOL_dot;
            n_tar_dot];
end