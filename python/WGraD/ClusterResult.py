


import numpy as np

from collections import defaultdict
from typing import Dict, List, Tuple


class ClusterResult:
    def __repr__(self) -> str:
        return f"<Cluster Result> {self.num_dimension} dimension {self.num_samples} samples"

    def __init__(
            self, 
            X: np.ndarray, 
            fitness: np.ndarray, 
            indices: List[int], 
            node_to_parent: Dict[int, int], # {node: parent}
            edges: List[Tuple[np.ndarray, np.ndarray]], 
            num_dimension: int
        ) -> None:
        assert X.shape[1] == num_dimension
        self._indices = indices
        self._X = X
        self._fitness = fitness

        self.num_samples = X.shape[0]
        self.num_dimension = num_dimension
        self.edges = edges
        self.node_to_parent = node_to_parent
        return
    
    @property
    def X(self) -> np.ndarray:
        """
        (n x d) sample matrix
        n: the number of samples in this cluster
        d: dimension, the number of variables
        """
        return self._X
    
    
    @property
    def indices(self) -> List[int]:
        """
        (n) sample vector
        n: the number of samples in this cluster

        return the index of each sample
        """
        return self._indices
    
    @property
    def fitness(self) -> np.ndarray:
        """
        (n x 1) fitness vector
        n: the number of samples in this cluster
        """
        return self._fitness