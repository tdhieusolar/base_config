#!/bin/bash

echo "🔧 Bắt đầu cài đặt và cấu hình công cụ lập trình viên..."

### 1. Cài các công cụ tiện ích qua apt
echo "📦 Đang cài ripgrep, fd, bat, fzf, htop, neofetch, gh, zsh..."
sudo apt update
sudo apt install -y ripgrep fd-find bat fzf htop neofetch gh zsh

### 2. Cài lazygit từ GitHub nếu chưa có
if ! command -v lazygit &> /dev/null; then
  echo "📦 Đang cài lazygit từ GitHub..."
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep tag_name | cut -d '"' -f4)
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION#v}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit /usr/local/bin
  rm lazygit lazygit.tar.gz
  echo "✅ lazygit đã được cài"
else
  echo "✅ lazygit đã có: $(lazygit --version)"
fi

### 3. Cài oh-my-zsh nếu chưa có
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "✨ Đang cài oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "✅ oh-my-zsh đã được cài"
fi

### 4. Cấu hình .zshrc
ZSHRC="$HOME/.zshrc"
echo "🛠️ Đang cấu hình .zshrc..."

# Đổi theme và plugin
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

### 5. Đặt zsh làm shell mặc định
ZSH_PATH=$(which zsh)
if [ "$SHELL" != "$ZSH_PATH" ]; then
  echo "🔄 Đang đặt zsh làm shell mặc định..."
  chsh -s "$ZSH_PATH"
else
  echo "✅ zsh đã là shell mặc định"
fi

echo "🎉 Thiết lập công cụ lập trình viên hoàn tất! Mở terminal mới để áp dụng cấu hình."
