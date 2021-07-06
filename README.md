# RAY SLURM 

Change submit-ray-cluster.sbatch 

Specifically:

SBATCH --ntasks=8
SBATCH --nodes=2
SBATCH --gres=gpu:4

On pascal nodes, we always use 3 cpus per gpu. 
There are 4 gpus per node. 

SBATCH --cpus-per-task=3
