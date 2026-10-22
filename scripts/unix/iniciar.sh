#!/usr/bin/env bash
set -e
cd -- "$(dirname -- "$0")/../.."
if ! command -v flutter >/dev/null 2>&1; then
  echo 'Flutter não encontrado. Consulte docs/COMO_EXECUTAR.md.'
  exit 1
fi
flutter pub get
flutter run -d chrome --no-web-resources-cdn
