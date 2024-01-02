#!/usr/bin/env python
# coding=utf-8
'''
Author       : Li Yuhao
Date         : 2023-12-01 09:38:30
LastEditTime : 2023-12-02 19:52:02
LastEditors  : your name
Description  : 
FilePath     : \\WGraD\\python\\test_cec2013.py
'''
#!/usr/bin/env python
# coding=utf-8


from pathlib import Path
from typing import List

import numpy as np

import sys

THIS_File = Path(__file__)
TEST_WORKSPACE = THIS_File.parent

sys.path.append(TEST_WORKSPACE)

from fitness.cec2013.cec2013.cec2013 import *

from optimizer.differential_evolution import DifferentialEvolution

from WGraD import WGraD

from WGraD.tools import filter_similar_optima

def get_sample(bounds: np.ndarray, num_sample: int):
    lb_bound, ub_bound = bounds
    dimension = len(lb_bound)
    _pop = np.random.rand(num_sample, dimension)
    _pop = lb_bound + (ub_bound - lb_bound) * _pop
    return _pop


def cec2013_test(func_id, random_seed):
    np.random.seed(random_seed)
    fes = 0
    
    
    # Create function
    f = CEC2013(func_id)

    # parameter 
    dimension = f.get_dimension()
    lb_bounds = f.get_lbound(dimension - 1)
    ub_bounds = f.get_ubound(dimension - 1)
    bounds = np.array(
        [
            [lb_bounds] * dimension, 
            [ub_bounds] * dimension
        ]
    )

    found_optima: List[np.ndarray] = []
    fit_found_optima: List[np.float_] = []

    end_condition_list = []
    count = 0
    while fes < f.get_maxfes():
        # calculate the num of samples
        num_sample = 500 * f.get_dimension()
        # sample and calculate fitness
        init_pop = get_sample(bounds, num_sample)
        init_fitness = np.zeros((num_sample, 1))
        for i in range(len(init_pop)):
            init_fitness[i] = f.evaluate(init_pop[i, :])
        fes += num_sample
        # apply cluster method
        wgrad = WGraD(init_pop, init_fitness, f.evaluate)
        cluster_info = wgrad.WGrad_2()
        # optimize
        for cluster in cluster_info:
            count += 1
            # instance optimizer
            de = DifferentialEvolution(
                init_pop = cluster.X,
                init_fitness = cluster.fitness,
                fitness_func = f.evaluate,
                bounds = bounds,
                max_fes = f.get_maxfes() - fes,
                pop_size = 50 if dimension in [10, 20] else 20,
                F = 0.5,
                CR = 0.5,
                mutation_strategy = 2,
                cross_strategy = 1
            )

            _, _, end_condition = de.maximize(
                dis_tolerance = 10 ** -10,
                stop_generation = 50,
                impro_tolerance = 10 ** -5,
                tolerance_gp = 10 ** -7
            )
            end_condition_list.append(end_condition)
            # update fitness evaluation times
            fes += de.fes
            # check if new optimum found
            found_new_hill, fes = filter_similar_optima(
                found_optima=found_optima,
                fit_found_optima = fit_found_optima,
                ind_to_test = de.best_x,
                fit_ind_to_test = de.best_fitness,
                fes = fes,
                fitness_func = f.evaluate
            )
            # found_optima.append(de.best_x)
            # fit_found_optima.append(de.best_fitness)
            if found_new_hill:
                found_optima.append(de.best_x)
                fit_found_optima.append(de.best_fitness)
    final_optima = []
    fit_final_optima = []
    for _optimum, _fitness in zip(found_optima, fit_found_optima):
        if _fitness + 0.1 >= max(fit_found_optima):
            final_optima.append(_optimum)
            fit_final_optima.append(_fitness)

    print(count)
    # check how many global optima found using how_many_goptima function
    recall = [0] * 5
    percision = [0] * 5
    for i, accuracy in enumerate([0.1, 0.01, 0.001, 0.0001, 0.00001]):
        count, _ = how_many_goptima(
            pop=np.array(found_optima),
            f=f,
            accuracy=accuracy
        )
        recall[i] = count / f.get_no_goptima()
        percision[i] = count / len(found_optima)
    print(f"f: {func_id}, rep: {random_seed}, {recall}, {percision}")
    
    
    return


def main():
    for func_id in range(1, 21):
        for rep in range(1, 2):
            cec2013_test(func_id, rep)

if __name__ == "__main__":
    main()