function generate_filter(type,n,ripple)
    %Above 3db, we assume that it is return loss, so convert to insertion
    %loss by assuming the filter is lossless
    if(ripple>3)
        ripple = -10*log10(1-10^(-ripple/10));
    end
    
    if(strcmp(type,'butter'))
        disp("Butterworth Filter up to order " + num2str(n) + " with " + num2str(ripple) + "dB ripple" )
        for pp = 1:n
            disp(num2str(pp) + ": " + num2str(butter_coeffs(pp)))
        end
    else
        disp("Chebychev Filter up to order " + num2str(n) + " with " + num2str(ripple) + "dB ripple" )
        for pp = 1:n
            disp(num2str(pp) + ": " + num2str(chebyshev_coeffs(pp,ripple)))
        end
    end
end