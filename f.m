function result = f(x, D)
    % Dividir en etiquetas y features
    labels = D(:,end);
    features = D(:,1:end-1);

    % Hallar el punto de corte del vector
    n=size(x,2)/2;

    % crear las columnas de la matriz
    column1 = x(1:n)';
    column2 = x(n+1:end)';

    % Crear la transformación
    matrix = [column1 column2];

    % Proyectar los datos
    projected_features = features * matrix;
    
    % Calcular la función utilizando las etiquetas
    sValues = silhouette(projected_features, labels);

    % El resultado se pone negativo para minimizar
    result = -mean(sValues);
end