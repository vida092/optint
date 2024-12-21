function g = gradient_numeric(f, x, h)
    % Cálculo numérico del gradiente
    n = length(x);
    g = zeros(n, 1);
    for i = 1:n
        x_forward = x;
        x_forward(i) = x_forward(i) + h;
        g(i) = (f(x_forward) - f(x)) / h;
    end
end