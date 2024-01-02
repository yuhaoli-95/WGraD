#!/usr/bin/env python
# coding=utf-8
'''
Author       : Li Yuhao
Date         : 2023-11-29 15:43:08
LastEditTime : 2023-12-03 22:36:44
LastEditors  : your name
Description  : 
FilePath     : \\WGraD\\python\\WGraD\\WGraD.py
'''

import numpy as np

from scipy.spatial.distance import pdist, squareform

from types import FunctionType, MethodType
from typing import Union

try:
    from .tools import *
    from .ClusterResult import ClusterResult
except:
    from tools import *
    from ClusterResult import ClusterResult



class WGraD:
    def __init__(self, samples: np.ndarray, fitness: np.ndarray, fitness_func: Union[FunctionType, MethodType]) -> None:
        self._samples = samples
        self._num_samples = len(samples)
        self._num_dimension = len(samples[0])
        self._fitness = fitness.reshape(self._num_samples, 1)
        self._parents = list(range(self._num_dimension))
        self._dist = self.cal_distance()
        self._grad = self.cal_gradient()
        assert type(fitness_func) in [MethodType, FunctionType]
        self._fitness_func = fitness_func

        self._node_to_parent: Dict[int, int] = defaultdict(lambda: None)
        self._idx_to_sample: Dict[int, np.ndarray] = {
            i: samples[i, :]
            for i in range(len(samples))
        }
        return 
    
    def cal_distance(self, method = "Euclidean"): 
        """
        calculate distance among given points
        """
        if method == "Euclidean":
            dist = squareform(pdist(self._samples))
        else:
            raise ValueError(f"Unknown distance method! - {method}")
        mask = np.eye(self._num_samples, dtype=bool)
        dist[mask] = np.nan
        return dist
        
    
    def cal_gradient(self) -> np.ndarray:
        '''
        description: calculate gradient between two points
        return [np.ndarray] grad: gradient between two points
                    grad[i][j]: (fitness[j] - fitness[i]) / |distance between i and j|
                    so grad[i]: the gradient between [p1, p2, ..., pn] and pi
        '''
        # delta_fitness[i][j]: fitness[j] - fitness[i]
        delta_fitness = self._fitness.T - self._fitness
        # grad[i][j]: (fitness[j] - fitness[i]) / |distance between i and j|
        grad = delta_fitness / self._dist
        return grad
    
    def _get_graph(self, method: str, w_dist: float = None):
        '''
        description: Get the directed graph based on the specified method and weight
        param [str] method: method for creating the graph ("WGrad_1" or "WGrad_2")
        param [float] w_dist: weight for the distance item in the score calculation
        return [List[set]]: directed graph represented as an adjacency list
        '''
        normalized_grad = map_min_max_by_row(self._grad)
        normalized_dist = map_min_max_by_row(self._dist)
        directed_graph = [set() for _ in range(self._num_samples)]
        for idx, point_i in enumerate(self._samples):
            # gradient item
            grad_i = normalized_grad[idx].reshape(-1)
            # distance item
            dist_i = normalized_dist[idx].reshape(-1)
            if method == "WGrad_2":
                # calculate the weight of distance item
                w_dist = normalized_dist[idx].reshape(-1)
            else:
                assert 0 <= w_dist <= 1
            # calculate the weight of gradient item
            w_grad = 1 - w_dist
            # calculate score 
            score = w_grad * grad_i - w_dist * dist_i
            # find the best one
            best_idx = np.nanargmax(score)
            self._node_to_parent[idx] = best_idx
            directed_graph[idx].add(best_idx)
            directed_graph[best_idx].add(idx)
        return directed_graph

    def _get_clusters(self, directed_graph: List[set]):
        '''
        description: Get clusters using Depth First Search on the directed graph
        param [List[set]] directed_graph: directed graph represented as an adjacency list
        return [List[ClusterResult]]: list of cluster results
        '''
        # get clusters using dfs
        viewed = set([])
        cluster_info = []
        for i in range(self._num_samples):
            path = set([])
            dfs(i, directed_graph, viewed, path)
            # a new cluster found
            path = list(path)
            tmp_edges = [
                (self._idx_to_sample[node], self._idx_to_sample[self._node_to_parent[node]])
                for node in path
            ]
            cluster_result = ClusterResult(
                X = self._samples[path],
                fitness = self._fitness[path],
                indices = path,
                node_to_parent = self._node_to_parent.copy(),
                edges = tmp_edges,
                num_dimension = self._num_dimension
            )
            cluster_info.append(cluster_result)

        return cluster_info
    
    def check_broken_edges(self, cur_clusters: List[ClusterResult], pre_clusters: List[ClusterResult], directed_graph: List[set[int]]):
        '''
        description: Check and repair broken edges between clusters
        param [List[ClusterResult]] cur_clusters: current list of clusters
        param [List[ClusterResult]] pre_clusters: previous list of clusters
        param [List[set[int]]] directed_graph: directed graph represented as an adjacency list
        return [List[set[int]], List[Tuple[np.ndarray, np.float_]]]: updated directed graph and insert samples
        '''
        insert_sample: List[Tuple[np.ndarray, np.float_]] = []
        # cur_node_to_parent = self._node_to_parent.copy()
        pre_node_to_parent = {i: j for pre_cst in pre_clusters for i, j in pre_cst.node_to_parent.items()}

        num_samples = 3

        for cluster in cur_clusters:
            for i in cluster.indices:
                # get point i
                point_i = self._samples[i, :]
                # get pre parent of point i
                pre_j = pre_node_to_parent[i]
                if pre_j in cluster.indices:
                    continue

                point_pre_j = self._samples[pre_j]
                # in two different clusters
                # sample between i and pre_parent_i
                # 
                found_new_hill, _insert_sample = hill_valley_test(
                    point_A = (point_i, self._fitness[i]), 
                    point_B = (point_pre_j, self._fitness[pre_j]), 
                    num_samples = num_samples, 
                    fitness_func=self._fitness_func
                )
                insert_sample.extend(_insert_sample)

                if found_new_hill == False:
                    directed_graph[i].add(pre_j)
                    directed_graph[pre_j].add(i)
        return directed_graph, insert_sample

    def WGrad_1(self) -> List[ClusterResult]:
        weight_to_clusters: Dict[float, List[ClusterResult]] = {}
        weight_to_insert_sample: Dict[float, List[Tuple[np.ndarray, np.float_]]] = defaultdict(lambda: [])
        weight_list = np.array(range(0, 11, 1)) / 10
        for i, weight in enumerate(weight_list):
            directed_graph = self._get_graph("WGrad_1", weight)
            cluster_result = self._get_clusters(directed_graph)
            weight_to_clusters[weight] = cluster_result
            # 
            if i == 0:
                continue
            pre_clusters = weight_to_clusters[weight_list[i - 1]]
            # find more clusters
            if len(cluster_result) == len(pre_clusters):
                continue
            # check broken edges
            directed_graph, insert_sample = self.check_broken_edges(
                cur_clusters = cluster_result,
                pre_clusters = pre_clusters,
                directed_graph = directed_graph
            )
            weight_to_insert_sample[weight] = insert_sample
            cluster_result = self._get_clusters(directed_graph)
            # update result
            weight_to_clusters[weight] = cluster_result

        return weight_to_clusters[weight]
    
    def WGrad_2(self) -> List[ClusterResult]:
        """
        
        """
        directed_graph = self._get_graph("WGrad_2")
        cluster_result = self._get_clusters(directed_graph)
        return cluster_result
    

    


if __name__ == "__main__":
    # Create function
    __f = test_fitness

    # Create position vectors
    np.random.seed(2023)
    # __x = np.random.random((500, 1)) * 200 - 100

    __x = np.linspace(-100, 100, 100).reshape(100, 1)


    # Evaluate :-)
    __fitness = __f(__x)

    wgrad = WGraD(__x, __fitness, test_fitness)

    wgrad.WGrad_2()