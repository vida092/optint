function [X_opt, f_opt, k] = marquardt(f_handle, X0, M, epsilon, lambda_init)
    % Método de Marquardt ajustado para trabajar con vectores fila
    % f_handle: función objetivo
    % X0: punto inicial (vector fila)
    % M: número máximo de iteraciones
    % epsilon: tolerancia
    % lambda_init: parámetro inicial de amortiguación

    if nargin < 5
        lambda_init = 1e4; % Valor por defecto de lambda inicial
    end

    % Asegurar que el punto inicial es un vector fila
    X = repare(X0); % Mantener como vector fila
    lambda = lambda_init;
    k = 0;

    while k < M
        % Gradiente numérico
        grad = gradient_numeric(f_handle, X, 1e-5); % Devuelve vector fila

        % Verificar convergencia
        if norm(grad) <= epsilon
            fprintf('Convergencia alcanzada en %d iteraciones.\n', k);
            break;
        end

        % Hessiana numérica
        H = hessian_numeric(f_handle, X); % Matriz cuadrada

        % Modificar Hessiana con lambda
        H_mod = H + lambda * eye(size(H));
        
        % Resolver el sistema lineal
        try
            % Calcular la inversa explícitamente
            H_inv = inv(H_mod);

            disp("-----------sí hay inversa--------------")
            % Calcular el paso

            s = -H_inv * grad; % Producto matricial

            s = s'; % Convertir de vuelta a vector fila
        catch
            fprintf('Error: La matriz no es invertible en la iteración %d.\n', k);
            break;
        end


        % Proponer nuevo punto
        X_new = X + s; % Mantener como vector fila
        X_new = repare(X_new);

        % Evaluar progreso
        if f_handle(X_new) < f_handle(X)
            X = X_new; % Aceptar el nuevo punto
            lambda = lambda / 2; % Reducir amortiguación
        else
            lambda = lambda * 2; % Incrementar amortiguación
        end

        % Imprimir estado
        fprintf('Iteración %d: punto [%s] con valor %f\n', k, num2str(X), f_handle(X));

        % Incrementar iterador
        k = k + 1;
    end

    % Resultados finales
    X_opt = repare(X); % Mantener como vector fila
    f_opt = f_handle(X_opt);
end