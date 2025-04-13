# install-chayka43-repo.sh
#!/bin/bash

set -e

echo "🔑 Импортируем GPG ключ..."
curl -fsSL https://chayka43.github.io/debian/public_key.asc | sudo tee /etc/apt/trusted.gpg.d/chayka43-debian.asc > /dev/null

echo "📦 Добавляем репозиторий..."
echo "deb https://chayka43.github.io/debian stable main" | sudo tee /etc/apt/sources.list.d/chayka43-debian.list > /dev/null

echo "🌀 Обновляем индексы пакетов..."
sudo apt update

echo "✅ Репозиторий подключён!"
