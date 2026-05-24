#!/bin/bash
# web/index.html のプレースホルダーを .env の値で置換する
# 使い方: ./scripts/inject_api_keys.sh
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
ENV_FILE="$ROOT_DIR/.env"
INDEX_HTML="$ROOT_DIR/web/index.html"

if [ ! -f "$ENV_FILE" ]; then
  echo "エラー: .env ファイルが見つかりません。.env.example をコピーして作成してください。"
  echo "  cp .env.example .env"
  exit 1
fi

# .env を読み込む（コメント行・空行は無視）
export $(grep -v '^\s*#' "$ENV_FILE" | grep -v '^\s*$' | xargs)

if [ -z "$GOOGLE_MAPS_API_KEY" ]; then
  echo "エラー: .env に GOOGLE_MAPS_API_KEY が設定されていません。"
  exit 1
fi

sed -i "s|__GOOGLE_MAPS_API_KEY__|$GOOGLE_MAPS_API_KEY|g" "$INDEX_HTML"
echo "APIキーの注入が完了しました: web/index.html"
