#!/bin/bash

# Lấy đường dẫn tuyệt đối đến thư mục chứa script này
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔧 Bắt đầu thiết lập cấu hình từ: $SCRIPT_DIR"

### 1. Backup và copy .tmux.conf
if [ -f "$HOME/.tmux.conf" ]; then
  cp -v "$HOME/.tmux.conf" "$HOME/.tmux.conf.bak"
  echo "🗂️ Đã backup .tmux.conf thành .tmux.conf.bak"
fi

if [ -f "$SCRIPT_DIR/.tmux.conf" ]; then
  cp -v "$SCRIPT_DIR/.tmux.conf" "$HOME/.tmux.conf"
  echo "✅ Đã copy .tmux.conf mới vào ~/"
else
  echo "⚠️ Không tìm thấy .tmux.conf trong $SCRIPT_DIR"
fi

### 2. Cài TPM nếu chưa có
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
  echo "📦 Đang cài đặt TPM..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
  echo "✅ TPM đã được cài"
fi

### 3. Kiểm tra Node.js
if ! command -v node &> /dev/null; then
  echo "📦 Node.js chưa được cài. Đang cài bằng NVM..."

  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

  export NVM_DIR="$HOME/.nvm"
  source "$NVM_DIR/nvm.sh"

  nvm install --lts
  echo "✅ Đã cài Node.js phiên bản LTS"
else
  echo "✅ Node.js đã được cài: $(node -v)"
fi

### 4. Kiểm tra LazyVim
NVIM_INIT="$HOME/.config/nvim/init.lua"
if [ -f "$NVIM_INIT" ] && grep -q "LazyVim" "$NVIM_INIT"; then
  echo "✅ LazyVim đã được cài. Bỏ qua bước cài đặt."
else
  echo "📦 Đang backup cấu hình Neovim hiện tại..."

  mv -v "$HOME/.config/nvim" "$HOME/.config/nvim.bak" 2>/dev/null
  mv -v "$HOME/.local/share/nvim" "$HOME/.local/share/nvim.bak" 2>/dev/null
  mv -v "$HOME/.local/state/nvim" "$HOME/.local/state/nvim.bak" 2>/dev/null
  mv -v "$HOME/.cache/nvim" "$HOME/.cache/nvim.bak" 2>/dev/null

  echo "🚀 Đang clone LazyVim Starter..."
  git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"

  echo "🧹 Đang xoá thư mục .git để bạn có thể thêm vào repo của mình"
  rm -rf "$HOME/.config/nvim/.git"

  echo "✅ Đã cài đặt LazyVim! Bạn có thể mở Neovim bằng lệnh: nvim"
fi

echo "🎉 Thiết lập hoàn tất!"
