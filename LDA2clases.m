clear
clc
filename = 'ionospherec.csv'; % Reemplaza con la ruta de tu archivo
D = readmatrix(filename); % Lee el archivo CSV como una matriz numérica

% 2. Separa las características (X) y las etiquetas (y)
X = D(:, 1:end-1); % Todas las columnas excepto la última
y = D(:, end);     % Última columna (etiquetas)

[~, ~, y] = unique(y);

% 4. Calcula las medias y dispersión para LDA
[num_samples, num_features] = size(X);
classes = unique(y);
num_classes = numel(classes);

if num_classes ~= 2
    error('Este código está diseñado solo para el caso de dos clases.');
end

global_mean = mean(X, 1);
S_W = zeros(num_features, num_features);
S_B = zeros(num_features, num_features);

for k = 1:num_classes
    X_k = X(y == classes(k), :); % Datos de la clase k
    mean_k = mean(X_k, 1); % Media de la clase k
    % Dispersión intra-clase
    S_W = S_W + (X_k - mean_k)' * (X_k - mean_k);
    % Dispersión entre clases
    n_k = size(X_k, 1); % Número de muestras en la clase k
    S_B = S_B + n_k * (mean_k - global_mean)' * (mean_k - global_mean);
end

% 5. Resuelve el problema de eigenvalores
[V, D] = eig(S_B, S_W); % V son los vectores propios, D los valores propios
[~, idx] = sort(diag(D), 'descend'); % Ordena por importancia
V = V(:, idx); % Reorganiza los vectores propios
W = V(:, 1); % Para 2 clases, solo se necesita el primer vector propio

% 6. Proyecta los datos en el espacio reducido
X_lda = X * W;

% 7. Define la paleta de colores
color_map = [1 0 0; 0 0 1]; % Rojo, Azul
class_labels = arrayfun(@(c) sprintf('Clase %d', c), classes, 'UniformOutput', false);

% Scatter plot de los datos proyectados con LDA (1D)
figure;
hold on;
for k = 1:num_classes
    scatter(X_lda(y == k), zeros(sum(y == k), 1), 30, color_map(k, :), 'filled');
end
title('Proyección LDA (1D)');
xlabel('LDA Dim 1');
grid on;
legend(class_labels, 'Location', 'best');
hold off;

% Guarda los datos proyectados
csvwrite("LDA_" + filename, [X_lda y]);
% runClassification("LDA_wbc_clean.csv", 'holdout', 0.3);
% runClassification("LDA_wbc_clean.csv", 'kfold');
