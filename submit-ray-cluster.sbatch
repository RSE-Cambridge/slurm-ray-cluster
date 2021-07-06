#!/bin/bash

#SBATCH -p pascal
#SBATCH --time=00:20:00
#SBATCH --account=SUPPORT-GPU
### This script works for any number of nodes, Ray will find and manage all resources
#SBATCH --ntasks=8
#SBATCH --nodes=2
#SBATCH --gres=gpu:4

### Give all resources to a single Ray task, ray can manage the resources internally
#SBATCH --cpus-per-task=3
# #SBATCH --ntasks-per-node=1
# #SBATCH --gpus-per-task=1

# Load modules or your own conda environment here

################# DON NOT CHANGE THINGS HERE UNLESS YOU KNOW WHAT YOU ARE DOING ###############
# This script is a modification to the implementation suggest by gregSchwartz18 here:
# https://github.com/ray-project/ray/issues/826#issuecomment-522116599

export LC_ALL=en_US.utf8
export LANG=en_US.utf8

redis_password=$(uuidgen)
export redis_password

nodes=$(scontrol show hostnames $SLURM_JOB_NODELIST) # Getting the node names
echo "nodes "$nodes
nodes_array=( $nodes )

node_1=${nodes_array[0]} 
ip=$(srun --nodes=1 --ntasks=1 -w $node_1 hostname --ip-address) # making redis-address
port=6379
ip_head=$ip:$port
export ip_head
echo "IP Head: $ip_head"

echo "STARTING HEAD at $node_1"
srun --nodes=1 --ntasks=1 -w $node_1 start-head.sh $ip $redis_password &
sleep 30

worker_num=$(($SLURM_JOB_NUM_NODES - 1)) #number of nodes other than the head node
echo "worker num "$worker_num
for ((  i=1; i<=$worker_num; i++ ))
do
  node_i=${nodes_array[$i]}
  echo "STARTING WORKER $i at $node_i"
  srun --nodes=1 --ntasks=1 -w $node_i start-worker.sh $ip_head $redis_password &
  sleep 5
done
##############################################################################################

#### call your code below
python examples/mnist_pytorch_trainable.py
exit
