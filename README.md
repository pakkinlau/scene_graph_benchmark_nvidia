# scene_graph_benchmark_nvidia


This repository provides a 2024-reworked implementation of the Scene Graph Benchmark docker container definition, aimed at tasks like scene graph generation, object detection, and relationship detection. The current implementation is based on NVIDIA's PyTorch container with GPU acceleration, ensuring compatibility with CUDA and cuDNN.

---

## 📚 Features

- GPU-accelerated: Built using NVIDIA's base PyTorch container for CUDA-enabled GPUs.
- Dockerized Environment: Simplifies setup and ensures reproducibility.
- Scene Graph Tasks: Tools for scene graph generation, object detection, and visual relationship detection.
- PyTorch 2.x Support: Optimized for the latest GPU-accelerated PyTorch libraries.

---

## 🚀 Quick Start

### 0. Ensure System Setup for Windows Users

- Install WSL 2: Follow Microsoft's guide to set up WSL 2.
- Install NVIDIA Container Toolkit: Set up GPU support for Docker in WSL by following the NVIDIA guide.
- Install Docker with WSL Integration: Install Docker Desktop and ensure WSL integration is enabled.

### 1. Clone the Repository

```bash
git clone https://github.com/<your-username>/scene-graph-benchmark-docker.git
cd scene-graph-benchmark-docker
```

### 2. Build the Docker Image

```bash
docker-compose build
```

### 3. Run the Container

```bash
docker-compose up
```

### 4. Interact with the Container

Once the container is running, you can attach to its shell:

```bash
docker exec -it scene_graph_benchmark_docker-scene_graph_benchmark-1 zsh
```

Navigate to the project folder and test the benchmark:

```bash
cd /lab_sg_extract/scene_graph_benchmark
python tools/train_net.py --config-file configs/e2e_relation_sgdet.yml
```

---

## 🛠️ Previous Attempts and Challenges

### ❌ Attempt 1: CUDA 10.1 + cuDNN 7 + Ubuntu 18.04

The Dockerfile used the base image `nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04`. However, this image is no longer available on Docker Hub, resulting in a build failure.

---

### ❌ Attempt 2: CUDA 9.0 + cuDNN 7 + Ubuntu 16.04

The Dockerfile specified the base image `nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04`, which has been deprecated and removed from Docker Hub, causing the build to fail.

---

### ✅ Current Solution: NVIDIA PyTorch 24.10

We switched to the NVIDIA PyTorch container (`nvcr.io/nvidia/pytorch:24.10-py3`), which is actively maintained and optimized for GPU-accelerated PyTorch workflows. Before you begin, ensure the following are installed on your host system:- [Docker Engine](https://docs.docker.com/engine/install/)- [Docker Compose](https://docs.docker.com/compose/install/)- [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html)- An NVIDIA GPU with drivers installed

---

## 🧪 Testing the Environment

1. Verify GPU Access:     Run the following command inside the container to check GPU availability:   ``bash   nvidia-smi   ``
2. Check PyTorch Installation:     Verify that PyTorch is installed and working:   ``bash   python -c "import torch; print(torch.__version__)"   ``
3. Test the Training Script:     Run the scene graph benchmark training script:   ``bash   python tools/train_net.py --config-file configs/e2e_relation_sgdet.yml   ``

---

## Refactoring Considerations

While the current Docker image successfully builds and runs, there are opportunities to refactor the setup for better modularity, lightweight execution, and robustness. Here are some considerations for improvement:

- Base Image Alternatives:    Using a leaner base image (e.g., `ubuntu` or `debian`) instead of the NVIDIA PyTorch container could reduce the image size and allow for more flexibility in managing dependencies.
- Multi-Stage Builds:    Implementing multi-stage builds could separate the development environment (e.g., building and installing dependencies) from the runtime environment, resulting in a cleaner, smaller image.
- Version Pinning:    Explicitly pinning versions of CUDA, PyTorch, and other dependencies ensures stability and prevents issues caused by unexpected upstream changes.
- Automated Testing:    Integrating CI/CD pipelines to automatically test the Docker image against updates in dependencies or project scripts could ensure long-term reliability.

---

## 📝 License

This repository is licensed under the [MIT License](LICENSE), but it includes code and resources from the [Scene Graph Benchmark](https://github.com/microsoft/scene_graph_benchmark), which may have its own licensing terms. Please review their repository for details.
