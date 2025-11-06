#!/bin/bash

# Đường dẫn đến thư mục CONFIG
CONFIG="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔧 Bắt đầu thiết lập cấu hình..."

### 1. Backup và copy .tmux.conf
if [ -f "$HOME/.tmux.conf" ]; then
  cp -v "$HOME/.tmux.conf" "$HOME/.tmux.conf.bak"
  echo "🗂️ Đã backup .tmux.conf thành .tmux.conf.bak"
fi

if [ -f "$CONFIG/.tmux.conf" ]; then
  cp -v "$CONFIG/.tmux.conf" "$HOME/.tmux.conf"
  echo "✅ Đã copy .tmux.conf mới vào ~/"
else
  echo "⚠️ Không tìm thấy .tmux.conf trong $CONFIG"
fi
### 2. Cài đặt TPM nếu chưa có
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
  echo "📦 Đang cài đặt TPM..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
  echo "✅ TPM đã được cài"
fi

### 3. Cài đặt LazyVim Starter cho Neovim
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
echo "🎉 Thiết lập hoàn tất!"
