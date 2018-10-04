amp = 1;
fs = 44100;
duration = 10;
f = 1:1:500;
values_full = 0:1/fs:duration;
sample_sig_full = amp * sin(2 * pi * f(1) * values_full);

for x = f(2:end)
    sample_sig_full = sample_sig_full + amp * sin(2 * pi * x * values_full);
end
sample_sig_full = sample_sig_full'./max(sample_sig_full);
% wavwrite(a,'100hz-500hz-1hz.wav');
audiowrite('100hz-500hz-1hz.wav',sample_sig_full,fs);

% Compute the Fourier transform of the signal.
tstart = 0.02;
tstep = 1/10;%i.e. sample at 100Hz
smpl = find(values_full >=tstart & values_full <= (tstart + tstep));
values_sig = values_full(smpl);
sample_sig = sample_sig_full(smpl);

sig_fft = fft(sample_sig);d

% Compute the two-sided spectrum P2. Then compute the single-sided spectrum P1 based on P2 and the even-valued signal length L.
P2 = abs(sig_fft./numel(values_sig));
P1 = P2(1:numel(values_sig)/2+1);
P1(2:end-1) = 2 * P1(2:end-1);

% Define the frequency domain f and plot the single-sided amplitude spectrum P1.
% The amplitudes are not exactly at 0.7 and 1, as expected, because of the added noise.
% On average, longer signals produce better frequency approximations.

fftx = fs*(0:(numel(values_sig)/2))/numel(values_sig);

figure
ax1 = subplot(3,1,1);
ax2 = subplot(3,1,2);
ax3 = subplot(3,1,3);

plot(ax1,values_sig,sample_sig)
title(ax1,sprintf('Sound Signal Generated. Frequency is resultant of %d to %d in steps of %d',f(1),f(end),f(2)-f(1)))
ylabel(ax1,'Amplitude')
xlabel(ax1,'Time in seconds')


plot(ax2,fftx,P1)
title(ax2,'FFT transform of generated signal from source')
ylabel(ax2,'Amplitude')
xlabel(ax2,'Frequency in Hz')
ylim(ax2,[0 inf])
% zoom in to desired frequency range:
desired_freq_min = f(1);
desired_freq_max = f(end);
filtered_index = find(fftx >= desired_freq_min & fftx <= desired_freq_max);
plot(ax3,fftx(filtered_index),P1(filtered_index))
title(ax3,'FFT transform of generated signal from source (Zoomed in)')
ylabel(ax3,'Amplitude')
xlabel(ax3,'Frequency in Hz')
ylim(ax3,[0 inf])

% plot(values,sample_sig)
% sound(sample_sig)