clc
clear

load('standard.mat');
load('acf_result.mat');
load('amdf_result.mat');
load('hps_result.mat');
load('cep_result.mat');
load('wave_result.mat');
%% 

% fs = 44100;
% time = (0:1829)*500/fs;

figure(5);
plot(t,std4Check,'*k','linewidth',1); hold on
plot(acf_t, acf_detected_note_final,'linewidth',1.5);
plot(amdf_t, amdf_detected_note_final,'linewidth',1.5);
plot(hps_t, hps_noteTrack,'linewidth',1.5);
plot(cep_t, cep_noteTrack,'linewidth',1.5);
plot(wave_t, wave_noteTrack,'linewidth',1.5);


legend('Standard','ACF','AMDF','HPS','Cepstrum', 'Wavelet');
grid on
xlim([0,21]);
ylim([-10, 10]);
xlabel('Time [sec]')
ylabel('Note')

