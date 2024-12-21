function scatterByLabel(data, cols)
    % scatterByLabel - Realiza un scatter plot 3D por etiquetas con colores sólidos
    % 
    % data: matriz de datos (última columna son las etiquetas)
    % cols: vector de tres enteros que indica las columnas a usar en el plot
    %
    % Ejemplo de uso:
    % scatterByLabel(data, [1, 2, 3])

    % Validar que las columnas tienen 3 elementos
    if length(cols) ~= 3
        error('Se deben especificar exactamente 3 columnas.');
    end

    % Validar que las columnas están dentro del rango de la matriz
    if max(cols) > size(data, 2) - 1 || min(cols) < 1
        error('Las columnas especificadas deben estar dentro del rango de la matriz (excepto la última columna).');
    end

    % Extraer etiquetas (última columna)
    labels = data(:, end);

    % Obtener etiquetas únicas
    unique_labels = unique(labels);

    % Definir colores sólidos predefinidos
    colors = lines(length(unique_labels)); % Genera colores sólidos distintos

    % Crear scatter plot
    figure;
    hold on;
    for i = 1:length(unique_labels)
        % Filtrar datos por etiqueta
        current_label = unique_labels(i);
        label_data = data(labels == current_label, :);

        % Scatter plot para la etiqueta actual
        scatter3(label_data(:, cols(1)), label_data(:, cols(2)), label_data(:, cols(3)), ...
                 50, colors(i, :), 'filled', 'DisplayName', ['clase ' num2str(current_label)]);
    end

    % Configurar la gráfica
    xlabel(['Columna ' num2str(cols(1))]);
    ylabel(['Columna ' num2str(cols(2))]);
    zlabel(['Columna ' num2str(cols(3))]);

    legend;
    grid on;
    title('Scatter plot ');
    hold off;
end
