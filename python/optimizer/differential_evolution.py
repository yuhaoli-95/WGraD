#!/usr/bin/env python
# coding=utf-8
'''
Author       : Li Yuhao
Date         : 2023-11-30 15:23:15
LastEditTime : 2023-12-02 11:35:24
LastEditors  : your name
Description  : 
FilePath     : \\WGraD\\python\\optimizer\\differential_evolution.py
'''
from typing import List, Tuple
import numpy as np
from types import FunctionType, MethodType
from scipy.spatial.distance import pdist, squareform

from numpy.random import rand, randint

from sklearn.gaussian_process import GaussianProcessRegressor
from sklearn.gaussian_process.kernels import ConstantKernel, RBF

import warnings
warnings.filterwarnings("ignore")

class DifferentialEvolution:
    def __init__(
            self,
            init_pop: np.ndarray,
            init_fitness: np.ndarray,
            fitness_func: MethodType,
            bounds: List[Tuple[float, float]], # [[min, max]]
            max_fes: int,
            pop_size: int = 80,
            F: float = 0.5, 
            CR: float = 0.5, 
            mutation_strategy: int = 2,
            cross_strategy: int = 1,
        ) -> None:
        dimension = len(init_pop[0])
        bounds = np.array(bounds).reshape(2, dimension)
        self.max_fes = max_fes
        self.pop_size = pop_size
        self.fes = 0
        self.dimension = dimension
        self.bounds = bounds
        self.F = F
        self.CR = CR
        self.mutation_strategy = mutation_strategy
        self.cross_strategy = cross_strategy
        self._fitness_func = fitness_func

        self.best_indi_list: List[np.ndarray] = []
        self.best_fit_list: List[float] = []

        
        if len(init_pop) >= pop_size:
            # randomly take "pop_size" individuals from "init_pop"
            _pop = np.concatenate([init_pop, init_fitness], axis=1)
            np.random.shuffle(_pop)
            init_pop = _pop[:pop_size, : dimension]
            init_fitness = _pop[:pop_size, -1].reshape((pop_size, -1))
        else:
            # sample new "pop_size - len(init_pop)" individuals
            _pop = np.random.rand(pop_size - len(init_pop), dimension)
            _pop = bounds[0] + (bounds[1] - bounds[0]) * _pop
            _fit = np.zeros((len(_pop), 1))
            for i in range(len(_pop)):
                _fit[i] = self.fitness_func(_pop[i])
            init_pop = np.concatenate([init_pop, _pop], axis=0)
            init_fitness = np.concatenate([init_fitness, _fit], axis=0)


        self.pop = init_pop
        self.fitness = init_fitness

        self.best_x = np.zeros_like(self.pop[0])
        self.best_fitness = np.zeros(1)
        return
    
    @property
    def fitness_func(self):
        self.fes += 1
        return self._fitness_func
    
    def maximize(
            self, 
            dis_tolerance: 10 ** -10, 
            stop_generation = 50, 
            impro_tolerance = 10 ** -5, 
            tolerance_gp = 10 ** -7,
            randseed = 2023,
        ):  
        np.random.seed(randseed)
        end_condition = 0
        #--- SOLVE --------------------------------------------+    
        X = self.pop
        fit_X = self.fitness
        fit_improv_list: List[float] = []
        pre_best_fit = np.max(self.fitness)

        self.best_x = X[np.argmax(fit_X)]
        self.best_fitness = np.max(fit_X)
        while self.fes < self.max_fes:
            best_X = X[np.argmax(fit_X)]

            # step2: mutation
            M = self.mutation(X, best_X)

            # step2.2: crossover
            U = self.crossover(X, M)

            # step3: check border of offspring U
            U = self.cross_border_inspect(U)
            
            # # check stop condition 3
            # is_terminate = self.gp_end_condition(
            #     impro_tolerance = impro_tolerance,
            #     tolerance_gp = tolerance_gp,
            #     fit_improv_list = fit_improv_list,
            #     X = X,
            #     fitnessX = fit_X,
            #     U = U
            #     )
            # if is_terminate:
            #     end_condition = 3
            #     break

            # step4: selection
            offspring, fitness_off, _, _ = self.selection(X, U, fit_X)


            X = offspring
            fit_X = fitness_off

            # fitness improvement
            best_fit = np.max(fit_X)
            fit_improv_list.append(best_fit - pre_best_fit)
            pre_best_fit = best_fit

            # record best indi
            best_X = X[np.argmax(fit_X)]

            # update attribute
            self.best_x = best_X
            self.best_fitness = best_fit
            self.best_indi_list.append(best_X)
            self.best_fit_list.append(best_fit)
            
            # check stop condition 1
            distance_X = squareform(pdist(X))
            if np.max(distance_X.reshape(-1)) < dis_tolerance:
                end_condition = 1
                break
            # check stop condition 2
            if len(fit_improv_list) > stop_generation and \
                all(item < impro_tolerance for item in fit_improv_list[-stop_generation : ]):
                end_condition = 2
                break

        return X, fit_X, end_condition
    

    def mutation(self, X: np.ndarray, bestX: np.ndarray):
        F = self.F
        mutation_strategy = self.mutation_strategy
        pop_size = self.pop_size
        V = np.zeros_like(X)

        for i in range(pop_size):
            nrandI = 5
            r = randint(1, pop_size + 1, size=nrandI)

            if mutation_strategy == 1:
                # mutationStrategy=1: DE/rand/1
                V[i, :] = X[r[0] - 1, :] + F * (X[r[1] - 1, :] - X[r[2] - 1, :])
            elif mutation_strategy == 2:
                # mutationStrategy=2: DE/best/1
                V[i, :] = bestX + F * (X[r[0] - 1, :] - X[r[1] - 1, :])
            elif mutation_strategy == 3:
                # mutationStrategy=3: DE/rand-to-best/1
                V[i, :] = X[i, :] + F * (bestX - X[i, :]) + F * (X[r[0] - 1, :] - X[r[1] - 1, :])
            elif mutation_strategy == 4:
                # mutationStrategy=4: DE/best/2
                V[i, :] = bestX + F * (X[r[0] - 1, :] - X[r[1] - 1, :]) + F * (X[r[2] - 1, :] - X[r[3] - 1, :])
            elif mutation_strategy == 5:
                # mutationStrategy=5: DE/rand/2
                V[i, :] = X[r[0] - 1, :] + F * (X[r[1] - 1, :] - X[r[2] - 1, :]) + F * (X[r[3] - 1, :] - X[r[4] - 1, :])
            else:
                raise ValueError('Invalid mutation strategy')

        return V


    def crossover(self, P: np.ndarray, M: np.ndarray):
        CR = self.CR
        cross_strategy = self.cross_strategy
        pop_size, Dim = P.shape
        S = np.zeros_like(P)

        for i in range(pop_size):
            j_rand = randint(0, Dim)

            if cross_strategy == 1:
                # crossStrategy=1: binomial crossover
                for j in range(Dim):
                    a = rand()
                    if a < CR or j == j_rand:
                        S[i, j] = M[i, j]
                    else:
                        S[i, j] = P[i, j]

            # elif cross_strategy == 2:
            #     # crossStrategy=2: Exponential crossover
            #     j = randint(0, Dim)
            #     S[i] = P[i]
            #     S[i, j] = M[i, j]
            #     j = (j + 1) % Dim
            #     L = 1
            #     for dim_index in range(Dim):
            #         if rand() > CR:
            #             break
            #         j = (j + 1) % Dim
            #         S[i, j] = M[i, j]

            # elif cross_strategy == 3:
            #     # crossStrategy=3: one point crossover
            #     j_rand = randint(0, Dim)
            #     for j in range(Dim):
            #         S[i, :] = np.concatenate((M[i, :j_rand], P[i, j_rand:]))
            #         if j <= j_rand:
            #             S[i, j] = M[i, j]
            #         else:
            #             S[i, j] = P[i, j]

            # elif cross_strategy == 4:
            #     # crossStrategy=4: two point crossover
            #     j = np.floor(rand() * Dim).astype(int)
            #     L = 0
            #     S[i] = P[i]
            #     S[i, j] = M[i, j]
            #     j = (j + 1) % Dim
            #     L += 1
            #     while rand() < CR and L < Dim:
            #         S[i, j] = M[i, j]
            #         j = (j + 1) % Dim
            #         L += 1

            else:
                raise ValueError('Invalid crossover strategy')

        return S
    
    def cross_border_inspect(self, X: np.ndarray):
        X_min = self.bounds[0]
        X_max = self.bounds[1]
        pop_size, Dim = X.shape
        # fitnessX = np.zeros(pop_size)

        for i in range(pop_size):
            for j in range(Dim):
                if X[i, j] < X_min[j]:
                    X[i, j] = X_max[j] - abs(((X[i, j] - X_min[j]) % (X_max[j] - X_min[j])))
                elif X[i, j] > X_max[j]:
                    X[i, j] = X_min[j] + abs(((X_min[j] - X[i, j]) % (X_max[j] - X_min[j])))


        return X


    def selection(self, X, C, fitnessX):
        pop_size, Dim = X.shape
        offspring = np.zeros_like(X)
        parent = np.zeros_like(X)
        fitness_off = np.zeros(pop_size)
        parent_fitness = np.zeros(pop_size)


        fitnessC = np.zeros(pop_size)
        for i in range(pop_size):
            fitnessC[i] = self.fitness_func(C[i, :])

        for i in range(pop_size):
            # maximize
            # C(i) is better
            if fitnessC[i] >= fitnessX[i]:
                offspring[i, :] = C[i, :]
                fitness_off[i] = fitnessC[i]
                parent[i, :] = X[i, :]
                parent_fitness[i] = fitnessX[i]

            else:  # fitnessC(i) <= fitnessX(i)
                offspring[i, :] = X[i, :]
                fitness_off[i] = fitnessX[i]
                parent[i, :] = C[i, :]
                parent_fitness[i] = fitnessC[i]

        return offspring, fitness_off, parent, parent_fitness



    def gp_end_condition(self, impro_tolerance, tolerance_gp, fit_improv_list, X, fitnessX, U):
        is_terminate = False

        if len(fit_improv_list) <= 1:
            return is_terminate
        # fitness 
        if np.all(fit_improv_list[-1] < impro_tolerance):
            X_train = X
            Y_train = fitnessX

            # Standardize input and output
            d_X_train = np.max(X_train, axis=0) - np.min(X_train, axis=0)
            X_mintrain = np.min(X_train, axis=0)
            X_minmaxtrain = (X_train - X_mintrain) / d_X_train

            d_Y_train = np.max(Y_train) - np.min(Y_train)
            Y_mintrain = np.min(Y_train)
            Y_minmaxtrain = (Y_train - Y_mintrain) / d_Y_train

            # Standardize the test input
            X_test = (U - X_mintrain) / d_X_train

            # Remove columns with NaN values
            nan_columns = np.any(np.isnan(X_minmaxtrain), axis=0)
            X_minmaxtrain = X_minmaxtrain[:, ~nan_columns]
            X_test = X_test[:, ~nan_columns]

            # Fit Gaussian Process Regression model
            kernel = ConstantKernel(1.0) * RBF(length_scale=1.0)
            gprMdl = GaussianProcessRegressor(kernel=kernel, normalize_y=True)
            gprMdl.fit(X_minmaxtrain, Y_minmaxtrain)

            # Make predictions
            ymu, ys = gprMdl.predict(X_test, return_std=True)

            # Transform predictions back to original scale
            Ymu_test = ymu * d_Y_train + Y_mintrain
            Ys_test = ys * d_Y_train

            # Check the end condition
            Temp = Ymu_test + 3 * Ys_test
            if (np.max(Temp) - np.max(fitnessX)) < tolerance_gp:
                is_terminate = True
        else:
            X_train = np.empty((0, X.shape[1]))
            Y_train = np.empty(0)

        return is_terminate

