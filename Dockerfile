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
FROM nvcr.io/nvidia/pytorch20.10-py3

# -------------------------------
# 1. Conda Environment Variables
# -------------------------------
ENV CONDA_DEFAULT_ENV=py38
ENV CONDA_PREFIX=/miniconda/envs/${CONDA_DEFAULT_ENV}

# -------------------------------
# 2. CUDA Environment Variables
# -------------------------------
ENV CUDA_HOME=/usr/local/cuda
ENV LD_LIBRARY_PATH=${CUDA_HOME}/lib64:${LD_LIBRARY_PATH}

# -------------------------------
# 3. Define Custom PATH Variable
# -------------------------------
ENV CONTAINER_PATH=${CUDA_HOME}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:${CONDA_PREFIX}/bin:/miniconda/bin
ENV PATH=${CONTAINER_PATH}

# -------------------------------
# 4. Python Environment Variables
# -------------------------------
ENV PYTHONIOENCODING=UTF-8
ENV PYTHONDONTWRITEBYTECODE=1

# -------------------------------
# 5. Application-Specific Variables
# -------------------------------
ENV APP_HOME=/lab_sg_extract
WORKDIR ${APP_HOME}

# -------------------------------
# System Setup and Installation
# -------------------------------
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    git curl ca-certificates bzip2 cmake tree htop bmon iotop ninja-build make \
    libglib2.0-0 libsm6 libxext6 libxrender-dev libyaml-dev libjpeg-dev libpng-dev \
    zlib1g-dev vim zsh wget tmux python3-dev build-essential \
    gawk coreutils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN curl -so /miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    chmod +x /miniconda.sh && \
    /miniconda.sh -b -p /miniconda && \
    rm /miniconda.sh

# Create and activate the Conda environment
RUN /miniconda/bin/conda create -y --name ${CONDA_DEFAULT_ENV} python=3.8 && \
    /miniconda/bin/conda install -y -n ${CONDA_DEFAULT_ENV} conda-build && \
    /miniconda/bin/conda clean -ya

# Install Python and additional dependencies in the Conda environment
RUN /miniconda/bin/conda run -n ${CONDA_DEFAULT_ENV} conda install -y ipython h5py nltk joblib jupyter pandas scipy && \
    /miniconda/bin/conda run -n ${CONDA_DEFAULT_ENV} pip install requests yacs>=0.1.8 numpy>=1.19.5 matplotlib opencv-python tqdm \
    protobuf tensorboardx pymongo scikit-learn boto3 scikit-image cityscapesscripts && \
    /miniconda/bin/conda run -n ${CONDA_DEFAULT_ENV} pip install azureml-defaults>=1.0.45 azureml.core inference-schema && \
    /miniconda/bin/conda run -n ${CONDA_DEFAULT_ENV} pip --no-cache-dir install --force-reinstall -I pyyaml && \
    /miniconda/bin/conda run -n ${CONDA_DEFAULT_ENV} conda install -y -c conda-forge pycocotools timm einops cython

# Download NLTK data (e.g., tokenizer)
RUN /miniconda/bin/conda run -n ${CONDA_DEFAULT_ENV} python -m nltk.downloader punkt

# Clone the repository into a subdirectory of the working directory
RUN git clone https://github.com/microsoft/scene_graph_benchmark.git ${APP_HOME}/scene_graph_benchmark && \
    cd ${APP_HOME}/scene_graph_benchmark && \
    /miniconda/bin/conda run -n ${CONDA_DEFAULT_ENV} python setup.py build develop

# Default to zsh shell
CMD [ "zsh" ]