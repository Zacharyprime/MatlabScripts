%n = order of filter
%ripple_db = ripple in dB
%Cfirst = 1 if the first element is a capacitor, 0 if inductor
function [S11, S21] = cheby_response(n, ripple_db,f0,delta,Z0,freq,seriesFirst)
    w0 = 2*pi*f0;
    ww = 2.*pi.*freq;
    g = chebyshev_coeffs(n, ripple_db);
    g = g(1:end-1); %get rid of the resistor part (part of external circuit)

    for mm=1:length(ww)
        ABCDtot = eye(2);
        for nn = 1:length(g)
            %Series
            if(seriesFirst == 1)
                L = Z0.*g(nn)./delta./w0;
                C = delta./Z0./g(nn)./w0;
                ABCDnext = [1, (1j.*ww(mm).*L+1./(1j.*ww(mm).*C)); 0, 1];
                seriesFirst = 0;
            %Shunt
            else
                L = Z0.*delta./g(nn)./w0;
                C = g(nn)./Z0./delta./w0;
                ABCDnext = [1, 0; (1j.*ww(mm).*C+1./(1j.*ww(mm).*L)), 1];
                seriesFirst = 1;
            end
            
            
            ABCDtot = ABCDtot*ABCDnext;
        end
        AA = ABCDtot(1,1);
        BB = ABCDtot(1,2);
        CC = ABCDtot(2,1);
        DD = ABCDtot(2,2);
    
        S11(mm) = (AA+BB-CC-DD)./(AA+BB+CC+DD);
        S21(mm) = 2./(AA+BB+CC+DD);
    end

    % Read data from the text file exported from AWR
    data = readtable('BPcheby.txt', 'Delimiter', '\t');
    awr_freq = data{:, 1}; % Frequency in GHz
    awr_S11 = data{:, 3};  % |S(1,1)|
    awr_S21 = data{:, 2};  % |S(2,1)|

    % Plot S11 from MATLAB and AWR
    figure;
    subplot(1,2,1);
    plot(freq / 1e9, 20 * log10(abs(S11)), 'r', 'LineWidth', 2);
    hold on;
    plot(awr_freq, awr_S11, 'b--', 'LineWidth', 2);
    xlabel('Frequency (GHz)');
    ylabel('Magnitude (dB)');
    title('S11 Comparison: Matlab vs AWR');
    legend('|S(1,1)| (Matlab)', '|S(1,1)| (AWR)');
    grid on;
    hold off;

    % Plot S21 from MATLAB and AWR
    subplot(1,2,2);
    plot(freq / 1e9, 20 * log10(abs(S21)), 'g', 'LineWidth', 2);
    hold on;
    plot(awr_freq, awr_S21, 'm--', 'LineWidth', 2);
    xlabel('Frequency (GHz)');
    ylabel('Magnitude (dB)');
    title('S21 Comparison: Matlab vs AWR');
    legend('|S(2,1)| (Matlab)', '|S(2,1)| (AWR)');
    grid on;
    hold off;
end