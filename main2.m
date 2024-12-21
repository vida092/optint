clc
clear
database = "ionospherec";
D = readmatrix(database+".csv");
features = D(:, 3:end-1);
labels = D(:, end);
[m, nl] = size(D);

n = nl - 1;


x0 = rand(1, 2 * n); % Punto inicial como vector fila


f_handle = @(x) f(x, D);


% Parámetros del método
M = 100; % Iteraciones máximas
epsilon = 1e-5; % Tolerancia
lambda_init = 1e4; % Parámetro inicial de amortiguación

% Ejecutar el método
tic
[X_opt, f_opt, k] = marquardt(f_handle, x0, M, epsilon, lambda_init);
toc
fprintf('Punto óptimo: [%s]\n', num2str(X_opt));
fprintf('Valor óptimo: %f\n', f_opt);
fprintf('Número de iteraciones: %d\n', k);

scatter_plot_2d(X_opt,D, "Mejor resultado")


column1 = X_opt(1:n)';
column2 = X_opt(n+1:end)';
mat = [column1 column2];
projected = features * mat;
projected_labels = [projected labels];


writematrix( projected_labels, database+"_projected_marquardt.csv")

runClassification(database+"_projected_marquardt.csv", "holdout")