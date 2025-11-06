#!/bin/bash

# Đường dẫn đến thư mục CONFIG
CONFIG="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔧 Bắt đầu thiết lập cấu hình..."

### 1. Tạo symbolic link cho .tmux.conf
if [ -f "$CONFIG/.tmux.conf" ]; then
  ln -sf "$CONFIG/.tmux.conf" "$HOME/.tmux.conf"
  echo "✅ Đã tạo symbolic link cho .tmux.conf"
else
  echo "⚠️ Không tìm thấy $CONFIG/.tmux.conf"
fi

### 2. Cài đặt TPM nếu chưa có
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
  echo "📦 Đang cài đặt TPM..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
  echo "✅ TPM đã được cài"
fi

### 3. Tạo symbolic link cho cấu hình Neovim
NVIM_SOURCE="$CONFIG/.config/nvim"
NVIM_TARGET="$HOME/.config/nvim"

if [ -d "$NVIM_SOURCE" ]; then
  mkdir -p "$HOME/.config"
  ln -sfn "$NVIM_SOURCE" "$NVIM_TARGET"
  echo "✅ Đã tạo symbolic link cho cấu hình Neovim"
else
  echo "⚠️ Không tìm thấy thư mục $NVIM_SOURCE"
fi

echo "🎉 Thiết lập hoàn tất!"
