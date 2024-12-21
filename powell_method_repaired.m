function [x_opt, f_val] = powell_method_repaired(f, x0, tol, max_iter)
    if nargin < 4
        max_iter = 100; % Máximo número de iteraciones por defecto
    end
    if nargin < 3
        tol = 1e-6; % Tolerancia por defecto
    end

    % Asegurar que x0 es un vector fila
    x = x0(:)'; % Convertir a vector fila si es necesario
    n = length(x) ; % Número de direcciones (dimensiones del problema)
    directions = eye(n); % Direcciones iniciales: vectores canónicos

    % Reparar el punto inicial
    x = repare(x);

    for iteration = 1:max_iter
        x_prev = x; % Guardar el último punto obtenido

        % Optimizar en cada dirección
        for i = 1:n
            % Convertir la dirección actual a vector fila
            direction_row = directions(:, i)'; % Transpuesta para obtener vector fila

            % Definir función unidimensional para la dirección actual
            f_alpha = @(alpha) f(repare(x + alpha * direction_row));

            % Encontrar alpha óptimo usando golden_search
            alpha_opt = golden_search(f_alpha);

            % Actualizar x con la nueva posición y repararlo
            x = repare(x + alpha_opt * direction_row);
        end

        % Calcular la nueva dirección conjugada
        d_new = x - x_prev;
        if norm(d_new) > tol
            d_new = d_new / norm(d_new); % Normalizar la dirección
        end

        % Actualizar las direcciones: ciclo hacia atrás y añadir d_new
        directions = [directions(:, 2:end), d_new'];

        % Criterio de paro
        if norm(x - x_prev) < tol
            break;
        end
    end

    % Resultados
    x_opt = x;
    f_val = f(x);
    
end

function alpha_opt = golden_search(f, a, b, tol)
    % Implementación del método de búsqueda dorada para encontrar mínimo
    % Entrada:
    %   f - Función a minimizar
    %   a, b - Intervalo inicial (opcional, por defecto [-1, 1])
    %   tol - Tolerancia (opcional, por defecto 1e-6)
    if nargin < 4
        tol = 1e-6;
    end
    if nargin < 3
        b = 1;
        a = -1;
    end

    phi = (1 + sqrt(5)) / 2; % Razón áurea
    resphi = 2 - phi;

    x1 = a + resphi * (b - a);
    x2 = b - resphi * (b - a);
    f1 = f(x1);
    f2 = f(x2);

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

    alpha_opt = (a + b) / 2;
end
