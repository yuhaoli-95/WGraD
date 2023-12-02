#!/usr/bin/env python
# coding=utf-8
'''
Author       : Li Yuhao
Date         : 2023-11-29 15:43:08
LastEditTime : 2023-11-30 15:22:14
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
except:
    from tools import *

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
    
    def WGraD_1(self):
        
        return
    
    def WGrad_2(self):
        """
        
        """
        normalized_grad = map_min_max(self._grad)
        normalized_dist = map_min_max(self._dist)
        graph = [set() for _ in range(self._num_samples)]
        for idx, point_i in enumerate(self._samples):
            # gradient item
            grad_i = normalized_grad[idx].reshape(-1)
            # distance item
            dist_i = normalized_dist[idx].reshape(-1)
            # calculate the weight of distance item
            w_dist = normalized_dist[idx].reshape(-1)
            # calculate the weight of gradient item
            w_grad = 1 - w_dist
            # calculate score 
            score = w_grad * grad_i - w_dist * dist_i
            # find the best one
            best_idx = np.nanargmax(score)
            graph[idx].add(best_idx)
            graph[best_idx].add(idx)
        # get clusters using dfs
        viewed = set([])
        cluster_info = []
        for i in range(self._num_samples):
            path = set([])
            dfs(i, graph, viewed, path)
            # a new cluster found
            if len(path) > 0:
                cluster_info.append(list(path))

        return cluster_info
    

    


if __name__ == "__main__":
    # Create function
    __f = test_fitness

    # Create position vectors
    np.random.seed(2023)
    # __x = np.random.random((500, 1)) * 200 - 100

    __x = np.linspace(-10, 10, 100).reshape(100, 1)


    # Evaluate :-)
    __fitness = __f(__x)

    wgrad = WGraD(__x, __fitness, test_fitness)

    wgrad.WGrad_2()