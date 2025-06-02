%%
clear;
clc
close all
load("list_pulse.mat")
load("pulse_bon.mat")

%% Caricamento dati per simulink
% dati_config();
load dati_conf.mat;

%%

% for i=1:length(pulse_bon)
% 
%     load(name_l{pulse_bon(i)});
% 
%     figure(1)
%     clf;
%     ax1=subplot(2,4,1);
%     plot(Data.t,Data.Ip,'LineWidth', 2)
%     xlabel('Tempo [s]', 'FontSize', 13);
%     title('Plasma current [A]', 'FontSize', 13)
%     grid on;
%     ax2=subplot(2,4,2);
%     grid on;
%     hold off
%     plot(Data.t,Data.PTOT, 'LineWidth', 2)
%     grid on;
%     hold on
%     plot(Data.t,Data.Prad, 'LineWidth', 2)
%     legend(['P_in';'Prad'])
%     xlabel('Tempo [s]', 'FontSize', 13);
%     title('Power [W]','FontSize', 13)
%     grid on;
%     ax3=subplot(2,4,3);
%     hold off
%     plot(Data.t,Data.WDIA,'LineWidth', 2)
%     grid on;
%     hold on;
%     plot(Data.t,Data.WP,'LineWidth', 2)
%      xlabel('Tempo [s]', 'FontSize', 13);
%      title('Plasma Energy [J]','FontSize', 13)
%      grid on;
%      ax4=subplot(2,4,4);
%      grid on;
%      try
%         hold off
%         plot(Data.t,Data.ZEFF,'LineWidth', 2)
%         grid on;
%         xlabel('Tempo [s]', 'FontSize', 13);
%         title('ZEFF','FontSize', 13)
%      catch
%      end
%     ax5=subplot(2,4,5);
%     grid on;
%     hold off
%     plot(TS.T.t,TS.T.T(1,:),'LineWidth', 2);
%     yyaxis right
%     plot(TS.T.t,TS.T.T(56,:),'LineWidth', 2);     
%     legend(["Core";"OMP"])
%     xlabel('Tempo [s]', 'FontSize', 13);
%     title('Temperature [eV]','FontSize', 13)
%     grid on;
%     ax6=subplot(2,4,6);
%     grid on;
%     hold off
%     plot(TS.T.t,TS.N.T(1,:), 'LineWidth', 2); 
%     hold on
%     grid on;
%     plot(TS.T.t,interp1(Data.t,Data.Lan_Ne,TS.T.t),'LineWidth', 2);
%     grid on;
%     plot(TS.T.t,TS.N.T(56,:),'LineWidth', 2);
%     grid on;
%     ylim([0 Inf])
% 
%     legend(["Core";"TAR";"OMP"])
%     xlabel('Tempo [s]', 'FontSize', 13);
%     title('Density [n_{e}/m^{3}]','FontSize', 13)
%     ax7=subplot(2,4,7);
%     grid on;
%     hold off
%     plot(Data.t,Data.D2,'LineWidth', 2);
%     grid on;
% 
%     if Error.NE==0 || Error.N2==0
%     yyaxis right
% 
%     try
%         plot(Data.t,Data.N2,'LineWidth', 2);
%         grid on;
%     catch
%     plot(Data.t,Data.NE,'LineWidth', 2);
%     grid on;
%     end
%     end
%     xlabel('Tempo [s]', 'FontSize', 13);
%     title('Valves [n_{e}/m^{3}]','FontSize', 13)
% 
%     ax8=subplot(2,4,8);
%     hold off
%     plot(Data.t,Data.Lan_TE,'LineWidth', 2);
%     grid on;
%     xlabel('Tempo [s]', 'FontSize', 13);
%     title('T_{TAR} [eV]','FontSize', 13)
% 
%     sgtitle(num2str(shot))
%     linkaxes([ax1,ax2,ax3,ax4,ax5,ax6,ax7,ax8],'x')
%     drawnow;
%     pause()
% end

%% IMPOSTAZIONI SCOPE
clc
fig = figure(2);              % Ottiene la figura corrente
axs = findall(fig, 'Type', 'axes'); 
set(axs, 'FontSize', 14);  % Cambia la dimensione del font degli assi
lgd = findall(fig, 'Type', 'Legend');
set(lgd, 'FontSize', 14);

fig = figure(3);              % Ottiene la figura corrente
axs = findall(fig, 'Type', 'axes'); 
set(axs, 'FontSize', 14);  % Cambia la dimensione del font degli assi
lgd = findall(fig, 'Type', 'Legend');
set(lgd, 'FontSize', 14);

fig = figure(4);              % Ottiene la figura corrente
axs = findall(fig, 'Type', 'axes'); 
set(axs, 'FontSize', 14);  % Cambia la dimensione del font degli assi
lgd = findall(fig, 'Type', 'Legend');
set(lgd, 'FontSize', 14);

fig = figure(1);              % Ottiene la figura corrente
axs = findall(fig, 'Type', 'axes'); 
set(axs, 'FontSize', 14);  % Cambia la dimensione del font degli assi
lgd = findall(fig, 'Type', 'Legend');
set(lgd, 'FontSize', 14);

%% DATI SPARI ANALIZZATI

% dati_sparo_1(name_l);
% dati_sparo_2(name_l);
% dati_sparo_3(name_l);

%% 1. Sparo 94568
load param_sparo_1.mat
% clc
ottimizza_PID();
% ottimizza_temp_PID(temp_core_data, temp_omp_data, temp_tar_data, n_core_data, P_tot, Z_eff);

%% 2. Sparo 95502
load param_sparo_2.mat

%% 3. Sparo 95503
load param_sparo_3.mat


