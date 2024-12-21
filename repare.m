function repared = repare(x)
    n = length(x) / 2;
    v1 = x(1:n);       
    v2 = x(n+1:end);   
    
    % Crear una matriz con dos columnas (como filas)
    mat = [v1; v2]'; 

    % Normalizar la primera columna
    q1 = mat(:, 1) / norm(mat(:, 1));
    
    % Hacer ortogonal la segunda columna respecto a la primera
    proj = dot(mat(:, 2), q1) * q1; 
    q2 = mat(:, 2) - proj;
    
    q2 = q2 / norm(q2);
    
    % Concatenar las columnas y devolver como vector fila
    repared = [q1; q2]'; 
    repared = repared(:)';
end
