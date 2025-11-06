#!/bin/bash

echo "🔧 Bắt đầu thiết lập Git và SSH cho GitHub..."

### 1. Kiểm tra Git
if ! command -v git &> /dev/null; then
  echo "📦 Git chưa được cài. Đang cài..."
  sudo apt update
  sudo apt install -y git
else
  echo "✅ Git đã có: $(git --version)"
fi

### 2. Cấu hình Git (nếu chưa có)
read -p "📝 Nhập tên Git của bạn: " git_name
read -p "📧 Nhập email Git của bạn: " git_email

git config --global user.name "$git_name"
git config --global user.email "$git_email"

echo "✅ Đã cấu hình Git với tên: $git_name và email: $git_email"

### 3. Kiểm tra SSH key
SSH_KEY="$HOME/.ssh/id_ed25519"

if [ -f "$SSH_KEY" ]; then
  echo "✅ Đã có SSH key: $SSH_KEY"
else
  echo "🔐 Chưa có SSH key. Đang tạo mới..."
  ssh-keygen -t ed25519 -C "$git_email" -f "$SSH_KEY" -N ""
  echo "✅ Đã tạo SSH key mới"
fi

### 4. Khởi động ssh-agent và thêm key
eval "$(ssh-agent -s)"
ssh-add "$SSH_KEY"

### 5. Hiển thị public key để thêm vào GitHub
echo "📋 Đây là public key của bạn. Copy và thêm vào GitHub → Settings → SSH and GPG keys:"
echo "--------------------------------------------------"
cat "$SSH_KEY.pub"
echo "--------------------------------------------------"

### 6. Kiểm tra kết nối GitHub
read -p "👉 Nhấn Enter sau khi đã thêm key vào GitHub để kiểm tra kết nối..."

ssh -T git@github.com

echo "🎉 Thiết lập Git + SSH cho GitHub hoàn tất!"
