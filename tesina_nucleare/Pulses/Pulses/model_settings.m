function model_settings(nome_modello, nome_scope)
   
    % Apri e simula il modello
    load_system(nome_modello);
    sim(nome_modello);
     
    % Trova il blocco Scope
    scope_path = [nome_modello, '/', nome_scope];
    set_param(scope_path, 'Open', 'on');
    set_param(scope_path, 'Floating', 'on');
    set_param(scope_path, 'SaveToWorkspace', 'on');
    set_param(scope_path, 'SaveToFile', 'off');
    set_param(scope_path, 'LimitDataPoints', 'off');
    set_param(scope_path, 'AutoRestart', 'on');
     
    pause(1);  % Attendi aggiornamento
     
    % Trova e copia il contenuto dello Scope
    hScope = findall(0, 'Tag', 'SIMULINK_SIMSCOPE_FIGURE');
    if ~isempty(hScope)
        figureHandle = figure('Visible', 'off');  % Crea figura invisibile
        copyobj(allchild(hScope), figureHandle);
     
        axs = findall(figureHandle, 'Type', 'axes');
        for ax = axs'
            ax.FontSize = 16;
            ax.FontName = 'Arial';
            ax.XColor = 'k';
            ax.YColor = 'k';
            ax.Title.FontSize = 18;
            ax.Title.FontName = 'Arial';
        end
     
        lgd = findall(figureHandle, 'Type', 'legend');
        if ~isempty(lgd)
            set(lgd, 'FontSize', 14, 'FontName', 'Arial');
        end
     
        set(figureHandle, 'Visible', 'on');  % Mostra figura finale
    end

end