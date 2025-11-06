#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "🔧 Bắt đầu thiết lập môi trường lập trình từ: $SCRIPT_DIR"

### 0. Kiểm tra Git
if ! command -v git &> /dev/null; then
  echo "📦 Git chưa được cài. Đang cài..."
  sudo apt update
  sudo apt install -y git
else
  echo "✅ Git đã có: $(git --version)"
fi

### 1. Cài Node.js bằng NVM nếu chưa có
if ! command -v node &> /dev/null; then
  echo "📦 Node.js chưa có. Đang cài bằng NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  source "$NVM_DIR/nvm.sh"
  nvm install --lts
  echo "✅ Node.js: $(node -v)"
else
  echo "✅ Node.js đã có: $(node -v)"
fi

### 2. Cài Rust nếu chưa có
if ! command -v rustc &> /dev/null; then
  echo "📦 Rust chưa có. Đang cài..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
  echo "✅ Rust: $(rustc --version)"
else
  echo "✅ Rust đã có: $(rustc --version)"
fi

### 3. Cài Python3 nếu chưa có
if ! command -v python3 &> /dev/null; then
  echo "📦 Python3 chưa có. Đang cài..."
  sudo apt update
  sudo apt install -y python3 python3-pip
  echo "✅ Python3: $(python3 --version)"
else
  echo "✅ Python3 đã có: $(python3 --version)"
fi

### 4. Cài Docker nếu chưa có
if ! command -v docker &> /dev/null; then
  echo "📦 Docker chưa có. Đang cài..."
  sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt update
  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sudo systemctl enable docker
  sudo systemctl start docker
  echo "✅ Docker: $(docker --version)"
else
  echo "✅ Docker đã có: $(docker --version)"
fi

### 5. Cài .tmux.conf và TPM
if [ -f "$HOME/.tmux.conf" ]; then
  cp -v "$HOME/.tmux.conf" "$HOME/.tmux.conf.bak"
  echo "🗂️ Backup .tmux.conf thành .tmux.conf.bak"
fi

if [ -f "$SCRIPT_DIR/.tmux.conf" ]; then
  cp -v "$SCRIPT_DIR/.tmux.conf" "$HOME/.tmux.conf"
  echo "✅ Đã copy .tmux.conf mới vào ~/"
else
  echo "⚠️ Không tìm thấy .tmux.conf trong $SCRIPT_DIR"
fi

TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
  echo "📦 Đang cài TPM..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
  echo "✅ TPM đã có"
fi

### 6. Kiểm tra và cập nhật Neovim nếu cần
echo "🔍 Đang kiểm tra phiên bản Neovim..."

LATEST_NVIM=$(curl -s https://neovim.io | grep -oP 'Neovim \K[0-9]+\.[0-9]+' | head -n 1)
INSTALLED_NVIM=$(nvim --version 2>/dev/null | head -n 1 | awk '{print $2}')

if ! command -v nvim &> /dev/null; then
  echo "📦 Neovim chưa có. Đang cài bản mới nhất..."
  INSTALL_NVIM=true
elif [ "$(printf '%s\n' "$LATEST_NVIM" "$INSTALLED_NVIM" | sort -V | head -n1)" != "$LATEST_NVIM" ]; then
  echo "⚠️ Neovim hiện tại ($INSTALLED_NVIM) cũ hơn bản mới nhất ($LATEST_NVIM). Đang cập nhật..."
  sudo apt remove -y neovim
  INSTALL_NVIM=true
else
  echo "✅ Neovim đã có phiên bản mới: $INSTALLED_NVIM"
  INSTALL_NVIM=false
fi

if [ "$INSTALL_NVIM" = true ]; then
  sudo apt install -y ninja-build gettext cmake unzip curl build-essential
  git clone https://github.com/neovim/neovim.git ~/neovim
  cd ~/neovim
  make CMAKE_BUILD_TYPE=Release
  sudo make install
  cd ~
  rm -rf ~/neovim
  echo "✅ Neovim đã được cài: $(nvim --version | head -n 1)"
fi

### 7. Cài LazyVim nếu chưa có
NVIM_INIT="$HOME/.config/nvim/init.lua"
if [ -f "$NVIM_INIT" ] && grep -q "LazyVim" "$NVIM_INIT"; then
  echo "✅ LazyVim đã có. Bỏ qua."
else
  echo "📦 Backup cấu hình Neovim hiện tại..."
  mv -v "$HOME/.config/nvim" "$HOME/.config/nvim.bak" 2>/dev/null
  mv -v "$HOME/.local/share/nvim" "$HOME/.local/share/nvim.bak" 2>/dev/null
  mv -v "$HOME/.local/state/nvim" "$HOME/.local/state/nvim.bak" 2>/dev/null
  mv -v "$HOME/.cache/nvim" "$HOME/.cache/nvim.bak" 2>/dev/null

  echo "🚀 Clone LazyVim Starter..."
  git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
  rm -rf "$HOME/.config/nvim/.git"
  echo "✅ LazyVim đã cài! Mở bằng: nvim"
fi

echo "🎉 Thiết lập hoàn tất!"
