clc
clear
database = "ionospherec";
D = readmatrix(database+".csv");
features = D(:, 3:end-1);
labels = D(:, end);
D=[features labels];
[m, nl] = size(D);

n = nl - 1;


scatterByLabel(D, [4 2 3])
sValues = silhouette(features, labels);
result = -mean(sValues);

disp("silueta original")
disp(result)

LDA = readmatrix("LDA_" + database);

sValues = silhouette(LDA(:,1:end-1), LDA(:,end));
result = -mean(sValues);

disp("silueta de LDA")
disp(result)


f_handle = @(x) f(x, D);
x0 = rand(1, 2 * n);

tic
[x_opt, f_val] = powell_method_repaired(f_handle, x0, 1e-8, 50);
toc
disp("mejor valor")
disp(f_val)
scatter_plot_2d(x_opt,D, "Mejor resultado")



column1 = x_opt(1:n)';
column2 = x_opt(n+1:end)';
mat = [column1 column2];
projected = features * mat;
projected_labels = [projected labels];


writematrix( projected_labels, database+"_projected.csv")
runClassification(database+"_projected.csv", "holdout")

runClassification("LDA_" + database, "holdout")
