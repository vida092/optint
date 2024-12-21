% 1. Carga el archivo CSV
clc
clear
filename = 'data1.csv'; % Reemplaza con la ruta de tu archivo
D = readmatrix(filename); % Lee el archivo CSV como una matriz numérica

% 2. Separa las características (X) y las etiquetas (y)
X = D(:, 1:end-1); % Todas las columnas excepto la última
y = D(:, end);     % Última columna (etiquetas)


[~, ~, y] = unique(y);

% 4. Calcula las medias y dispersión para LDA
[num_samples, num_features] = size(X);
classes = unique(y);
num_classes = numel(classes);

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
W = V(:, 1:min(num_classes - 1, num_features)); % Matriz de proyección

% 6. Proyecta los datos en el espacio reducido
X_lda = X * W;

% 7. Define la paleta de colores
color_map = [1 0 0; 0 0 1; 1 0.8 0.3]; % Rojo, Azul, Naranja
class_labels = arrayfun(@(c) sprintf('Clase %d', c), classes, 'UniformOutput', false);


% Scatter plot de las primeras 3 columnas de los datos originales
% figure;
% hold on;
% for k = 1:num_classes
%     scatter3(X(y == k, 1), X(y == k, 2), X(y == k, 3), 30, color_map(k, :), 'filled');
% end
% title('Datos originales (3 primeras columnas)');
% xlabel('Columna 1');
% ylabel('Columna 2');
% zlabel('Columna 3');
% grid on;
% legend(class_labels, 'Location', 'best');
% hold off;

% Scatter plot de los datos proyectados con LDA (2D)
figure;
hold on;
for k = 1:num_classes
    scatter(X_lda(y == k, 1), X_lda(y == k, 2), 30, color_map(k, :), 'filled');
end
title('Proyección LDA (2D)');
xlabel('LDA Dim 1');
ylabel('LDA Dim 2');
grid on;
legend(class_labels, 'Location', 'best');
hold off;

csvwrite("LDA_"+ filename,[X_lda y] )








