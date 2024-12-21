function x_min = golden_search(f, a, b, tol)
    if nargin < 4
        tol = 1e-6; % Tolerancia predeterminada
    end
    if nargin < 3
        b = 1; % Límite superior predeterminado
    end
    if nargin < 2
        a = -1; % Límite inferior predeterminado
    end

    phi = (1 + sqrt(5)) / 2; % Razón áurea
    resphi = 2 - phi;

    % Inicialización de los puntos
    x1 = a + resphi * (b - a);
    x2 = b - resphi * (b - a);
    f1 = f(x1);
    f2 = f(x2);

    % Iteración del método
    while abs(b - a) > tol
        if f1 < f2
            b = x2;
            x2 = x1;
            f2 = f1;
            x1 = a + resphi * (b - a);
            f1 = f(x1);
        else
            a = x1;
            x1 = x2;
            f1 = f2;
            x2 = b - resphi * (b - a);
            f2 = f(x2);
        end
    end

    % Retornar el valor mínimo aproximado
    x_min = (a + b) / 2;
end
