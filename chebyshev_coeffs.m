function g = chebyshev_coeffs(n, ripple_db)
    %Step 1: Find epsilon
    epsilon = sqrt(10^(ripple_db/10) - 1);

    %Step 2: Calculate eta
    eta = sinh(asinh(1/epsilon)/n);

    g(1) = 1;
    g(2) = (2/eta)*sin(pi/2/n);

    %even order
    if(mod(n,2)==0)
        g(n+2) = (epsilon+sqrt(1+epsilon^2))^2;
    % odd order
    else
        g(n+2) = 1;
    end

    for k = 2:n
        r = k-1;
        g(k+1) = 4*sin((2*r-1)*pi/2/n)*sin((2*r+1)*pi/2/n)/(eta^2+sin(r*pi/n)^2)/g(k);
    end

    g = g(2:end);
end