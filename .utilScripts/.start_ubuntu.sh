###################################
# Update and Upgrade
###################################
echo
echo "Updating and upgrading..."
echo
apt update && apt upgrade -y

# Install Curl, wget and build-essential
sudo apt-get install build-essential wget curl

# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
# Load NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install latest version of Node.js
nvm install node

# Install Yarn
npm install -g yarn

# Install CUDA
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.0-1_all.deb
sudo dpkg -i cuda-keyring_1.0-1_all.deb
sudo apt-get update
sudo apt-get -y install cuda

# Find latest Miniconda version
MINICONDA_VERSION=$(curl -s https://repo.anaconda.com/miniconda/ | grep -o 'Miniconda3-[0-9]\+\.[0-9]\+\.[0-9]\+-Linux-x86_64.sh' | sort -rV | head -n1)

# Download and install Miniconda
wget https://repo.anaconda.com/miniconda/$MINICONDA_VERSION -O miniconda.sh
bash miniconda.sh -b -p $HOME/miniconda3
rm miniconda.sh

# Initialize conda
eval "$(/home/aman/miniconda3/bin/conda shell.bash hook)"

# Find latest available CUDA version
CUDA_VERSION=$(conda search -c nvidia -c conda-forge -f cudatoolkit --json | jq '.[0].version' -r)

# Create PyTorch environment
conda create -y -n pytorchenv python
conda activate pytorchenv
pip install torch torchvision torchaudio
conda install -y jupyterlab scikit-learn pandas numpy matplotlib
pip install opencv-python
python -m ipykernel install --user --name pytorchenv --display-name "PyTorch"

# Create Keras environment
conda create -y -n kerasenv python
conda activate kerasenv
conda install -y tensorflow-gpu jupyterlab scikit-learn pandas numpy matplotlib keras
pip install opencv-python
python -m ipykernel install --user --name kerasenv --display-name "Keras"


# Add conda environments to JupyterLab
$HOME/miniconda3/bin/jupyter labextension install @jupyter-widgets/jupyterlab-manager
$HOME/miniconda3/bin/jupyter labextension install jupyter-matplotlib


source ~/.zshrc

echo "installation and environment setup complete!"