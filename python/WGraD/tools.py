#!/usr/bin/env python
# coding=utf-8
'''
Author       : Li Yuhao
Date         : 2023-11-29 17:52:01
LastEditTime : 2023-12-02 15:23:57
LastEditors  : your name
Description  : 
FilePath     : \\WGraD\\python\\WGraD\\tools.py
'''

from collections import defaultdict
from typing import Dict, List, Tuple

import numpy as np


def dfs(idx: int, graph: List[List[int]], viewed: set, path: set):
    '''
    description: deep first search
    param [int] idx: the index of the current node
    param [List] graph: directed graph
    param [set] viewed: viewed node index
    param [set] path: current node index
    return [*]
    '''
    if idx in viewed:
        return 
    
    path.add(idx)
    viewed.add(idx)
    for nei in graph[idx]:
        dfs(nei, graph, viewed, path)
    return


def hill_valley_test(
        found_optima: List[np.ndarray], 
        fit_found_optima: List[np.float_], 
        ind_to_test: np.ndarray, 
        fit_ind_to_test: np.float_, 
        fes: int, 
        fitness_func
    ):
    '''
    description: 
    param [np] _found_optima
    param [np] ind_to_test
    param [int] fes
    param [*] fitness_func
    return [*]
    '''
    found_new_hill = False
    num_test = 5
    # find the nearest solution
    if found_optima == []:
        return True, fes
    _found_optima = np.array(found_optima)
    distance = np.linalg.norm(_found_optima - ind_to_test, axis=1)
    nearest_index = np.argmin(distance)
    nearest_ind = _found_optima[nearest_index, :]
    fit_nearest_ind = fit_found_optima[nearest_index]

    # obtain unit vector: the new solution -> the nearest solution
    unit_v = (nearest_ind - ind_to_test) / distance[nearest_index]
    
    if np.isnan(unit_v).any():
        return found_new_hill, fes  # the new solution == the nearest solution

    num = ((distance[nearest_index] / (num_test + 1)) * np.arange(1, num_test + 1)).reshape(num_test, -1)
    test = np.tile(ind_to_test, (num_test, 1)) + num * unit_v
        # (((distance[nearest_index] / num_test) * num)[:, np.newaxis]) * unit_v

    # Hill-Valley Test
    fit_test = np.zeros(num_test)
    for i in range(num_test):
        fes += 1
        fit_test[i] = fitness_func(test[i, :])  # assuming you have a fitness function defined
        if fit_test[i] < min(fit_nearest_ind, fit_ind_to_test):
            # offspring and Best are in different hills
            found_new_hill = True
            break

    # if new solution and it's nearest solution are in the same hill 
    # and new solution is better than the nearest solution
    if found_new_hill == False and fit_ind_to_test > fit_nearest_ind:
            found_optima[nearest_index] = ind_to_test
            fit_found_optima[nearest_index] = fit_ind_to_test

    return found_new_hill, fes


def check_all_solution(_found_optima: np.ndarray, fit__found_optima: np.ndarray, accuracy: float = 0.1):
    solution = _found_optima.copy()

    if len(fit__found_optima) > 1:
        MaxFit = np.max(fit__found_optima)
        index = np.where(MaxFit - fit__found_optima < accuracy)[0]
        
        # 删除所有低于 MaxFit - accuracy 的解
        _found_optima = _found_optima[index, :]
        fit__found_optima = fit__found_optima[index]

    return solution, fit__found_optima


def map_min_max(x: np.ndarray):
    x = (x - np.nanmin(x, axis = 1, keepdims = 1)) / (np.nanmax(x, 1, keepdims = 1) - np.nanmin(x, 1, keepdims = 1))
    return x


def test_fitness(x: np.ndarray):
    """
    test fitness funciton:
        y_i = sum_j {(x_ij ** 3)}, for all i in {1, 2, ..., n}
    input
        x: samples
    output
        y: [y_1, y_2, ..., y_m]
    """
    return np.sum(np.power(x, 3), 1)