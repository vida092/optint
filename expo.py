import numpy as np
import matplotlib.pyplot as plt
import networkx as nx
import random

# Configuración base del problema
num_clients = 6
vehicle_capacity = 15
client_demands = np.array([3, 4, 5, 6, 2, 3])
coordinates = np.array([
    [0, 0],  # Depósito
    [2, 3], [5, 1], [6, 4], [8, 7], [1, 8], [3, 6]  # clientes
])

# distancia euclidiana usual
def distance(a, b):
    return np.linalg.norm(a - b)

# matriz de distancias
num_nodes = len(coordinates)
distance_matrix = np.zeros((num_nodes, num_nodes))
for i in range(num_nodes):
    for j in range(num_nodes):
        distance_matrix[i, j] = distance(coordinates[i], coordinates[j])

# Heurísticas de bajo nivel
def greedy_construction():
    # greedy: asigna clientes a rutas minimizando la distancia
    route = [0]
    remaining = list(range(1, num_nodes))
    while remaining:
        last_node = route[-1]
        next_node = min(remaining, key=lambda x: distance_matrix[last_node, x])
        route.append(next_node)
        remaining.remove(next_node)
    route.append(0)  # s regresa al depósito
    return route

def shift(route):
    if len(route) < 3:
        return route  
    i = random.randint(1, len(route) - 2)
    node = route.pop(i)
    j = random.randint(1, len(route) - 1)
    route.insert(j, node)
    return route

def swap(route):
    if len(route) < 3:
        return route  
    i, j = random.sample(range(1, len(route) - 1), 2)
    route[i], route[j] = route[j], route[i]
    return route

# Evaluación de la solución
def evaluate(route):
    cost = 0
    for i in range(len(route) - 1):
        cost += distance_matrix[route[i], route[i + 1]]
    return cost

####################################################################
#  Hipereurística con heurísticas constructivas y perturbativas ####
####################################################################
# Construcción inicial heuristica constructiva
current_route = greedy_construction()
best_route = current_route[:]
best_cost = evaluate(best_route)

history = [best_cost]

for iteration in range(100):
    new_route = current_route[:]

    # Alternar entre heurísticas constructivas y perturbativas
    if iteration % 10 == 0:
        # Cada 10 iteraciones, reinicializar con heurística constructiva
        new_route = greedy_construction()
    else:
        # Aplicar heurística perturbativa
        heuristic = random.choice([swap, shift])
        new_route = heuristic(new_route)

    new_cost = evaluate(new_route)

    if new_cost < best_cost:  # se queda con la mejor
        best_route = new_route[:]
        best_cost = new_cost

    current_route = new_route[:]
    history.append(best_cost)

# nodos visitados
G = nx.Graph()
for i in range(num_nodes):
    G.add_node(i, pos=coordinates[i])
for i in range(len(best_route) - 1):
    G.add_edge(best_route[i], best_route[i + 1])

pos = nx.get_node_attributes(G, 'pos')

plt.figure(figsize=(10, 6))
nx.draw(G, pos, with_labels=True, node_color='lightblue', node_size=500, font_size=10)
plt.title('Ruta Optimizada con Hipereurística Mixta')
plt.show()

# grafica de convergencia
plt.figure(figsize=(10, 6))
plt.plot(history, marker='o')
plt.title('Convergencia de la Hipereurística Mixta')
plt.xlabel('Iteración')
plt.ylabel('Costo de la Ruta')
plt.grid()
plt.show()
