# Use NVIDIA's pre-built PyTorch container as the base image
# Prerequisites (from: https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch):
# 1. Docker engine
# 2. NVIDIA GPU driver (host machine)
# 3. NVIDIA Container Toolkit
# 4. It is not necessary to install the NVIDIA CUDA toolkit on the host machine according to the official documentation.
# 
# What is included in this container:
# 1. CUDA
# 2. cuBLAS
# 3. cuDNN - NVIDIA Deep Neural Network Library
# 4. NCCL - NVIDIA Collective Communications Library for multi-GPU and multi-node communication primitives
# 5. RAPIDS
# 6. NVIDIA Data Loading Library (DALI) - accelerated data loading and augmentation library
# 7. TensorRT
# 8. Torch-TensorRT

# Use NVIDIA's pre-built PyTorch container as the base image

# Framework support matrix: https://docs.nvidia.com/deeplearning/frameworks/pytorch-release-notes/rel_20-12.html#rel_20-12
# credential error might be triggered in this step so it is not recommended to do this one. 
# FROM nvcr.io/nvidia/pytorch20.10-py3

# The below version use local image. 
# You need to pull the image to local with `nvcr.io/nvidia/pytorch:20.10-py3` before this step. 
# Use NVIDIA's pre-built PyTorch container as the base image
FROM nvcr.io/nvidia/pytorch@sha256:65cf96f16323b2af66abc08ece22f3107477037201de288913cc87b92cbfba36

# Set the working directory inside the container
WORKDIR /lab_sg_extract

# Install required system packages for compilation and runtime
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    git curl ca-certificates cmake build-essential tree htop bmon iotop ninja-build make \
    libglib2.0-0 libsm6 libxext6 libxrender-dev libyaml-dev libjpeg-dev libpng-dev \
    zlib1g-dev vim zsh wget tmux gawk coreutils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN curl -so /miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    chmod +x /miniconda.sh && \
    /miniconda.sh -b -p /miniconda && \
    rm /miniconda.sh

# Set Conda environment variables
ENV PATH=/miniconda/bin:$PATH

# Create and activate a Conda environment
RUN conda create -y --name py38 python=3.8 && \
    conda install -y -n py38 pytorch==1.7.0 torchvision==0.8.1 cudatoolkit=11.0 -c pytorch -c nvidia && \
    conda install -y -n py38 numpy>=1.19.5 matplotlib opencv tqdm yacs>=0.1.8 cython -c defaults && \
    conda install -y -n py38 pycocotools -c conda-forge && \
    conda clean -ya

# Set the default Conda environment
ENV CONDA_DEFAULT_ENV=py38
ENV CONDA_PREFIX=/miniconda/envs/${CONDA_DEFAULT_ENV}
ENV PATH=${CONDA_PREFIX}/bin:${PATH}

# Clone the Microsoft Scene Graph Benchmark repository
RUN git clone https://github.com/microsoft/scene_graph_benchmark.git /lab_sg_extract/scene_graph_benchmark

# Compile and install the Scene Graph Benchmark package
RUN cd /lab_sg_extract/scene_graph_benchmark && \
    python setup.py build develop

# Set the default shell to Zsh for interactive usage
CMD ["zsh"]