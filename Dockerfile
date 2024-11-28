# Use NVIDIA's pre-built PyTorch container as the base image
# 
# Base Image Details:
# The NVIDIA container image for PyTorch, release 20.10, is available on NGC.
# This container is built on Ubuntu 18.04 and includes Python 3.6.
# Key components and libraries included in this container:
# 1. NVIDIA CUDA 11.1.0 including cuBLAS 11.2.1
# 2. NVIDIA cuDNN 8.0.4
# 3. NVIDIA NCCL 2.7.8 (optimized for NVLink™)
# 4. TensorRT 7.2.1
# 5. RAPIDS
# 6. NVIDIA Data Loading Library (DALI) 0.26.0
# 7. TensorBoard 1.15.0+nv
# 8. MAGMA 2.5.2
# 9. Nsight Compute 2020.2.0.18 and Nsight Systems 2020.3.4.32
# 10. APEX (for mixed precision training)
# 11. DLProf 0.16.0, PyProf r20.10
# 
# Deep Learning Framework Details:
# - PyTorch container image version 20.10 is based on PyTorch 1.7.0a0+7036e91
# - Includes Torch-TensorRT for optimized inference
# - Tensor Core optimized training examples: ResNet50 v1.5, Mask R-CNN, BERT, and more
# 
# Jupyter and JupyterLab:
# - Jupyter Client 6.0.0
# - Jupyter Core 4.6.1
# - Jupyter Notebook 6.0.3
# - JupyterLab 1.2.0
# - Jupyter-TensorBoard
# 
# Driver Requirements:
# - Requires NVIDIA Driver release 455 or later for most GPUs.
#   For Tesla GPUs, driver releases 418.xx, 440.30, or 450.xx are also supported (with compatibility packages).
# - Supports GPUs with CUDA compute capability 6.0 and higher (Pascal, Volta, Turing, Ampere architectures).
# 
# GPU Requirements:
# - Release 20.10 supports CUDA GPUs with compute capability 6.0 and higher.
#   For a detailed list of supported GPUs, refer to the CUDA GPUs documentation.
# 
# Deep learning framework containers 19.11 and later include experimental support for Singularity v3.0.
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
# 9. Nsight tools for profiling and debugging
# 10. MAGMA, DLProf, and PyProf
# 
# Note: It is not necessary to install the NVIDIA CUDA toolkit on the host machine, according to the official documentation.
# 
# Framework support matrix: https://docs.nvidia.com/deeplearning/frameworks/pytorch-release-notes/rel_20-10.html
# 
# The below version uses a locally pulled image. 
# Ensure you pull the image to local storage with `nvcr.io/nvidia/pytorch:20.10-py3` before building this Dockerfile.

# Use NVIDIA's pre-built PyTorch container as the base image
FROM nvcr.io/nvidia/pytorch@sha256:65cf96f16323b2af66abc08ece22f3107477037201de288913cc87b92cbfba36

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH=/opt/conda/bin:$PATH

# Upgrade to Ubuntu 20.04 and install system-level dependencies
RUN sed -i 's/bionic/focal/g' /etc/apt/sources.list && \
    apt-get update -y && \
    apt-get dist-upgrade -y && \
    apt-get install -y --no-install-recommends \
        git wget curl build-essential cmake ninja-build libglib2.0-0 \
        libsm6 libxext6 libxrender-dev libyaml-dev libjpeg-dev libpng-dev \
        zlib1g-dev vim software-properties-common tmux && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Remove system-level OpenCV libraries if present
RUN apt-get purge -y libopencv* && apt-get autoremove -y

# Uninstall any conflicting Python OpenCV packages
RUN pip uninstall -y opencv-python opencv-python-headless

# Install the correct version of OpenCV
RUN pip install --no-cache-dir --force-reinstall opencv-python-headless==4.5.5.64

# Install Python dependencies with pip
RUN pip install --no-cache-dir \
    pycocotools==2.0.6 \
    yacs==0.1.8 \
    numpy==1.19.5 \
    matplotlib==3.3.4

# Clone and install the Scene Graph Benchmark library
RUN git clone https://github.com/microsoft/scene_graph_benchmark.git /lab_sg_extract/scene_graph_benchmark && \
    cd /lab_sg_extract/scene_graph_benchmark && \
    python setup.py build develop

# Set working directory
WORKDIR /lab_sg_extract

# Default to Bash for interactive usage
CMD ["bash"]