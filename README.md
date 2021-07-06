# RAY SLURM 

forked from NERSC/slurm-ray-cluster: https://github.com/NERSC/slurm-ray-cluster

To change resources modify: submit-ray-cluster.sbatch 


Specifically:

SBATCH --ntasks=8
SBATCH --nodes=2
SBATCH --gres=gpu:4

This will run 8 tasks on 2 gpu nodes, using 8 gpus and 24 cpus. 

On pascal nodes, we always use 3 cpus per gpu. 
There are 4 gpus per node. 

SBATCH --cpus-per-task=3

It's possible to run just with one GPU:

SBATCH --ntasks=1
SBATCH --nodes=1
SBATCH --gres=gpu:1

And with two GPUs per node

SBATCH --ntasks=2
SBATCH --nodes=1
SBATCH --gres=gpu:2

