function H = hessian_numeric(f, x, delta)
    if nargin < 3
        delta = 1e-4; % Valor por defecto para delta
    end
    
    n = length(x);
    H = zeros(n, n); % Inicializar la matriz Hessiana
    
    for i = 1:n
        for j = 1:n
            if i == j
                % Segunda derivada parcial en diagonal (i == j)
                x_forward = x;
                x_backward = x;
                x_forward(i) = x_forward(i) + delta;
                x_backward(i) = x_backward(i) - delta;
                H(i, j) = (f(x_forward) - 2 * f(x) + f(x_backward)) / (delta^2);
            else
                % Segunda derivada parcial cruzada (i != j)
                x_ij_pp = x; % x + delta_i + delta_j
                x_ij_pm = x; % x + delta_i - delta_j
                x_ij_mp = x; % x - delta_i + delta_j
                x_ij_mm = x; % x - delta_i - delta_j
                
                x_ij_pp(i) = x_ij_pp(i) + delta;
                x_ij_pp(j) = x_ij_pp(j) + delta;
                
                x_ij_pm(i) = x_ij_pm(i) + delta;
                x_ij_pm(j) = x_ij_pm(j) - delta;
                
                x_ij_mp(i) = x_ij_mp(i) - delta;
                x_ij_mp(j) = x_ij_mp(j) + delta;
                
                x_ij_mm(i) = x_ij_mm(i) - delta;
                x_ij_mm(j) = x_ij_mm(j) - delta;
                
                H(i, j) = (f(x_ij_pp) - f(x_ij_pm) - f(x_ij_mp) + f(x_ij_mm)) / (4 * delta^2);
                H(j, i) = H(i, j); % Simetría de la Hessiana
            end
        end
    end
end
