function g = butter_coeffs(n)
    g = zeros(1, n);

    for k = 1:n
        theta_k = (2*k - 1) * pi / (2 * n);
        g(k) = 2*sin(theta_k);
    end

    % Reverse the coefficients
    g = [fliplr(g) 1];
end