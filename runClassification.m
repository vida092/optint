function runClassification(databaseName, validationType, varargin)
    data = readmatrix(databaseName);

    % Asumimos que la última columna son las etiquetas de clase
    labels = data(:, end); % Etiquetas de clase
    features = data(:, 1:end-1); % Características (todas menos la última)

    % Configurar validación
    rng('default'); % Para reproducibilidad
    if strcmp(validationType, 'holdout')
        % Validación Hold-Out
        holdoutRatio = 0.10; % Valor por defecto
        if ~isempty(varargin)
            holdoutRatio = varargin{1};
        end
        cv = cvpartition(labels, 'HoldOut', holdoutRatio);
        trainInds = training(cv);
        testInds = test(cv);
    elseif strcmp(validationType, 'kfold')
        % Validación k-Fold
        numFolds = 5; % Valor por defecto
        if ~isempty(varargin)
            numFolds = varargin{1};
        end
        cv = cvpartition(labels, 'KFold', numFolds);
    else
        error('Tipo de validación no soportado. Use ''holdout'' o ''kfold''.');
    end

    % Inicializar variables de resultados
    accuracies = []; % Para almacenar las precisiones si usamos k-fold

    % Validación
    if strcmp(validationType, 'holdout')
        % Partición hold-out
        trainingData = features(trainInds, :);
        testData = features(testInds, :);
        trainingLabels = labels(trainInds);
        testLabels = labels(testInds);

        % Clasificación
        [predictedLabels, ~, ~, ~, coeff] = classify(testData, trainingData, trainingLabels);

        % Calcular precisión
        accuracy = sum(predictedLabels == testLabels) / numel(testLabels);
        fprintf('Hold-Out Accuracy: %.3f%%\n', accuracy * 100);

    elseif strcmp(validationType, 'kfold')
        % Partición k-fold
        for fold = 1:cv.NumTestSets
            trainInds = training(cv, fold);
            testInds = test(cv, fold);

            trainingData = features(trainInds, :);
            testData = features(testInds, :);
            trainingLabels = labels(trainInds);
            testLabels = labels(testInds);

            % Clasificación
            [predictedLabels, ~, ~, ~, coeff] = classify(testData, trainingData, trainingLabels);

            % Calcular precisión para este fold
            foldAccuracy = sum(predictedLabels == testLabels) / numel(testLabels);
            accuracies = [accuracies; foldAccuracy];
        end

        % Mostrar resultados promedio
        fprintf('k-Fold Accuracy (k=%d): %.3f%%\n', cv.NumTestSets, mean(accuracies) * 100);
    end

    % Gráfica de dispersión y límites de decisión (para 2D)
    if size(features, 2) == 2
        figure;
        gscatter(features(:, 1), features(:, 2), labels, lines(numel(unique(labels))));
        xlabel('Feature 1');
        ylabel('Feature 2');
        title(sprintf('Scatter Plot with %s Validation', validationType));
        grid on
        hold on;

        % Límites de decisión
        classes = unique(labels);
        nClasses = numel(classes);
        for i = 1:nClasses
            for j = i+1:nClasses
                K = coeff(i, j).const;
                L = coeff(i, j).linear;
                f = @(x1, x2) K + L(1) * x1 + L(2) * x2;
                hBoundary = fimplicit(f, [min(features(:, 1)), max(features(:, 1)), ...
                                          min(features(:, 2)), max(features(:, 2))]);
                hBoundary.DisplayName = sprintf('Boundary between %d & %d', classes(i), classes(j));
            end
        end
        legend('Location', 'best');
        hold off;
    else
        disp('Nota: Las gráficas de límites de decisión están disponibles solo para datos de 2 dimensiones.');
    end
end
