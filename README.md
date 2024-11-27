# scene_graph_benchmark_nvidia

This repository provides a **November-2024-reworked** implementation of the Scene Graph Benchmark Docker container definition, aimed at tasks like scene graph generation, object detection, and relationship detection. The current implementation is based on NVIDIA's PyTorch container with GPU acceleration, ensuring compatibility with CUDA and cuDNN.

> Note: While we are actively working on a research project involving this package, further details regarding our lab and research focus will be shared at a later date.

---

## 🛠️ Challenges and Solutions

### ❌ Previous Attempts by Other Developers 

1. **[2020 Dockerfile by Microsoft (not maintained, component outdated)](https://github.com/microsoft/scene_graph_benchmark/blob/main/docker/Dockerfile)**  
   - **Base Image**: `nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04`.  
   - **Issue**: Image no longer available on Docker Hub, leading to build failures.
![](snapshots/microsoft%20result.png)

2. **[2020 Refactored Dockerfile (not maintained, component outdated)](https://github.com/microsoft/scene_graph_benchmark/blob/main/docker/Dockerfile)**  
   - **Base Image**: `nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04`.  
   - **Issue**:  The image is outdated and removed from Docker Hub. Additionally, it uses PyTorch Nightly (pre-release), which is not ideal for production environments and leads to potential compatibility issues with newer dependencies.
![](snapshots/1st%20refactoring%20result.png)

### ✅ The New Build in November 2024: 

3. **2024 Refactored Dockerfile Using NVIDIA NGC (current repository)**
   - **Base Image**: `nvcr.io/nvidia/pytorch20.10-py3`.
   - No issue when running the container.
![](snapshots/2nd%20refactoring%20result.png)
![](snapshots/2nd%20refactoring%20result2.png)

---

### **Key Features**:  

  - Compatible with VSCode, as VSCode [stop supporting](https://code.visualstudio.com/docs/remote/faq#_what-linux-packages-or-libraries-need-to-be-installed-on-a-host-to-use-remote-development) ubuntu 18.04 or earlier version. 
  - Based on NVIDIA NGC's [optimized PyTorch container](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch/tags), which includes pre-installed CUDA, cuDNN, NCCL, and other essential libraries for deep learning.  
  - Supports Python 3.8 via Miniconda and includes PyTorch 1.7.0 with CUDA 11.0.  
  - Ensures compatibility with Tested framework support matrix (PyTorch1.7 + CUDA 11.0 + Ubuntu 20.04 + Latest VSCode. )
  - Simplifies GPU runtime configuration using Docker Compose with `runtime: nvidia` and explicit GPU environment variables.  
  - Includes robust volume mapping for data, models, and output, enabling seamless interaction with host resources.  
  - Optimized for multi-GPU setups but also configurable for single-GPU use via environment variables.  


We switched to the NVIDIA PyTorch container (`nvcr.io/nvidia/pytorch:24.10-py3`), which is actively maintained by Nvidia NGC.

---

## 🛠️ **Discussion 1: Why choosing NVIDIA NGC?**

Compared to other standalone PyTorch containers or custom Dockerfiles, **NVIDIA NGC containers** offer the following advantages:

1. **Tested Compatibility**:  
   - NVIDIA rigorously tests their containers to ensure compatibility across **CUDA**, **PyTorch**, and system libraries.  
   - This repository uses NVIDIA's PyTorch container (`nvcr.io/nvidia/pytorch20.10-py3`), which includes **CUDA 11.0**, **cuDNN**, **NCCL**, and other essential deep learning frameworks.  

2. **Pre-installed Optimizations**:  
   - NVIDIA NGC containers come with pre-installed libraries, eliminating the need to manually configure CUDA and other GPU dependencies.  
   - These containers are optimized for multi-GPU setups, providing better performance for both training and inference tasks.  

3. **Ongoing Maintenance**:  
   - NVIDIA actively maintains and updates their NGC containers to ensure compatibility with the latest hardware and software stacks.  
   - Outdated base images often used in other implementations (e.g., Ubuntu 16.04 or CUDA 9.0) can lead to build failures and compatibility issues.

4. **Simplified GPU Configuration**:  
   - The repository is pre-configured to work with NVIDIA's `runtime: nvidia` in Docker Compose, ensuring seamless GPU access.  

---

## 🛠️  **Discussion 2: Compatibility Consideration**

This package is specifically designed to address common compatibility issues encountered in Scene Graph Benchmark implementations:

1. **Ubuntu Compatibility**:  
   - The NVIDIA NGC container is based on **Ubuntu 20.04**, providing compatibility with modern CUDA and PyTorch versions.  
   - Using older Ubuntu versions (e.g., 18.04 or 16.04) can lead to dependency conflicts with CUDA 11.0 or newer.  

2. **CUDA and PyTorch**:  
   - The repository uses **PyTorch 1.7** with **CUDA 11.0**, ensuring compatibility with NVIDIA's framework support matrix.  
   - Using unsupported CUDA versions (e.g., 10.x) with PyTorch 1.7 will result in runtime errors.  

3. **VS Code Development**:  
   - The container is compatible with VS Code's **Remote - Containers** extension, allowing seamless remote development.

---

## 📦 How To Use It? Pre-Built Docker Image on Docker Hub

**Pull the Pre-Built Image**  
```bash
docker pull pakkinlau/scene_graph_benchmark_nvidia:latest
```

**Run the Container**  
```bash
docker run --runtime=nvidia --gpus all -it your_username/scene_graph_benchmark:latest zsh
```

---

## 🚀 How To Change It? Developing This Image

**1. System Requirements**

Ensure the following are installed on your host system:

- **[Docker Engine](https://docs.docker.com/engine/install)**  
- **[Docker Compose](https://docs.docker.com/compose/install)**  
- **[NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html)**  
- **NVIDIA GPU** with up-to-date drivers installed.  

> For **Windows Users**:  
> - Install **WSL 2** (Windows Subsystem for Linux).  
> - Set up GPU support for Docker in WSL using NVIDIA's container toolkit.  
> - Install Docker Desktop and enable WSL integration.

---

**2. NVIDIA NGC Authentication**

The NVIDIA PyTorch container is hosted on **NVIDIA NGC**, which may require authentication for private images. Follow these steps to log in and pull the container:

Step 1: Create an NVIDIA NGC Account
- Go to [NVIDIA NGC](https://ngc.nvidia.com/signup) and create an account.

Step 2: Generate an API Key
- Log in to your NGC account.
- Navigate to the **API Key** page: [NGC API Key](https://ngc.nvidia.com/setup/api-key).
- Click **Generate API Key** and copy the key.

Step 3: Log in to NVIDIA NGC
Run the following command and provide your credentials:
```bash
docker login nvcr.io
```
- **Username**: `$oauthtoken`  
- **Password**: The API key you just generated.

Step 4: Pull the Docker Image
Once logged in, pull the NVIDIA PyTorch container:
```bash
docker pull nvcr.io/nvidia/pytorch:24.10-py3
```

---

**3. Clone the Repository**

```bash
git clone https://github.com/pakkinlau/scene_graph_benchmark_nvidia.git
cd scene_graph_benchmark_nvidia
```

**4. Build the Docker Image**

```bash
docker-compose build
```

**5. Run the Container**

```bash
docker-compose up
```

**6. Interact with the Container**

Attach to the running container's shell:
```bash
docker exec -it scene_graph_benchmark_docker-scene_graph_benchmark-1 zsh
```

Run the benchmark training script:
```bash
cd /lab_sg_extract/scene_graph_benchmark
python tools/train_net.py --config-file configs/e2e_relation_sgdet.yml
```

---

## 🧪 Testing the Environment

1. **Verify GPU Access**  
   Run the following command inside the container:
   ```bash
   nvidia-smi
   ```

2. **Check PyTorch Installation**  
   Verify that PyTorch is installed and working:
   ```bash
   python -c "import torch; print(torch.__version__)"
   ```

3. **Install Scene Graph package**
   Run this command to install the package right after running the container.
   ```
   python /lab_sg_extract/scene_graph_benchmark/setup.py install
   ```

5. **Test the Training Script**  
   Run the scene graph benchmark training script:
   ```bash
   python tools/train_net.py --config-file configs/e2e_relation_sgdet.yml
   ```

---

## Refactoring Considerations

While the current Docker image successfully builds and runs, there are opportunities to refactor the setup for better modularity, lightweight execution, and robustness:

- **Base Image Alternatives**: Use a lighter base image (e.g., `ubuntu`) to reduce image size.  
- **Multi-Stage Builds**: Separate the development and runtime environments to create a cleaner, smaller image.  
- **Version Pinning**: Pin versions of CUDA, PyTorch, and dependencies to ensure stability.  
- **Automated Testing**: Integrate CI/CD pipelines to automatically test the Docker image against updates.  

---

## 📝 License

This repository is licensed under the [MIT License](LICENSE), but it includes code and resources from the [Scene Graph Benchmark](https://github.com/microsoft/scene_graph_benchmark), which may have its own licensing terms. Please review their repository for details.

