#!/bin/sh
# Срабатывает после RESOLVE зависимостей и до СБОРКИ проекта

# Переход в папку с проектом
cd /Volumes/workspace/repository/

# Обновление файла с версиями
echo "MARKETING_VERSION=1.$CI_BUILD_NUMBER" > Encryption-Files.xcconfig
echo "CURRENT_PROJECT_VERSION=$CI_BUILD_NUMBER" >> Encryption-Files.xcconfig

# Печать новых версий в консоль
echo "✅ MARKETING_VERSION=1.$CI_BUILD_NUMBER"
echo "✅ CURRENT_PROJECT_VERSION=$CI_BUILD_NUMBER"