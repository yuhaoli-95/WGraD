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
    description: deep first search for traversing a graph
    param [int] idx: the index of the current node
    param [List] graph: directed graph represented as an adjacency list
    param [set] viewed: set of viewed node indices
    param [set] path: set of indices representing the current path
    return [*]
    '''
    if idx in viewed:
        return 
    
    path.add(idx)
    viewed.add(idx)
    for nei in graph[idx]:
        dfs(nei, graph, viewed, path)
    return

def sampling_between_two_points(
        point_A: np.ndarray,
        point_B: np.ndarray,
        num_samples: int,
    ):
    '''
    description: generates samples between two points in a linear manner
    param [np.ndarray] point_A: starting point
    param [np.ndarray] point_B: ending point
    param [int] num_samples: number of samples to generate
    return [np.ndarray]: array of generated samples
    '''
    # obtain unit vector: the new solution -> the nearest solution
    distance = np.linalg.norm(point_A - point_B, axis=0)
    unit_v = (point_B - point_A) / distance

    num = ((distance / (num_samples + 1)) * np.arange(1, num_samples + 1)).reshape(num_samples, -1)
    test_point = np.tile(point_A, (num_samples, 1)) + num * unit_v

    return test_point

def hill_valley_test(
        point_A: Tuple[np.ndarray, np.float_],
        point_B: Tuple[np.ndarray, np.float_],
        num_samples: int,
        fitness_func,
    ):
    '''
    description: perform Hill-Valley Test between two points to check if they belong to the same hill
    param [Tuple[np.ndarray, np.float_]] point_A: first point with fitness value
    param [Tuple[np.ndarray, np.float_]] point_B: second point with fitness value
    param [int] num_samples: number of samples to generate for the test
    param [*] fitness_func: fitness function
    return [bool, List[Tuple[np.ndarray, np.float_]]]: 
            - True if points are in different hills, False otherwise
            - List of test samples with fitness values
    '''
    found_new_hill = False
    test = sampling_between_two_points(point_A[0], point_B[0], num_samples)
    
    # Hill-Valley Test
    fes = 0
    fit_test = np.zeros(num_samples)
    for i in range(num_samples):
        fes += 1
        fit_test[i] = fitness_func(test[i, :])  # assuming you have a fitness function defined
        if fit_test[i] < min(point_A[1], point_B[1]):
            # offspring and Best are in different hills
            found_new_hill = True
            break

    return found_new_hill, [(test[i, :], fit_test[i]) for i in range(fes)]

def filter_similar_optima(
        found_optima: List[np.ndarray], 
        fit_found_optima: List[np.float_], 
        ind_to_test: np.ndarray, 
        fit_ind_to_test: np.float_, 
        fes: int, 
        fitness_func
    ):
    '''
    description: Filter similar optima and update the list of found optima
    param [List[np.ndarray]] found_optima: list of found optima
    param [List[np.float_]] fit_found_optima: list of fitness values corresponding to found optima
    param [np.ndarray] ind_to_test: new solution to test
    param [np.float_] fit_ind_to_test: fitness value of the new solution
    param [int] fes: current function evaluations count
    param [*] fitness_func: fitness function
    return [bool, int]: 
            - True if the new solution belongs to a different hill, False otherwise
            - Updated function evaluations count
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
    
    test_2 = sampling_between_two_points(ind_to_test, nearest_ind, num_test)

    assert sum(sum(test - test_2)) == 0

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
    '''
    description: Check all solutions and remove duplicates within a specified accuracy
    param [np.ndarray] _found_optima: array of found optima
    param [np.ndarray] fit__found_optima: array of fitness values corresponding to found optima
    param [float] accuracy: allowable accuracy for considering solutions as duplicates
    return [Tuple[np.ndarray, np.ndarray]]: Tuple containing filtered solutions and fitness values
    '''
    solution = _found_optima.copy()

    if len(fit__found_optima) > 1:
        MaxFit = np.max(fit__found_optima)
        index = np.where(MaxFit - fit__found_optima < accuracy)[0]
        
        # 删除所有低于 MaxFit - accuracy 的解
        _found_optima = _found_optima[index, :]
        fit__found_optima = fit__found_optima[index]

    return solution, fit__found_optima


def map_min_max_by_row(x: np.ndarray):
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