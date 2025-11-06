#!/bin/bash

echo "🔧 Bắt đầu cài đặt và cấu hình công cụ lập trình viên..."

### 1. Cài các công cụ tiện ích
echo "📦 Đang cài ripgrep, fd, bat, fzf, htop, neofetch, gh, lazygit, zsh..."
sudo apt update
sudo apt install -y ripgrep fd-find bat fzf htop neofetch gh lazygit zsh

### 2. Cài oh-my-zsh nếu chưa có
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "✨ Đang cài oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "✅ oh-my-zsh đã được cài"
fi

### 3. Cấu hình .zshrc
ZSHRC="$HOME/.zshrc"

echo "🛠️ Đang cấu hình .zshrc..."

# Thêm theme và plugin
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="agnoster"/' "$ZSHRC"
sed -i 's/^plugins=.*/plugins=(git fzf z)/' "$ZSHRC"

# Thêm alias và cấu hình tiện lợi
cat << 'EOF' >> "$ZSHRC"

# Alias tiện dụng
alias cat='batcat'
alias find='fd'
alias grep='rg'
alias lg='lazygit'
alias gs='git status'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'

# FZF mặc định dùng fd
export FZF_DEFAULT_COMMAND='fd --type f'
EOF

echo "✅ Đã cấu hình .zshrc"

### 4. Đặt zsh làm shell mặc định
if [ "$SHELL" != "/usr/bin/zsh" ]; then
  echo "🔄 Đang đặt zsh làm shell mặc định..."
  chsh -s $(which zsh)
else
  echo "✅ zsh đã là shell mặc định"
fi

echo "🎉 Thiết lập công cụ lập trình viên hoàn tất! Mở terminal mới để áp dụng cấu hình."
